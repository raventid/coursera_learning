module WordNumber where

import Data.List (intersperse, intercalate)

digitToWord :: Int -> String
digitToWord n = case n of
  1 -> "one"
  2 -> "two"
  3 -> "three"
  4 -> "four"
  5 -> "five"
  6 -> "six"
  7 -> "seven"
  8 -> "eight"
  9 -> "nine"
  0 -> "zero"

digits :: Int -> [Int]
digits n
  | n >= 10 =  (digits(div n 10)) ++ [mod n 10]
  | otherwise = [n]

wordNumber :: Int -> String
wordNumber n = intercalate "-" . map f . digits $ n
  where f n = digitToWord n
