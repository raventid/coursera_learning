module SemigroupWorksheet where

import Data.Semigroup

-- instance Semigroup Integer where
--   (<>) x y = x + y

data Color = Red
           | Yellow
           | Blue
           | Green
           | Purple
           | Orange
           | Brown deriving (Show, Eq)

instance Semigroup Color where
  (<>) Red Blue = Purple
  (<>) Blue Red = Purple
  (<>) Yellow Blue = Green
  (<>) Blue Yellow = Green
  (<>) Yellow Red = Orange
  (<>) Red Yellow = Orange
  (<>) a b = if a == b
             then a
             else Brown
