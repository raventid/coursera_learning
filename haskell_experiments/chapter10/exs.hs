module Homework where

stops = "pbtdkg"
vowels = "aeiou"

ex1 = [(x,y,x1) | x <- stops, y <- vowels, x1 <- stops]
ex2 = [(x,y,x1) | x <- stops, y <- vowels, x1 <- stops, x == 'p']
-- the same with list of words and other stuff

-- Easy. Divide sum of length of words in phrase by amount.
-- seekritFunc x =
--   div(sum(map length (words x))
--       length(words x))
-- How to rewrite this using fractional division??? Forget what fractional division is :(

-- direct recursion, not using (&&)
myAnd :: [Bool] -> Bool
myAnd [] = True
myAnd (x:xs) =
        if x == False
        then False
        else myAnd xs

-- direct recursion, using (&&)
myAnd' :: [Bool] -> Bool
myAnd' [] = True
myAnd' (x:xs) = x && myAnd xs

-- fold, not point-free in the folding function
myAnd'' :: [Bool] -> Bool
myAnd'' = foldr
         (\a b ->
           if a == False
           then False
           else b) True

-- fold, both myAnd and the folding function are point-free now
myAnd''' :: [Bool] -> Bool
myAnd''' = foldr (&&) True

myOr :: [Bool] -> Bool
myOr = foldr (||) False

myAny :: (a -> Bool) -> [a] -> Bool
myAny f = foldr ((||) . f) False

myElem :: Eq a => a -> [a] -> Bool
myElem e = foldr ((||) . (\xs -> (==) e xs)) False

myElem' :: Eq a => a -> [a] -> Bool
myElem' e = myAny (\xs -> e == xs)

myReverse :: [a] -> [a]
myReverse = foldl (\acc x -> x : acc) []

-- This is I guess is not the best way to write code. I mean effective ;)
myReverse' :: [a] -> [a]
myReverse' = foldr (\x acc -> acc ++ [x]) []

myMap :: (a -> b) -> [a] -> [b]
myMap f = foldr (\x acc -> f x : acc) []

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter f = foldr (\x acc -> if f x then x : acc else acc) []

squish :: [[a]] -> [a]
squish = foldr (\x acc -> x ++ acc) []

squishMap :: (a -> [b]) -> [a] -> [b]
squishMap f = foldr (\x acc -> f x ++ acc) []

squishAgain :: [[a]] -> [a]
squishAgain = squishMap (\x -> x)

-- This is really bad one case doesn't work properly

myMaximumBy :: (a -> a -> Ordering) -> [a] -> a
myMaximumBy f xs = foldr (\a b -> if f a b == GT then a else b) (head xs) xs

-- Prelude> myMaximumBy (\_ _ -> GT) [1..10]
-- 1
-- Prelude> myMaximumBy (\_ _ -> LT) [1..10]
-- 10
-- Prelude> myMaximumBy compare [1..10]
-- 10

myMinimumBy :: (a -> a -> Ordering) -> [a] -> a
myMinimumBy f xs = foldr (\a b -> if f a b == LT then a else b) (head xs) xs

-- Prelude> myMinimumBy (\_ _ -> GT) [1..10]
-- 10
-- Prelude> myMinimumBy (\_ _ -> LT) [1..10]
-- 1
-- Prelude> myMinimumBy compare [1..10]
-- 1
