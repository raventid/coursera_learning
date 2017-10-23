module Exs where

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
