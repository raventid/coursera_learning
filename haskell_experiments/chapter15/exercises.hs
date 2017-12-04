module Exercises where

import Data.Monoid

data Optional a =
    Nada
  | Only a
  deriving (Eq, Show)

instance Monoid a => Monoid(Optional a) where
  mempty = Nada

  -- mappend
  mappend (Only x) (Only y) = Only (mappend x y)
  mappend (Only x) _ = Only (mappend x mempty)
  mappend _ (Only y) = Only (mappend mempty y)
  mappend Nada Nada = mempty


specOptional :: Bool
specOptional = Only (Sum {getSum = 2}) == Only (Sum 1) `mappend` Only (Sum 1)

specOptional1 :: Bool
specOptional1 = Only (Product {getProduct = 8}) == Only (Product 4) `mappend` Only (Product 2)

specOptional2 :: Bool
specOptional2 = Only (Sum {getSum = 1}) == Only (Sum 1) `mappend` Nada

specOptional3 :: Bool
specOptional3 = Only [1] == Only [1] `mappend` Nada

specOptional4 :: Bool
specOptional4 =  Only (Sum {getSum = 1}) == Nada `mappend` Only (Sum 1)

specSuiteOptional :: Bool
specSuiteOptional = specOptional && specOptional1 && specOptional2 && specOptional3 && specOptional4
