--
-- Copyright 2018, Data61
-- Commonwealth Scientific and Industrial Research Organisation (CSIRO)
-- ABN 41 687 119 230.
--
-- This software may be distributed and modified according to the terms of
-- the GNU General Public License version 2. Note that NO WARRANTY is provided.
-- See "LICENSE_GPLv2.txt" for details.
--
-- @TAG(DATA61_GPL)
--

{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TupleSections #-}

module Cogent.TypeCheck (
  tc
) where

import Cogent.Compiler
import qualified Cogent.Context as C
import Cogent.PrettyPrint (prettyC)
import Cogent.Surface
import Cogent.TypeCheck.Base
import Cogent.TypeCheck.Generator
import Cogent.TypeCheck.Post (postT, postE, postA)
import Cogent.TypeCheck.Solver
import Cogent.TypeCheck.Subst (applyE, applyAlts)
import Cogent.TypeCheck.Util
import Cogent.Util (firstM)

import Control.Arrow (first, second)
import Control.Lens
-- import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Trans.Maybe
-- import Control.Monad.Writer hiding (censor)
-- import Data.Either (lefts)
import Data.List (nub, (\\))
import qualified Data.Map as M
import Data.Monoid ((<>))
import qualified Data.Sequence as Seq
import Text.Parsec.Pos
import qualified Text.PrettyPrint.ANSI.Leijen as L
import Text.PrettyPrint.ANSI.Leijen hiding ((<>), (<$>))

import Debug.Trace

tc :: [(SourcePos, TopLevel LocType LocPatn LocExpr)]
   -> [(LocType, String)]
   -> IO ((Maybe ([TopLevel RawType TypedPatn TypedExpr], [(RawType, String)]), TcLogState), TcState)
tc ds cts = flip runStateT (TcState M.empty knownTypes M.empty)
          . fmap (second $ over errLog adjustErrors)
          . flip runStateT (TcLogState [] [])
          . runMaybeT
          $ (,) <$> typecheck ds <*> typecheckCustTyGen cts
  where
    knownTypes = map (, ([], Nothing)) $ words "U8 U16 U32 U64 String Bool"
    adjustErrors = (if __cogent_freverse_tc_errors then reverse else id) . adjustContexts
    adjustContexts = map (first noConstraints)
    noConstraints = if __cogent_ftc_ctx_constraints then id else filter (not . isCtxConstraint)


typecheck :: [(SourcePos, TopLevel LocType LocPatn LocExpr)]
          -> TcM [TopLevel RawType TypedPatn TypedExpr]
typecheck = mapM (uncurry checkOne)

-- TODO: Check for prior definition
checkOne :: SourcePos -> TopLevel LocType LocPatn LocExpr
         -> TcM (TopLevel RawType TypedPatn TypedExpr)
checkOne loc d = lift (errCtx .= [InDefinition loc d]) >> case d of
  (Include _) -> __impossible "checkOne"
  (IncludeStd _) -> __impossible "checkOne"
  (DocBlock s) -> return $ DocBlock s
  (TypeDec n ps t) -> do
    traceTc "tc" $ bold (text $ replicate 80 '=')
    traceTc "tc" (text "typecheck type definition" <+> pretty n)
    let xs = ps \\ nub ps
    unless (null xs) $ logErrExit $ DuplicateTypeVariable xs
    t' <- validateType ps (stripLocT t)
    lift . lift $ knownTypes <>= [(n, (ps, Just t'))]
    t'' <- postT t'
    return $ TypeDec n ps t''

  (AbsTypeDec n ps ts) -> do
    traceTc "tc" $ bold (text $ replicate 80 '=')
    traceTc "tc" (text "typecheck abstract type definition" <+> pretty n)
    let xs = ps \\ nub ps
    unless (null xs) $ logErrExit $ DuplicateTypeVariable xs
    ts' <- mapM (\t -> validateType ps (stripLocT t)) ts
    ts'' <- mapM postT ts'
    lift . lift $ knownTypes <>= [(n, (ps, Nothing))]
    return $ AbsTypeDec n ps ts''

  (AbsDec n (PT ps t)) -> do
    traceTc "tc" $ bold (text $ replicate 80 '=')
    traceTc "tc" (text "typecheck abstract function" <+> pretty n)
    let vs' = map fst ps
        xs = vs' \\ nub vs'
    unless (null xs) $ logErrExit $ DuplicateTypeVariable xs
    t' <- validateType (map fst ps) (stripLocT t)
    lift . lift $ knownFuns %= M.insert n (PT ps t')
    t'' <- postT t'
    return $ AbsDec n (PT ps t'')

  (ConstDef n t e) -> do
    traceTc "tc" $ bold (text $ replicate 80 '=')
    traceTc "tc" (text "typecheck const definition" <+> pretty n)
    base <- lift . lift $ use knownConsts
    t' <- validateType [] (stripLocT t)
    let ctx = C.addScope (fmap (\(t,p) -> (t,p, Seq.singleton p)) base) C.empty  -- for consts, the definition is the first use.
    ((c, e'), flx, os) <- runCG ctx [] (cg e t')
    let c' = c <> Share t' (Constant n)
    (logs, subst, _) <- runSolver (solve c') [] flx os
    exitOnErr $ mapM_ logTc =<< mapM (\(c,l) -> lift (use errCtx >>= \c' -> return (c++c',l))) logs
    traceTc "tc" (text "subst for const definition" <+> pretty n <+> text "is"
                  L.<$> pretty subst)
    lift . lift $ knownConsts %= M.insert n (t', loc)
    e'' <- postE $ applyE subst e'
    t'' <- postT t'
    return (ConstDef n t'' e'')

  (FunDef f (PT vs t) alts) -> do
    traceTc "tc" $ bold (text $ replicate 80 '=')
    traceTc "tc" (text "typecheck fun definition" <+> pretty f)
    let vs' = map fst vs
        xs = vs' \\ nub vs'
    unless (null xs) $ logErrExit $ DuplicateTypeVariable xs
    base <- lift . lift $ use knownConsts
    t' <- validateType (map fst vs) (stripLocT t)
    (imps, i,o) <- asFunType t'
    let ctx = C.addScope (fmap (\(t,p) -> (t, p, Seq.singleton p)) base) C.empty
    let ?loc = loc
    ((c, alts'), flx, os) <- runCG ctx (map fst vs) (cgAlts alts o i)
    let c' = mconcat [ImplicitParam i | i <- imps] :-> c
    traceTc "tc" (text "constraint for fun definition" <+> pretty f <+> text "is"
                  L.<$> prettyC c')
    -- traceTc "tc" (pretty alts')
    (logs, subst, _) <- runSolver (solve c') vs flx os
    exitOnErr $ mapM_ logTc =<< mapM (\(c,l) -> lift (use errCtx) >>= \c' -> return (c++c',l)) logs
    traceTc "tc" (text "subst for fun definition" <+> pretty f <+> text "is"
                  L.<$> pretty subst)
    lift . lift $ knownFuns %= M.insert f (PT vs t')
    alts'' <- postA $ applyAlts subst alts'
    t''    <- postT t'
    return (FunDef f (PT vs t'') alts'')

  where
    asFunType (T (TFun is a b)) = return (is, a, b)  -- TODO
    asFunType x@(T (TCon c as _)) = lookup c <$> lift (lift $ use knownTypes) >>= \case
                                      Just (vs, Just t) -> asFunType (substType (zip vs as) t)
                                      _ -> logErrExit $ NotAFunctionType x
    asFunType x = logErrExit $ NotAFunctionType x


-- ----------------------------------------------------------------------------
-- custTyGen

typecheckCustTyGen :: [(LocType, String)] -> TcM [(RawType, String)]
typecheckCustTyGen = mapM . firstM $ \t -> do
  let t' = stripLocT t 
  lift $ errCtx .= [CustomisedCodeGen t]
  if not (isMonoType t')
    then logErrExit (CustTyGenIsPolymorphic $ toTCType t')
    else lift (lift $ isSynonym t') >>= \case
           True -> logErrExit (CustTyGenIsSynonym $ toTCType t')
           _    -> validateType [] t' >>= postT

