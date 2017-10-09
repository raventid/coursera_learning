module Homework where

import Data.Char

filterUpper :: String -> String
filterUpper = filter isUpper -- pointfree function ;))

upperFirst :: String -> String
upperFirst (x:xs) = toUpper x : xs

upperAll :: String -> String
upperAll (x:xs) = toUpper x : upperAll xs
upperAll _ = []

-- just to get it clear
test' :: String -> String
test' (x:[]) = "tail is empty" -- One letter in string, if empty string we cannot pattern match  : []
test' (x:xs) = "x is " ++ " xs is " ++ xs -- At least two letters in string
test' _ = "default" -- empty string is left

upperFirstAndReturnIt :: String -> Char
upperFirstAndReturnIt = toUpper . head

-- direct recursion, not using (&&)
myAnd :: [Bool] -> Bool
myAnd [] = True
myAnd (x:xs) = if x == False then False else myAnd xs

-- direct recursion, using (&&)
myAnd' :: [Bool] -> Bool
myAnd' [] = True
myAnd' (x:xs) = x && myAnd xs

myOr :: [Bool] -> Bool
myOr (x:xs) = if x then True else myOr xs
myOr _  = False

myAny :: (a -> Bool) -> [a] -> Bool
myAny f (x:xs) = if f x then True else myAny f xs
myAny _ _ = False

myElem :: Eq a => a -> [a] -> Bool
myElem _ [] = False
myElem e (x:xs) = if e == x then True else myElem e xs

myElem' :: Eq a => a -> [a] -> Bool
myElem' = \x -> myAny (== x)

myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x:[]) = [x]
myReverse (x:xs) = (myReverse xs) ++ [x]

squish :: [[a]] -> [a]
squish [] = []
squish (x:xs) = x ++ squish xs

squishMap :: (a -> [b]) -> [a] -> [b]
squishMap _ [] = []
squishMap f (x:xs) = f x ++ squishMap f xs

squishAgain :: [[a]] -> [a]
squishAgain = squishMap id

myMaximumBy :: (a -> a -> Ordering) -> [a] -> a
myMaximumBy _ (x:[]) = x
myMaximumBy f (x:xs) =
  let max = myMaximumBy f xs
  in case f max x of
       GT -> max
       LT -> x
       EQ -> x

myMinimumBy :: (a -> a -> Ordering) -> [a] -> a
myMinimumBy _ (x:[]) = x
myMinimumBy f (x:xs) =
  let min = myMinimumBy f xs
  in case f min x of
      GT -> x
      LT -> min
      EQ -> min

myMaximum :: (Ord a) => [a] -> a
myMaximum = myMaximumBy compare

myMinimum :: (Ord a) => [a] -> a
myMinimum = myMinimumBy compare
