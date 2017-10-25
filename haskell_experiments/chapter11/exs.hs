{-# LANGUAGE TemplateHaskell #-}
module Exs where

import Data.Int

data NumberOrBool =
    Numba Int8
  | BoolyBool Bool
  deriving (Eq, Show)

-- It's not an error but Haskell will give us warning about overflow.
someNumberOrBool = Numba (-129)

data Example = MakeExample deriving Show

data SpecialExample = MakeSpecialExample Int deriving Show

data FlowerType = Gardenia
  | Daisy
  | Rose
  | Lilac
  deriving Show

type Gardener = String

data Garden =
  Garden Gardener FlowerType
  deriving Show
