{-
This file is generated by Cogent

-}
{-# LANGUAGE DisambiguateRecordFields #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE TemplateHaskell #-}
module Bag_PBT where
import Test.QuickCheck
import Test.QuickCheck.Monadic
import Corres
import Bag_Shallow_Desugar_Tuples
import Lens.Micro
import Lens.Micro.TH (makeLenses)
import Control.Lens.Combinators (makePrisms)
import Prelude
       (not, div, mod, fromIntegral, undefined, return, (.), (+), (-),
        (*), (&&), (||), (>), (>=), (<), (<=), (==), (/=), Char, String,
        Int, Show, Maybe, Bool(..))
import Data.Bits ((.&.), (.|.), complement, xor, shiftL, shiftR)
import qualified Data.Tuple.Select as Tup
import qualified Data.Tuple.Update as Tup
import Data.Word (Word8, Word16, Word32, Word64)

makeLenses ''R4

makePrisms ''V0

prop_averageBag :: Property
prop_averageBag
  = forAll gen_averageBag
      (\ ic ->
         let oc = averageBag ic
             oa = hs_averageBag (abs_averageBag ic)
           in corres rel_averageBag oa oc)

prop_addToBag :: Property
prop_addToBag
  = forAll gen_addToBag
      (\ ic ->
         let oc = addToBag ic
             oa = hs_addToBag (abs_addToBag ic)
           in corres rel_addToBag oa oc)

abs_averageBag :: R4 Word32 Word32 -> (Int, Int)
abs_averageBag ic
  = let count' = ic ^. count
        sum' = ic ^. sum
      in (fromIntegral count', fromIntegral sum')

abs_addToBag :: (Word32, R4 Word32 Word32) -> (Int, Int, Int)
abs_addToBag ic
  = let _1' = ic ^. _1
        count'' = ic ^. _2 . count
        sum'' = ic ^. _2 . sum
      in (fromIntegral _1', fromIntegral count'', fromIntegral sum'')

rel_averageBag :: Maybe Int -> V0 () Word32 -> Bool
rel_averageBag oa oc
  = let _Just' = oa ^? _Just
        _V0_Success' = oc ^? _V0_Success
      in _Just' == (_V0_Success' <&> fromIntegral)

rel_addToBag :: (Int, Int) -> R4 Word32 Word32 -> Bool
rel_addToBag oa oc
  = let _1' = oa ^. _1
        _2' = oa ^. _2
        count' = oc ^. count
        sum' = oc ^. sum
      in _1' == (count' & fromIntegral) && _2' == (sum' & fromIntegral)

gen_averageBag :: Gen (R4 Word32 Word32)
gen_averageBag
  = do sum' <- arbitrary
       count' <- arbitrary `suchThat` \ x -> x <= sum'
       return (R4 count' sum')
hs_averageBag = undefined

gen_addToBag :: Gen ((Word32, R4 Word32 Word32))
gen_addToBag
  = do count'' <- arbitrary
       sum'' <- arbitrary
       _1' <- arbitrary `suchThat` \ x -> x >= 0
       return (_1', R4 count'' sum'')
hs_addToBag = undefined
