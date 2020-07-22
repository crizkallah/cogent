{-# LANGUAGE DuplicateRecordFields #-}

-- -----------------------------------------------------------------------
-- Cogent PBT: Simple DSL
-- -----------------------------------------------------------------------
module Cogent.Haskell.GenDSL where

data PBTInfo = PBTInfo { fname :: String
                       , finfo :: FunInfo
                       , fabsf :: FunAbsF
                       , frrel :: FunRRel
                       , fwelf :: FunWelF
                       } deriving (Show)

data PBTInfo' = PBTInfo' { fname :: String
                       , finfo :: FunInfo
                       , fabsf :: FunAbsF'
                       , frrel :: FunRRel'
                       , fwelf :: FunWelF'
                       } deriving (Show)

data FunInfo = FunInfo { ispure :: Bool
                       , nondet :: Bool
                       } deriving (Show)

data FunAbsF = FunAbsF { absf :: [String]
                       , ic   :: [String]
                       , ia   :: [String]
                       , s :: Int
                       } deriving (Show)

data FunAbsF' = FunAbsF' { absf :: (String, [String])
                         , ityps   :: [(String, [String])]
                       --, ia   :: [String]
                       -- , s :: Int
                       } deriving (Show)

data FunRRel = FunRRel { rrel :: [String]
                       , oc   :: String
                       , oa   :: String
                       } deriving (Show)

data FunRRel' = FunRRel' { rrel :: (String, [String])
                       , otyps   :: [(String, [String])]
                       } deriving (Show)

data FunWelF = FunWelF { welf :: [String]
                       , typs :: [String]
                       } deriving (Show)

data FunWelF' = FunWelF' { welf :: (String, [String])
                       , typs :: [(String, [String])]
                       } deriving (Show)

-- data PBTInfoList = PBTInfoList [PBTInfo]
-- Prototyping ...
data ICType = Pointer
            | CList 
            | Tree
            -- | Bag
            | Int
            | Word32 
            | String
            deriving (Show)

data IAType a = InputA (Int, Int)
              | IOther a
              deriving Show

data OAType a = OutputA (Int, Int)
              | OOther a
              deriving Show


data FuncInfo = FuncInfo { name :: String
                         , ispure :: Bool
                         , nondet :: Bool
                         , ictype :: ICType
                         } deriving (Show)
