module Folds where

-- foldr (^) 2 [1..3]
-- (1 ^ (2 ^ (3 ^ 2)))
-- (1 ^ (2 ^ 9))
-- 1 ^ 512
-- 1
foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' f z [] = z
foldr' f z (x:xs) = f x (foldr f z xs) -- x for a, and (foldr f z xs) for b returns b

-- foldl (^) 2 [1..3]
-- ((2 ^ 1) ^ 2) ^ 3
-- (2 ^ 2) ^ 3
-- 4 ^ 3
-- 64
foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' f acc [] = acc
foldl' f acc (x:xs) = foldl' f (f acc x) xs

foldr'' :: (a -> b -> b) -> b -> [a] -> b
foldr'' f z xs =
  case xs of
    [] -> z
    (x:xs) -> f x (foldr f z xs)

myAny :: (a -> Bool) -> [a] -> Bool
myAny f xs =
 foldr (\x b -> f x || b) False xs

-- Wow, how to print both lines on screen? :)
foldDiscovery =
  let xs = map show [1..5]
  in
     foldr (\x y -> concat ["(",x,"+",y,")"]) "0" xs
     -- foldl (\x y -> concat ["(",x,"+",y,")"]) "0" xs

-- it's tailrecursive, but we could do it staight - first is traverse, after apply
-- f = flip (*)
-- foldl f (f 1 1) [2..3]
-- foldl f 1 [2..3]
-- foldl f (f 1 2) [3]
-- foldl f 2 [3]
-- foldl f (f 2 3) []
-- foldl f 6 []
-- 6
-- foldl (flip (*)) 1 [1..3]

-- foldr (const) 'a' [1..2]
-- (const 1 (const 'a' 2)) Here we have have one problem with folding, folding function should return one
-- type everytime
-- foldr const 'a' [1..2]

-- foldr' :: (a -> b -> b) -> b -> [a] -> b
-- foldr' f z [] = z
-- foldr' f z (x:xs) = f x (foldr f z xs)
--
-- foldr' :: (a -> b -> b) -> b -> [a] -> b
-- const  ::  a -> b -> a -- you see, here we have type mismatch and that's all
--

-- foldl (const) 'a' [1..2]
-- const (const 'a' 1) 2
-- const 'a' 2
-- foldl const 'a' [1..2]

-- Prelude> foldl (\_ _ -> 5) 0 ([1..5] ++ undefined)
--   *** Exception: Prelude.undefined
--       error because bottom is part of the spine
--       and foldl must evaluate the spine
--
--
-- Prelude> foldl (\_ _ -> 5) 0 ([1..5] ++ [undefined])
--   5
--   this is OK because here bottom is a value

-- Let's look at right fold, it has to evaluate first element:
-- Prelude> foldr const 0 ([1..5] ++ undefined)
-- => 1
-- This is why we have bottom here:
-- Prelude> foldr (flip const) 0 ([1..5] ++ undefined)
-- => *** Exception: Prelude.undefined
-- With left fold we see other problem, we have to evaluate everything, so we hit the bottom two times.
-- Prelude> foldl const 0 ([1..5] ++ undefined)
-- => *** Exception: Prelude.undefined
-- Prelude> foldl (flip const) 0 ([1..5] ++ undefined)
-- => *** Exception: Prelude.undefinedi

fibs = 1 : scanl (+) 1 fibs

fibsLess :: Int -> [Int]
fibsLess x = go x 0 []
    where go n ix xs
              | n > fibs !! ix = fibs !! ix : go x (ix + 1) xs
              | n <= fibs !! ix = xs

factorial = scanl (*) 1 [2..]
