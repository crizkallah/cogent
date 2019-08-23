
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

{-# LANGUAGE ScopedTypeVariables #-}

module Cogent.Dargent.Desugar
 ( desugarAbstractTypeSigil
 , desugarSigil
 -- Remaining exports for testing only
 , desugarDataLayout
 , constructDataLayout
 ) where

import Data.Map (Map)
import Data.Map as M
import Data.Traversable (mapAccumL)

import Text.Parsec.Pos (SourcePos, newPos)

import Cogent.Compiler              ( __fixme
                                    , __impossible
                                    )
import Cogent.Common.Syntax         ( DataLayoutName
                                    , Size
                                    , TagName
                                    , FieldName
                                    )
import Cogent.Common.Types          ( Sigil(Unboxed, Boxed), PrimInt(..))
import Cogent.Dargent.Surface       ( DataLayoutExpr
                                    , DataLayoutSize
                                    , DataLayoutSize(Bytes, Bits, Add)
                                    , DataLayoutExpr(..)
                                    )
import Cogent.Dargent.TypeCheck     ( desugarSize )
import Cogent.Dargent.Core
import Cogent.Core                  ( Type (..) )
{- * Desugaring 'Sigil's -}

-- | After WH-normalisation, @TCon _ _ _@ values only represent primitive and abstract types.
--   Primitive types have no sigil, and abstract types may be boxed or unboxed but have no layout.
--   'desugarAbstractTypeSigil' should only be used when desugaring the sigils of abstract types, to eliminate the @Maybe DataLayoutExpr@.
desugarAbstractTypeSigil
  :: Sigil (Maybe DataLayoutExpr)
  -> Sigil ()
desugarAbstractTypeSigil = fmap desugarMaybeLayout
  where
    desugarMaybeLayout Nothing = ()
    desugarMaybeLayout _       = __impossible $ "desugarAbstractTypeSigil (Called on TCon after normalisation, only for case when it is an abstract type)"


-- | If a 'DataLayoutExpr' was provided, desugars the 'DataLayoutExpr' to a @DataLayout BitRange@
--   Otherwise, constructs a @DataLayout BitRange@ which matches the type.
--   TODO: Layout polymorphism and layout inference will require changing the second behavior /mdimeglio
--
--   Should not be used to desugar sigils associated with @TCon _ _ _@ types, ie. abstract types.
desugarSigil
  :: (Type t)
      -- ^ This type should be obtained by
      --
      --   1. Start with the raw type that the 'Sigil' is attached to
      --   2. Replace the top level sigil with @Unboxed@
      --   3. Desugar the resulting type
      --
      --   Explanation of why:
      --   The generation algorithm will lay out the internals of unboxed records,
      --   but give boxed records a 'PrimLayout' of pointer size. However, we want to layout
      --   the internals of the top level record.

  -> Sigil (Maybe DataLayoutExpr)
      -- ^ Since desugarSigil is only called for normalising boxed records (and later, boxed variants),
      --   the @Maybe DataLayoutExpr@ should always be in the @Just layout@ alternative.
  
  -> Sigil (DataLayout BitRange)

desugarSigil t = fmap desugarMaybeLayout
  where
    desugarMaybeLayout Nothing  = CLayout -- default to a CLayout
    desugarMaybeLayout (Just l) = desugarDataLayout l


{- * Desugaring 'DataLayout's -}

desugarDataLayout :: DataLayoutExpr -> DataLayout BitRange
desugarDataLayout l = Layout $ desugarDataLayout' l
  where
    desugarDataLayout' :: DataLayoutExpr -> DataLayout' BitRange
    desugarDataLayout' (RepRef _) = __impossible "desugarDataLayout (Called after normalisation)"
    desugarDataLayout' (Prim size)
      | bitSize <- desugarSize size
      , bitSize > 0
        = PrimLayout (BitRange bitSize 0)
      | otherwise = UnitLayout
    
    desugarDataLayout' (Offset dataLayoutExpr offsetSize) =
      offset (desugarSize offsetSize) (desugarDataLayout' dataLayoutExpr)
    
    desugarDataLayout' (Record fields) =
      RecordLayout $ M.fromList fields'
      where fields' = fmap (\(fname, pos, layout) -> (fname, (desugarDataLayout' layout, pos))) fields
    
    desugarDataLayout' (Variant tagExpr alts) =
      SumLayout tagBitRange $ M.fromList alts'
      where
        tagBitRange = case desugarDataLayout' tagExpr of
          PrimLayout range -> range
          _                -> __impossible $ "desugarDataLayout (Called after typecheck, tag layouts known to be single range)"
    
        alts' = fmap (\(aname, pos, size, layout) -> (aname, (size, desugarDataLayout' layout, pos))) alts

{- * CONSTRUCTING 'DataLayout's -}

constructDataLayout' :: Type t -> DataLayout' BitRange
constructDataLayout' (TUnit        ) = UnitLayout
constructDataLayout' (TPrim primInt) = PrimLayout $ primBitRange primInt
constructDataLayout' (TSum alternatives)
  | length alternatives > 2 ^ wordSizeBits = __impossible $ "constructDataLayout' (Type check should prevent more alternatives than can fit in a word for sum types embedded in a boxed type with default layout)"
  | otherwise                              = SumLayout tagLayout alternativesLayout
      where
        tagLayout          = BitRange { bitSizeBR = wordSizeBits, bitOffsetBR = 0}
        alternativesLayout = fromList . snd $ mapAccumL constructAlternativeLayout (wordSizeBits, 0) alternatives

        constructAlternativeLayout
          :: (Size, Integer) -- ^ Offset and tag value for this alternative.
          -> (TagName, (Type t, Bool))
          -> ((Size, Integer) -- Offset and tag value for next alternative.
            ,(TagName, (Integer, DataLayout' BitRange, SourcePos)))

        constructAlternativeLayout (minBitOffset, tagValue) (name, (coreType, _)) =
          let layout :: DataLayout' BitRange
              layout = alignOffsettable wordSizeBits minBitOffset $ constructDataLayout' coreType
          in  ((endAllocatedBits' layout, tagValue + 1), (name, (tagValue, layout, dummyPos)))


constructDataLayout' (TRecord fields Unboxed) = RecordLayout . fromList . snd $ mapAccumL constructFieldLayout 0 fields
  where
    constructFieldLayout :: Size -> (FieldName, (Type t, Bool)) -> (Size, (FieldName, (DataLayout' BitRange, SourcePos)))
    constructFieldLayout minBitOffset (name, (coreType, _)) =
      let layout = alignOffsettable wordSizeBits minBitOffset $ constructDataLayout' coreType
      in (endAllocatedBits' layout, (name, (layout, dummyPos)))

    -- Equations for boxed embedded types
    constructDataLayout' (TRecord fields (Boxed _ _)) = PrimLayout $ pointerBitRange
    constructDataLayout' (TCon    _ _    (Boxed _ _)) = PrimLayout $ pointerBitRange

    -- Equations for as yet unsupported embedded types
    constructDataLayout' (TCon n _ Unboxed) = __impossible $ "constructDataLayout' (Type check should fail on boxed types containing embedded unboxed abstract types)\n Failed on TCon type: " ++ n
    constructDataLayout' (TVar         _  ) = __impossible $ "constructDataLayout' (Type check should fail on boxed types containing type variables)"
    constructDataLayout' (TVarBang     _  ) = __impossible $ "constructDataLayout' (Type check should fail on boxed types containing type variables)"
    constructDataLayout' (TFun         _ _) = __impossible $ "constructDataLayout' (Type check should fail on boxed types containing functions)"
    constructDataLayout' (TString         ) = __impossible $ "constructDataLayout' (Type check should fail on boxed types containing strings)"
#if BUILTIN_ARRAYS
    constructDataLayout' (TArray     _ _ _) = __impossible $ "constructDataLayout' (Type check should fail on boxed types containing arrays)"
#endif
    constructDataLayout' (TProduct     _ _) = __impossible $ "constructDataLayout' (Type check should fail on boxed types containing pairs)"
      -- TODO(dargent): implement matching data layouts with types so that the above mentioned type check fails actually occur /mdimeglio
      -- TODO(dargent): implement layout polymorphism to handle boxed types containing type variables /mdimeglio
      -- TODO(dargent): implement layouts for TProduct and TArray types /mdimeglio
      -- TODO(dargent): maybe implement layouts for function types like other boxed (pointer) layouts /mdimeglio
    constructDataLayout' t = __impossible $ "constructDataLayout': type not handled " ++ show t

-- constructs a default layout
constructDataLayout :: Type t -> DataLayout BitRange
constructDataLayout = Layout . constructDataLayout'

dummyPos = __fixme $ newPos "Dummy Pos" 0 0 -- FIXME: Not sure what SourcePos to give for layouts generated automatically.




