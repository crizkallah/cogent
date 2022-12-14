--
-- Copyright 2017, NICTA
--
-- This software may be distributed and modified according to the terms of
-- the GNU General Public License version 2. Note that NO WARRANTY is provided.
-- See "LICENSE_GPLv2.txt" for details.
--
-- @TAG(NICTA_GPL)
--

{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DataKinds #-}
{- LANGUAGE DeriveDataTypeable -}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{- LANGUAGE InstanceSigs -}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE LambdaCase #-}
#if __GLASGOW_HASKELL__ < 709
{-# LANGUAGE OverlappingInstances #-}
#endif
{-# LANGUAGE PatternGuards #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE Rank2Types #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE ViewPatterns #-}
{-# OPTIONS_GHC -fno-warn-orphans -fno-warn-missing-signatures #-}

module Cogent.Sugarfree where

import Cogent.Common.Syntax
import Cogent.Common.Types
import Cogent.Compiler
import Cogent.Util
import Cogent.Vec hiding (splitAt, length, zipWith, zip, unzip)
import qualified Cogent.Vec as Vec

import Control.Applicative hiding (empty)
import Control.Arrow hiding ((<+>))
import Control.Monad.Except hiding (fmap, forM_)
import Control.Monad.Reader hiding (fmap, forM_)
import Control.Monad.State hiding (fmap, forM_)
-- import Data.Data hiding (Refl)
import Data.Foldable (forM_)
#if __GLASGOW_HASKELL__ < 709
import Data.Traversable(traverse)
#endif
import Data.Map (Map)
import qualified Data.Map as M
import Data.Monoid
-- import Data.Monoid.Cancellative
import Text.PrettyPrint.ANSI.Leijen hiding (indent, tupled, (<>), (<$>))
import qualified Text.PrettyPrint.ANSI.Leijen as L
import qualified Unsafe.Coerce as Unsafe (unsafeCoerce)  -- NOTE: used safely to coerce phantom types only

-- import Debug.Trace

guardShow :: String -> Bool -> TC t v ()
guardShow x b = if b then return () else TC (throwError $ "GUARD: " ++ x)

data Type t
  = TVar (Fin t)
  | TVarBang (Fin t)
  | TCon TypeName [Type t] Sigil
  | TFun (Type t) (Type t)
  | TPrim PrimInt
  | TString
  | TSum [(TagName, (Type t, Bool))]  -- True means taken (since 2.0.4)
  | TProduct (Type t) (Type t)
  | TRecord [(FieldName, (Type t, Bool))] Sigil  -- True means taken
  | TUnit
  deriving (Show, Eq, Ord)

data SupposedlyMonoType = forall (t :: Nat). SMT (Type t)

isTFun :: Type t -> Bool
isTFun (TFun {}) = True
isTFun _ = False

isUnboxed :: Type t -> Bool
isUnboxed (TCon _ _ Unboxed) = True
isUnboxed (TRecord _ Unboxed) = True
isUnboxed _ = False

isSubtype :: Type t -> Type t -> Bool
isSubtype (TPrim p1) (TPrim p2) = isSubtypePrim p1 p2
isSubtype (TSum  s1) (TSum  s2) | not __cogent_fnew_subtyping
  = (if __cogent_fshare_variants then length s1 == 1 else True) && and (map (flip elem s2) s1)
  -- NOTE: this impl'n means no forms of depth subtyping is allowed. i.e., prim has to be promoted before width subtyping is met / zilinc
                                | otherwise
  = and $ zipWith (\(c1,(t1,b1)) (c2,(t2,b2)) -> (c1,t1) == (c2,t2) && b1 >= b2) s1 s2
isSubtype (TRecord r1 s1) (TRecord r2 s2) | __cogent_fnew_subtyping =
  s1 == s2 && and (zipWith (\(f1,(t1,b1)) (f2,(t2,b2)) -> (f1,t1) == (f2,t2) && b1 >= b2) r1 r2)
isSubtype a b = a == b

data FunNote = NoInline | InlineMe | MacroCall | InlinePlease  -- order is important, larger value has stronger precedence
             deriving (Bounded, Eq, Ord, Show)

data Expr t v a e
  = Variable (Fin v, a)
  | Fun FunName [Type t] FunNote
  | Op Op [e t v a]
  | App (e t v a) (e t v a)
  | Con TagName (e t v a)
  | Unit
  | ILit Integer PrimInt
  | SLit String
  | Let a (e t v a) (e t ('Suc v) a)
  | LetBang [(Fin v, a)] a (e t v a) (e t ('Suc v) a)
  | Tuple (e t v a) (e t v a)
  | Struct [(FieldName, e t v a)]  -- unboxed record
  | If (e t v a) (e t v a) (e t v a)   -- technically no longer needed as () + () == Bool
  | Case (e t v a) TagName (Likelihood, a, e t ('Suc v) a) (Likelihood, a, e t ('Suc v) a)
  | Esac (e t v a)
  | Split (a, a) (e t v a) (e t ('Suc ('Suc v)) a)
  | Member (e t v a) FieldIndex
  | Take (a, a) (e t v a) FieldIndex (e t ('Suc ('Suc v)) a)
  | Put (e t v a) FieldIndex (e t v a)
  | Promote (Type t) (e t v a)
deriving instance (Show a, Show (e t v a), Show (e t ('Suc ('Suc v)) a), Show (e t ('Suc v) a)) => Show (Expr t v a e)
  -- constraint no smaller than header, thus UndecidableInstances

data UntypedExpr t v a = E (Expr t v a UntypedExpr) deriving (Show)
data TypedExpr t v a = TE { exprType :: Type t , exprExpr :: Expr t v a TypedExpr } deriving (Show)

data FunctionType = forall t. FT (Vec t Kind) (Type t) (Type t)
deriving instance Show FunctionType

data Attr = Attr { inlineDef :: Bool, fnMacro :: Bool } deriving (Eq, Ord, Show)

instance Semigroup Attr where
  (Attr a1 a2) <> (Attr a1' a2') = Attr (a1 || a1') (a2 || a2')

instance Monoid Attr where
  mempty = Attr False False

data Definition e a
  = forall t. (Pretty a, Pretty (e t ('Suc 'Zero) a)) => FunDef  Attr FunName (Vec t (TyVarName, Kind)) (Type t) (Type t) (e t ('Suc 'Zero) a)
  | forall t. (Pretty a, Pretty (e t ('Suc 'Zero) a)) => AbsDecl Attr FunName (Vec t (TyVarName, Kind)) (Type t) (Type t)
  | forall t. (Pretty a, Pretty (e t ('Suc 'Zero) a)) => TypeDef TypeName (Vec t TyVarName) (Maybe (Type t))
deriving instance Show a => Show (Definition TypedExpr a)
deriving instance Show a => Show (Definition UntypedExpr a)

type SFConst e = (VarName, e 'Zero 'Zero VarName)

getDefinitionId :: Definition e a -> String
getDefinitionId (FunDef  _ fn _ _ _ _) = fn
getDefinitionId (AbsDecl _ fn _ _ _  ) = fn
getDefinitionId (TypeDef tn _ _    ) = tn

getFuncId :: Definition e a -> Maybe FunName
getFuncId (FunDef  _ fn _ _ _ _) = Just fn
getFuncId (AbsDecl _ fn _ _ _  ) = Just fn
getFuncId _ = Nothing

getTypeVarNum :: Definition e a -> Int
getTypeVarNum (FunDef  _ _ tvs _ _ _) = Vec.toInt $ Vec.length tvs
getTypeVarNum (AbsDecl _ _ tvs _ _  ) = Vec.toInt $ Vec.length tvs
getTypeVarNum (TypeDef _ tvs _    ) = Vec.toInt $ Vec.length tvs

isDefinitionId :: String -> Definition e a -> Bool
isDefinitionId n d = n == getDefinitionId d

isFuncId :: String -> Definition e a -> Bool
isFuncId n (FunDef  _ fn _ _ _ _) = n == fn
isFuncId n (AbsDecl _ fn _ _ _  ) = n == fn
isFuncId _ _ = False

isAbsFun :: Definition e a -> Bool
isAbsFun (AbsDecl {}) = True
isAbsFun _ = False

isConFun :: Definition e a -> Bool
isConFun (FunDef {}) = True
isConFun _ = False

isTypeDef :: Definition e a -> Bool
isTypeDef (TypeDef {}) = True
isTypeDef _ = False

isAbsTyp :: Definition e a -> Bool
isAbsTyp (TypeDef _ _ Nothing) = True
isAbsTyp _ = False

traverseE :: (Applicative f) => (forall t v. e1 t v a -> f (e2 t v a)) -> Expr t v a e1 -> f (Expr t v a e2)
traverseE f (Variable v)         = pure $ Variable v
traverseE f (Fun fn tys nt)      = pure $ Fun fn tys nt
traverseE f (Op opr es)          = Op opr <$> traverse f es
traverseE f (App e1 e2)          = App <$> f e1 <*> f e2
traverseE f (Con cn e)           = Con cn <$> f e
traverseE f (Unit)               = pure $ Unit
traverseE f (ILit i pt)          = pure $ ILit i pt
traverseE f (SLit s)             = pure $ SLit s
traverseE f (Let a e1 e2)        = Let a  <$> f e1 <*> f e2
traverseE f (LetBang vs a e1 e2) = LetBang vs a <$> f e1 <*> f e2
traverseE f (Tuple e1 e2)        = Tuple <$> f e1 <*> f e2
traverseE f (Struct fs)          = Struct <$> traverse (traverse f) fs
traverseE f (If e1 e2 e3)        = If <$> f e1 <*> f e2 <*> f e3
traverseE f (Case e tn (l1,a1,e1) (l2,a2,e2)) = Case <$> f e <*> pure tn <*> ((l1, a1,) <$> f e1)  <*> ((l2, a2,) <$> f e2)
traverseE f (Esac e)             = Esac <$> (f e)
traverseE f (Split a e1 e2)      = Split a <$> (f e1) <*> (f e2)
traverseE f (Member rec fld)     = Member <$> (f rec) <*> pure fld
traverseE f (Take a rec fld e)   = Take a <$> (f rec) <*> pure fld <*> (f e)
traverseE f (Put rec fld v)      = Put <$> (f rec) <*> pure fld <*> (f v)
traverseE f (Promote ty e)       = Promote ty <$> (f e)

-- pre-order fold over Expr wrapper
foldEPre :: (Monoid b) => (forall t v. e1 t v a -> Expr t v a e1) -> (forall t v. e1 t v a -> b) -> e1 t v a -> b
foldEPre unwrap f e = case unwrap e of
  Variable{}          -> f e
  Fun{}               -> f e
  (Op _ es)           -> mconcat $ f e : map (foldEPre unwrap f) es
  (App e1 e2)         -> mconcat [f e, foldEPre unwrap f e1, foldEPre unwrap f e2]
  (Con _ e1)          -> f e `mappend` foldEPre unwrap f e1
  Unit                -> f e
  ILit{}              -> f e
  SLit{}              -> f e
  (Let _ e1 e2)       -> mconcat [f e, foldEPre unwrap f e1, foldEPre unwrap f e2]
  (LetBang _ _ e1 e2) -> mconcat [f e, foldEPre unwrap f e1, foldEPre unwrap f e2]
  (Tuple e1 e2)       -> mconcat [f e, foldEPre unwrap f e1, foldEPre unwrap f e2]
  (Struct fs)         -> mconcat $ f e : map (foldEPre unwrap f . snd) fs
  (If e1 e2 e3)       -> mconcat [f e, foldEPre unwrap f e1, foldEPre unwrap f e2, foldEPre unwrap f e3]
  (Case e1 _ (_,_,e2) (_,_,e3)) -> mconcat $ [f e, foldEPre unwrap f e1, foldEPre unwrap f e2, foldEPre unwrap f e3]
  (Esac e1)           -> f e `mappend` foldEPre unwrap f e1
  (Split _ e1 e2)     -> mconcat [f e, foldEPre unwrap f e1, foldEPre unwrap f e2]
  (Member e1 _)       -> f e `mappend` foldEPre unwrap f e1
  (Take _ e1 _ e2)    -> mconcat [f e, foldEPre unwrap f e1, foldEPre unwrap f e2]
  (Put e1 _ e2)       -> mconcat [f e, foldEPre unwrap f e1, foldEPre unwrap f e2]
  (Promote _ e1)      -> f e `mappend` foldEPre unwrap f e1

fmapE :: (forall t v. e1 t v a -> e2 t v a) -> Expr t v a e1 -> Expr t v a e2
fmapE f (Variable v)         = Variable v
fmapE f (Fun fn tys nt)      = Fun fn tys nt
fmapE f (Op opr es)          = Op opr (map f es)
fmapE f (App e1 e2)          = App (f e1) (f e2)
fmapE f (Con cn e)           = Con cn (f e)
fmapE f (Unit)               = Unit
fmapE f (ILit i pt)          = ILit i pt
fmapE f (SLit s)             = SLit s
fmapE f (Let a e1 e2)        = Let a (f e1) (f e2)
fmapE f (LetBang vs a e1 e2) = LetBang vs a (f e1) (f e2)
fmapE f (Tuple e1 e2)        = Tuple (f e1) (f e2)
fmapE f (Struct fs)          = Struct (map (second f) fs)
fmapE f (If e1 e2 e3)        = If (f e1) (f e2) (f e3)
fmapE f (Case e tn (l1,a1,e1) (l2,a2,e2)) = Case (f e) tn (l1, a1, f e1) (l2, a2, f e2)
fmapE f (Esac e)             = Esac (f e)
fmapE f (Split a e1 e2)      = Split a (f e1) (f e2)
fmapE f (Member rec fld)     = Member (f rec) fld
fmapE f (Take a rec fld e)   = Take a (f rec) fld (f e)
fmapE f (Put rec fld v)      = Put (f rec) fld (f v)
fmapE f (Promote ty e)       = Promote ty (f e)

untypeE :: TypedExpr t v a -> UntypedExpr t v a
untypeE (TE _ e) = E $ fmapE untypeE e

untypeD :: Definition TypedExpr a -> Definition UntypedExpr a
untypeD (FunDef  attr fn ts ti to e) = FunDef  attr fn ts ti to (untypeE e)
untypeD (AbsDecl attr fn ts ti to  ) = AbsDecl attr fn ts ti to
untypeD (TypeDef tn ts mt) = TypeDef tn ts mt

instance (Functor (e t v), Functor (e t ('Suc v)), Functor (e t ('Suc ('Suc v)))) => Functor (Flip (Expr t v) e) where
  fmap f (Flip (Variable v)         ) = Flip $ Variable (second f v)
  fmap f (Flip (Fun fn tys nt)      ) = Flip $ Fun fn tys nt
  fmap f (Flip (Op opr es)          ) = Flip $ Op opr (map (fmap f) es)
  fmap f (Flip (App e1 e2)          ) = Flip $ App (fmap f e1) (fmap f e2)
  fmap f (Flip (Con cn e)           ) = Flip $ Con cn (fmap f e)
  fmap f (Flip (Unit)               ) = Flip $ Unit
  fmap f (Flip (ILit i pt)          ) = Flip $ ILit i pt
  fmap f (Flip (SLit s)             ) = Flip $ SLit s
  fmap f (Flip (Let a e1 e2)        ) = Flip $ Let (f a) (fmap f e1) (fmap f e2)
  fmap f (Flip (LetBang vs a e1 e2) ) = Flip $ LetBang (map (second f) vs) (f a) (fmap f e1) (fmap f e2)
  fmap f (Flip (Tuple e1 e2)        ) = Flip $ Tuple (fmap f e1) (fmap f e2)
  fmap f (Flip (Struct fs)          ) = Flip $ Struct (map (second $ fmap f) fs)
  fmap f (Flip (If e1 e2 e3)        ) = Flip $ If (fmap f e1) (fmap f e2) (fmap f e3)
  fmap f (Flip (Case e tn (l1,a1,e1) (l2,a2,e2))) = Flip $ Case (fmap f e) tn (l1, f a1, fmap f e1) (l2, f a2, fmap f e2)
  fmap f (Flip (Esac e)             ) = Flip $ Esac (fmap f e)
  fmap f (Flip (Split a e1 e2)      ) = Flip $ Split ((f *** f) a) (fmap f e1) (fmap f e2)
  fmap f (Flip (Member rec fld)     ) = Flip $ Member (fmap f rec) fld
  fmap f (Flip (Take a rec fld e)   ) = Flip $ Take ((f *** f) a) (fmap f rec) fld (fmap f e)
  fmap f (Flip (Put rec fld v)      ) = Flip $ Put (fmap f rec) fld (fmap f v)
  fmap f (Flip (Promote ty e)       ) = Flip $ Promote ty (fmap f e)

instance Functor (TypedExpr t v) where
  fmap f (TE t e) = TE t $ ffmap f e

-- instance Functor (Definition TypedExpr) where
--   fmap f (FunDef  attr fn ts ti to e) = FunDef  attr fn ts ti to (fmap f e)
--   fmap f (AbsDecl attr fn ts ti to)   = AbsDecl attr fn ts ti to
--   fmap f (TypeDef tn ts mt)      = TypeDef tn ts mt
--
-- stripNameTD :: Definition TypedExpr VarName -> Definition TypedExpr ()
-- stripNameTD = fmap $ const ()

-- ----------------------------------------------------------------------------
-- Type reconstruction

bang :: Type t -> Type t
bang (TVar v)         = TVarBang v
bang (TVarBang v)     = TVarBang v
bang (TUnit)          = TUnit
bang (TProduct t1 t2) = TProduct (bang t1) (bang t2)
bang (TSum ts)        = TSum (map (second $ first bang) ts)
bang (TFun ti to)     = TFun ti to
bang (TRecord ts s)   = TRecord (map (second $ first bang) ts) (bangSigil s)
bang (TPrim i)        = TPrim i
bang (TString)        = TString
bang (TCon n ts s)    = TCon n (map bang ts) (bangSigil s)

substitute :: Vec t (Type u) -> Type t -> Type u
substitute vs (TVar v)         = vs `at` v
substitute vs (TVarBang v)     = bang (vs `at` v)
substitute _  (TUnit)          = TUnit
substitute vs (TProduct t1 t2) = TProduct (substitute vs t1) (substitute vs t2)
substitute vs (TSum ts)        = TSum (map (second (first $ substitute vs)) ts)
substitute vs (TFun ti to)     = TFun (substitute vs ti) (substitute vs to)
substitute vs (TRecord ts t)   = TRecord (map (second (first $ substitute vs)) ts) t
substitute vs (TCon n ps s)    = TCon n (map (substitute vs) ps) s
substitute _  (TPrim i)        = TPrim i
substitute _  (TString)        = TString

remove :: (Eq a) => a -> [(a,b)] -> [(a,b)]
remove k = filter ((/= k) . fst)

adjust :: (Eq a) => a -> (b -> b) -> [(a,b)] -> [(a,b)]
adjust k f = map (\(a,b) -> (a,) $ if a == k then f b else b)

newtype TC (t :: Nat) (v :: Nat) a = TC {unTC :: ExceptT String
                                                         (ReaderT (Vec t Kind, Map FunName FunctionType)
                                                                  (State (Vec v (Maybe (Type t)))))
                                                         a}
                                   deriving (Functor, Applicative, Alternative, Monad, MonadPlus)

infixl 4 <||>
(<||>) :: TC t v (a -> b) -> TC t v a -> TC t v b
(TC a) <||> (TC b) = TC $ do x <- get
                             f <- a
                             x1 <- get
                             put x
                             arg <- b
                             x2 <- get
                             unTC $ guardShow "<||>" $ x1 == x2
                             return (f arg)

opType :: Op -> [Type t] -> Maybe (Type t)
opType opr [TPrim p1, TPrim p2]
  | opr `elem` [Plus, Minus, Times, Divide, Mod,
                BitAnd, BitOr, BitXor, LShift, RShift],
    p1 == p2, p1 /= Boolean = Just $ TPrim p1
opType opr [TPrim p1, TPrim p2]
  | opr `elem` [Gt, Lt, Le, Ge, Eq, NEq],
    p1 == p2, p1 /= Boolean = Just $ TPrim Boolean
opType opr [TPrim Boolean, TPrim Boolean]
  | opr `elem` [And, Or, Eq, NEq] = Just $ TPrim Boolean
opType Not [TPrim Boolean] = Just $ TPrim Boolean
opType Complement [TPrim p] | p /= Boolean = Just $ TPrim p
opType opr ts = __impossible "opType"

useVariable :: Fin v -> TC t v (Maybe (Type t))
useVariable v = TC $ do ret <- (`at` v) <$> get
                        case ret of
                          Nothing -> return ret
                          Just t  -> do
                            ok <- canShare <$> (unTC (kindcheck t))
                            when (not ok) $ modify (\s -> update s v Nothing)
                            return ret

funType :: FunName -> TC t v (Maybe FunctionType)
funType v = TC $ (M.lookup v . snd) <$> ask

runTC :: TC t v a -> (Vec t Kind, Map FunName FunctionType) -> Vec v (Maybe (Type t))
      -> Either String (Vec v (Maybe (Type t)), a)
runTC (TC a) readers st = case runState (runReaderT (runExceptT a) readers) st of
                            (Left x, s)  -> Left x
                            (Right x, s) -> Right (s,x)

-- XXX | tc_debug :: [Definition UntypedExpr a] -> IO ()
-- XXX | tc_debug = flip tc_debug' M.empty
-- XXX |   where
-- XXX |     tc_debug' :: [Definition UntypedExpr a] -> Map FunName FunctionType -> IO ()
-- XXX |     tc_debug' [] _ = putStrLn "tc2... OK!"
-- XXX |     tc_debug' ((FunDef _ fn ts t rt e):ds) reader =
-- XXX |       case runTC (typecheck e) (fmap snd ts, reader) (Cons (Just t) Nil) of
-- XXX |         Left x -> putStrLn $ "tc2... failed! Due to: " ++ x
-- XXX |         Right _ -> tc_debug' ds (M.insert fn (FT (fmap snd ts) t rt) reader)
-- XXX |     tc_debug' ((AbsDecl _ fn ts t rt):ds) reader = tc_debug' ds (M.insert fn (FT (fmap snd ts) t rt) reader)
-- XXX |     tc_debug' (_:ds) reader = tc_debug' ds reader

retype :: [Definition TypedExpr a] -> Either String [Definition TypedExpr a]
retype ds = fmap fst $ tc $ map untypeD ds

tc :: [Definition UntypedExpr a] -> Either String ([Definition TypedExpr a], Map FunName FunctionType)
tc = flip tc' M.empty
  where
    tc' :: [Definition UntypedExpr a] -> Map FunName FunctionType -> Either String ([Definition TypedExpr a], Map FunName FunctionType)
    tc' [] reader = return ([], reader)
    tc' ((FunDef attr fn ts t rt e):ds) reader =
      case runTC (typecheck e) (fmap snd ts, reader) (Cons (Just t) Nil) of
        Left x -> Left x
        Right (_, e') -> (first (FunDef attr fn ts t rt e':)) <$> tc' ds (M.insert fn (FT (fmap snd ts) t rt) reader)
    tc' (d@(AbsDecl _ fn ts t rt):ds) reader = (first (Unsafe.unsafeCoerce d:)) <$> tc' ds (M.insert fn (FT (fmap snd ts) t rt) reader)
    tc' (d:ds) reader = (first (Unsafe.unsafeCoerce d:)) <$> tc' ds reader

tc_ :: [Definition UntypedExpr a] -> Either String [Definition TypedExpr a]
tc_ = fmap fst . tc

tcConsts :: [SFConst UntypedExpr] -> Map FunName FunctionType -> Either String ([SFConst TypedExpr], Map FunName FunctionType)
tcConsts [] reader = return ([], reader)
tcConsts ((v,e):ds) reader =
  case runTC (typecheck e) (Nil, reader) Nil of
    Left x -> Left x
    Right (_,e') -> (first ((v,e'):)) <$> tcConsts ds reader

withBinding :: Type t -> TC t ('Suc v) x -> TC t v x
withBinding t a
  = TC $ do readers <- ask
            st      <- get
            case runTC a readers (Cons (Just t) st) of
              Left e -> throwError e
              Right (Cons Nothing s,r)   -> do put s; return r
              Right (Cons (Just t) s, r) -> do
                ok <- canDiscard <$> unTC (kindcheck t)
                if ok then do put s; return r
                      else do throwError "Didn't use linear variable"

withBindings :: Vec k (Type t) -> TC t (v :+: k) x -> TC t v x
withBindings Nil tc = tc
withBindings (Cons x xs) tc = withBindings xs (withBinding x tc)

withBang :: [Fin v] -> TC t v x -> TC t v x
withBang vs (TC x) = TC $ do st <- get
                             mapM_ (\v -> modify (modifyAt v (fmap bang))) vs
                             ret <- x
                             mapM_ (\v -> modify (modifyAt v (const $ st `at` v))) vs
                             return ret

lookupKind :: Fin t -> TC t v Kind
lookupKind f = TC ((`at` f) . fst <$> ask)

kindcheck :: Type t -> TC t v Kind
kindcheck (TVar v)         = lookupKind v
kindcheck (TVarBang v)     = bangKind <$> lookupKind v
kindcheck (TUnit)          = return mempty
kindcheck (TProduct t1 t2) = mappend <$> kindcheck t1 <*> kindcheck t2
kindcheck (TSum ts)        = mconcat <$> mapM (kindcheck . fst . snd) (filter (not . snd .snd) ts)
kindcheck (TFun ti to)     = return mempty
kindcheck (TRecord ts s)   = mappend (sigilKind s) <$> (mconcat <$> (mapM (kindcheck . fst . snd) (filter (not . snd .snd) ts)))
kindcheck (TPrim i)        = return mempty
kindcheck (TString)        = return mempty
kindcheck (TCon n vs s)    = mapM_ kindcheck vs >> return (sigilKind s)

typecheck :: UntypedExpr t v a -> TC t v (TypedExpr t v a)
typecheck (E (Op o es))
   = do es' <- mapM typecheck es
        let Just t = opType o (map exprType es')
        return (TE t (Op o es'))
typecheck (E (ILit i t)) = return (TE (TPrim t) (ILit i t))
typecheck (E (SLit s)) = return (TE TString (SLit s))
typecheck (E (Variable v))
   = do varuse <- useVariable (fst v)
        t <- case varuse of
                  Just t -> return t
                  Nothing -> fail "variable use didn't exist"
        return (TE t (Variable v))
typecheck (E (Fun f ts note))
   | ExI (Flip ts') <- Vec.fromList ts
   = do fnTy <- funType f
        case fnTy of
          Just (FT ks ti to) ->
            (case Vec.length ts' =? Vec.length ks
               of Just Refl -> let ti' = substitute ts' ti
                                   to' = substitute ts' to
                                in do forM_ (Vec.zip ts' ks) $ \(t, k) -> do
                                        k' <- kindcheck t
                                        when ((k <> k') /= k) $ fail "kind not matched in type instantiation"
                                      return $ TE (TFun ti' to') (Fun f ts note)
                  Nothing -> fail "lengths don't match")
          _ -> fail "failed to get function type"
typecheck (E (App e1 e2))
   = do e1' <- typecheck e1
        (ti, to) <- case e1' of
                      (TE (TFun ti to) _) -> return (ti, to)
                      _ -> fail "app operator not a function"
        e2' <- typecheck e2
        let (TE ti' _) = e2'
        guardShow "app" $ ti' == ti
        return $ TE to (App e1' e2')
typecheck (E (Let a e1 e2))
   = do e1' <- typecheck e1
        e2' <- withBinding (exprType e1') (typecheck e2)
        return $ TE (exprType e2') (Let a e1' e2')
typecheck (E (LetBang vs a e1 e2))
   = do e1' <- withBang (map fst vs) (typecheck e1)
        k <- kindcheck (exprType e1')
        guardShow "let!" $ canEscape k
        e2' <- withBinding (exprType e1') (typecheck e2)
        return $ TE (exprType e2') (LetBang vs a e1' e2')
typecheck (E Unit) = return $ TE TUnit Unit
typecheck (E (Tuple e1 e2))
   = do e1' <- typecheck e1
        e2' <- typecheck e2
        return $ TE (TProduct (exprType e1') (exprType e2')) (Tuple e1' e2')
typecheck (E (Con tag e))
   = do e' <- typecheck e
        return $ TE (TSum [(tag, (exprType e', False))]) (Con tag e')
typecheck (E (If ec et ee))
   = do ec' <- typecheck ec
        guardShow "if-1" $ exprType ec' == TPrim Boolean
        (et', ee') <- (,) <$> typecheck et <||> typecheck ee  -- have to use applicative functor, as they share the same initial env
        guardShow "if-2" $ exprType et' == exprType ee'  -- promoted
        return $ TE (exprType et') (If ec' et' ee')
typecheck (E (Case e tag (lt,at,et) (le,ae,ee)))
   = do e' <- typecheck e
        let TSum ts = exprType e'
            Just (t, False) = lookup tag ts  -- must not have been taken
            restt = if __cogent_fnew_subtyping
                      then TSum $ adjust tag (second $ const True) ts
                      else TSum $ remove tag ts
        (et',ee') <- (,) <$>  withBinding t     (typecheck et)
                         <||> withBinding restt (typecheck ee)
        guardShow "case" $ exprType et' == exprType ee'  -- promoted
        return $ TE (exprType et') (Case e' tag (lt,at,et') (le,ae,ee'))
typecheck (E (Esac e))
   = do e' <- typecheck e
        t <- case e' of
                TE (TSum [(_,(t,False))]) _ -> return t
                _ -> fail "esac did not get a variant with a single case"    
        return $ TE t (Esac e')
typecheck (E (Split a e1 e2))
   = do e1' <- typecheck e1
        let (TProduct t1 t2) = exprType e1'
        e2' <- withBindings (Cons t1 (Cons t2 Nil)) (typecheck e2)
        return $ TE (exprType e2') (Split a e1' e2')
typecheck (E (Member e f))
   = do e' <- typecheck e  -- canShare
        (t, ts, s) <- case e' of
                        (TE t@(TRecord ts s) _) -> return (t, ts, s)
                        _ -> fail "member got bad TRecord"
        guardShow "member-1" . canShare =<< kindcheck t
        guardShow "member-2" $ f < length ts
        let (_,(tau,c)) = ts !! f
        guardShow "member-3" $ not c  -- not taken
        return $ TE tau (Member e' f)
typecheck (E (Struct fs))
   = do let (ns,es) = unzip fs
        es' <- mapM typecheck es
        return $ TE (TRecord (zipWith (\n e' -> (n, (exprType e', False))) ns es') Unboxed) $ Struct $ zip ns es'
typecheck (E (Take a e f e2))
   = do e' <- typecheck e
        let (TE (TRecord ts s) _) = e'
        guardShow "take-1" $ s /= ReadOnly
        guardShow "take-2" $ f < length ts
        let (init, (fn,(tau,False)):rest) = splitAt f ts
        k <- kindcheck tau
        e2' <- withBindings (Cons tau (Cons (TRecord (init ++ (fn,(tau,True )):rest) s) Nil)) (typecheck e2)  -- take that field regardless of its shareability
        return $ TE (exprType e2') (Take a e' f e2')
typecheck (E (Put e1 f e2))
   = do e1' <- typecheck e1
        (ts, s) <- case e1' of
                    TE (TRecord ts s) _ -> return (ts, s)
                    _ -> fail "put didn't get a TRecord"
        guardShow "put-1" $ f < length ts
        let (init, (fn,(tau,taken)):rest) = splitAt f ts
        k <- kindcheck tau
        when (not taken) $ guardShow "put-2" $ canDiscard k  -- if it's not taken, then it has to be discardable; if taken, then just put
        e2' <- typecheck e2
        guardShow "put-3" $ exprType e2' == tau
        return $ TE (TRecord (init ++ (fn,(tau,False)):rest) s) (Put e1' f e2')  -- put it regardless
typecheck (E (Promote ty e))
   = do (TE t e') <- typecheck e
        guardShow "promote" $ t `isSubtype` ty
        return $ TE ty (Promote ty $ TE t e')


-- /////////////////////////////////////////////////////////////////////////////
-- Core-lang pretty-printing

indentation, ifIndentation :: Int
indentation = 3
ifIndentation = 3
position = string
varName = string
primop = blue . (pretty :: Op -> Doc)
keyword = bold . string
typevar = blue . string
typename = blue . bold . string
literal = dullcyan
typesymbol = cyan . string
kind = bold . typesymbol
funName = dullyellow . string
fieldName = magenta . string
fieldIndex = magenta . string . ('.':) . show
tagName = dullmagenta . string
symbol = string
kindsig = red . string
commaList = encloseSep empty empty (comma L.<> space)
dotList = encloseSep empty empty (symbol ".")
tupled = encloseSep lparen rparen (comma L.<> space)
tupled1 [x] = x
tupled1 x = encloseSep lparen rparen (comma L.<> space) x
typeargs x = encloseSep lbracket rbracket (comma L.<> space) x
err = red . string
comment = black . string
context = black . string
letbangvar = dullgreen . string
record = encloseSep (lbrace L.<> space) (space L.<> rbrace) (comma L.<> space)
variant = encloseSep (langle L.<> space) rangle (symbol "|" L.<> space) . map (L.<> space)
indent = nest indentation

level :: Associativity -> Int
level (LeftAssoc i) = i
level (RightAssoc i) = i
level (NoAssoc i) = i
level (Prefix) = 0

levelE :: Expr t v a e -> Int
levelE (Op opr [_,_]) = level (associativity opr)
levelE (ILit {}) = 0
levelE (Variable {}) = 0
levelE (Fun {}) = 0
levelE (App {}) = 1
levelE (Tuple {}) = 0
levelE (Con {}) = 0
levelE (Esac {}) = 0
levelE (Member {}) = 0
levelE (Take {}) = 0
levelE (Put {}) = 1
levelE (Promote {}) = 0
levelE _ = 100

class Pretty a => PrettyP a where
  prettyP :: Int -> a -> Doc

instance (Pretty (Expr t v a e)) => PrettyP (Expr t v a e) where
  prettyP l x | levelE x < l   = pretty x
              | otherwise = parens (pretty x)

instance (Pretty a, Pretty (TypedExpr t v a)) => PrettyP (TypedExpr t v a) where
  prettyP i (TE _ x) = prettyP i x
instance (Pretty a, Pretty (UntypedExpr t v a)) => PrettyP (UntypedExpr t v a) where
  prettyP i (E x) = prettyP i x

instance Pretty Likelihood where
  pretty Likely = symbol "=>"
  pretty Unlikely = symbol "~>"
  pretty Regular = symbol "->"

-- prettyL :: Likelihood -> Doc
-- prettyL Likely = symbol "+%"
-- prettyL Regular = empty
-- prettyL Unlikely = symbol "-%"

prettyV = dullblue  . string . ("_v" ++) . show . finInt
prettyT = dullgreen . string . ("_t" ++) . show . finInt

instance Pretty a => Pretty (TypedExpr t v a) where
  pretty (TE _ e) = pretty e
instance Pretty a => Pretty (UntypedExpr t v a) where
  pretty (E e) = pretty e

instance (Pretty a, PrettyP (e t v a), Pretty (e t ('Suc v) a), Pretty (e t ('Suc ('Suc v)) a))
         => Pretty (Expr t v a e) where
  pretty (Op opr [a,b])
     | LeftAssoc  l <- associativity opr = prettyP (l+1) a <+> primop opr <+> prettyP l b
     | RightAssoc l <- associativity opr = prettyP l a <+> primop opr <+> prettyP (l+1)  b
     | NoAssoc    l <- associativity opr = prettyP l a <+> primop opr <+> prettyP l  b
  pretty (Op opr [e]) = primop opr <+> prettyP 1 e
  pretty (Op opr es)  = primop opr <+> tupled (map pretty es)
  pretty (ILit i pt) = literal (string $ show i) <+> symbol "::" <+> pretty pt
  pretty (SLit s) = literal $ string s
  pretty (Variable x) = pretty (snd x) L.<> angles (prettyV $ fst x)
  pretty (Fun fn ins nt) = pretty nt L.<> funName fn <+> pretty ins
  pretty (App a b) = prettyP 2 a <+> prettyP 1 b
  pretty (Let a e1 e2) = align (keyword "let" <+> pretty a <+> symbol "=" <+> pretty e1 L.<$>
                                keyword "in" <+> pretty e2)
  pretty (LetBang bs a e1 e2) = align (keyword "let!" <+> tupled (map (prettyV . fst) bs) <+> pretty a <+> symbol "=" <+> pretty e1 L.<$>
                                       keyword "in" <+> pretty e2)
  pretty (Unit) = tupled []
  pretty (Tuple e1 e2) = tupled (map pretty [e1, e2])
  pretty (Struct fs) = symbol "#" L.<> record (map (\(n,e) -> fieldName n <+> symbol "=" <+> pretty e) fs)
  pretty (Con tn e) = tagName tn <+> prettyP 1 e
  pretty (If c t e) = group . align $ (keyword "if" <+> pretty c
                                       L.<$> indent (keyword "then" </> align (pretty t))
                                       L.<$> indent (keyword "else" </> align (pretty e)))
  pretty (Case e tn (l1,_,a1) (l2,_,a2)) = align (keyword "case" <+> pretty e <+> keyword "of"
                                                  L.<$> indent (tagName tn <+> pretty l1 <+> align (pretty a1))
                                                  L.<$> indent (symbol "*" <+> pretty l2 <+> align (pretty a2)))
  pretty (Esac e) = keyword "esac" <+> parens (pretty e)
  pretty (Split _ e1 e2) = align (keyword "split" <+> pretty e1 L.<$>
                                  keyword "in" <+> pretty e2)
  pretty (Member x f) = prettyP 1 x L.<> symbol "." L.<> fieldIndex f
  pretty (Take (a,b) rec f e) = align (keyword "take" <+> tupled [pretty a, pretty b] <+> symbol "="
                                                      <+> prettyP 1 rec <+> record (fieldIndex f:[]) L.<$>
                                       keyword "in" <+> pretty e)
  pretty (Put rec f v) = prettyP 1 rec <+> record [fieldIndex f <+> symbol "=" <+> pretty v]
  pretty (Promote t e) = prettyP 1 e <+> symbol "::" <+> pretty t

instance Pretty FunNote where
  pretty NoInline = empty
  pretty InlineMe = comment "{-# INLINE #-}" <+> empty
  pretty MacroCall = comment "{-# FNMACRO #-}" <+> empty
  pretty InlinePlease = comment "inline" <+> empty

instance Pretty (Type t) where
  pretty (TVar v) = prettyT v
  pretty (TVarBang v) = prettyT v L.<> typesymbol "!"
  pretty (TPrim pt) = pretty pt
  pretty (TString) = typename "String"
  pretty (TUnit) = typename "()"
  pretty (TProduct t1 t2) = tupled (map pretty [t1, t2])
  pretty (TSum alts) = variant (map (\(n,(t,_)) -> tagName n <+> pretty t) alts)  -- FIXME: cogent.1
  pretty (TFun t1 t2) = prettyT' t1 <+> typesymbol "->" <+> pretty t2
     where prettyT' e@(TFun {}) = parens (pretty e)
           prettyT' e           = pretty e
  pretty (TRecord fs s) = record (map (\(f,(t,b)) -> fieldName f <+> symbol ":" L.<> prettyTaken b <+> pretty t) fs) L.<> pretty s
  pretty (TCon tn [] s) = typename tn L.<> pretty s
  pretty (TCon tn ts s) = typename tn L.<> pretty s <+> typeargs (map pretty ts)

prettyTaken :: Bool -> Doc
prettyTaken True  = symbol "*"
prettyTaken False = empty

instance Pretty Sigil where
  pretty Writable = empty
  pretty ReadOnly = typesymbol "!"
  pretty Unboxed  = typesymbol "#"

#if __GLASGOW_HASKELL__ < 709
instance Pretty (TyVarName, Kind) where
#else
instance {-# OVERLAPPING #-} Pretty (TyVarName, Kind) where
#endif
  pretty (v,k) = pretty v L.<> typesymbol ":<" L.<> prettyKind k

prettyKind (K False False False) = string "()"
prettyKind (K e s d) = if e then kind "E" else empty L.<>
                       if s then kind "S" else empty L.<>
                       if d then kind "D" else empty

instance Pretty a => Pretty (Vec t a) where
  pretty Nil = empty
  pretty (Cons x Nil) = pretty x
  pretty (Cons x xs) = pretty x L.<> string "," <+> pretty xs

instance Pretty (Definition e a) where
  pretty (FunDef _ fn ts t rt e) = funName fn <+> symbol ":" <+> brackets (pretty ts) L.<> symbol "." <+>
                                   parens (pretty t) <+> symbol "->" <+> parens (pretty rt) <+> symbol "=" L.<$>
                                   pretty e
  pretty (AbsDecl _ fn ts t rt) = funName fn <+> symbol ":" <+> brackets (pretty ts) L.<> symbol "." <+>
                                  parens (pretty t) <+> symbol "->" <+> parens (pretty rt)
  pretty (TypeDef tn ts Nothing) = keyword "type" <+> typename tn <+> pretty ts
  pretty (TypeDef tn ts (Just t)) = keyword "type" <+> typename tn <+> pretty ts <+>
                                    symbol "=" <+> pretty t

