module Worksheet where

-- List datatype in Haskell defined like this
-- [] is a sum type, but a : [a] is a product type.
-- data [] a = [] | a : [a]
-- This (:) also called product

myTail :: [a] -> [a]
myTail [] = []
myTail (_ : xs) = xs

safeTail :: [a] -> Maybe [a]
safeTail [] = Nothing
safeTail (x:[]) = Nothing
safeTail (_:xs) = Just xs

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:[]) = Just x
safeHead (x:xs) = Just x

enumFromTo' :: Enum a => a -> a -> [a]
enumFromTo' begin end = go begin end
  where go b e
         | f b > f e = []
         | f b == f e = [b]
         | otherwise = b : go (succ b) e
         where f = fromEnum

eftBool :: Bool -> Bool -> [Bool]
eftBool a b = [a,b]

eftOrd :: Ordering -> Ordering -> [Ordering]
eftOrd = enumFromTo'

eftInt :: Int -> Int -> [Int]
eftInt = enumFromTo'

eftChar :: Char -> Char -> [Char]
eftChar = enumFromTo'

split :: [Char] -> [[Char]]
split "" = []
split s = (takeWhile (/=' ') s) : (split $ drop 1 $ dropWhile (/=' ') s)

comprehendedList = [ x^2 | x <- [1..10] ]

myLines :: String -> [String]
myLines "" = []
myLines s = (takeWhile f s) : (myLines $ drop 1 $ dropWhile f s)
  where f = (/=' ')

myFilter :: String -> [String]
myFilter s = [filtered | filtered <- myLines s, not $ filtered `elem` toRemove]
  where toRemove = ["the","a","an"]

myFilter' :: String -> [String]
myFilter' = filter (\w -> not $ elem w ["the","a","an"]) . myLines

zip' :: [a] -> [b] -> [(a,b)]
zip' (x:[])(y:_) = (x,y) : []
zip' (x:_)(y:[]) = (x,y) : []
zip' (x:xs)(y:ys) = (x,y) : zip' xs ys

zip'' :: [a] -> [b] -> [(a,b)]
zip'' (x:xs)(y:ys) = (x,y) : zip'' xs ys
zip'' _ _ = []

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' f (x:xs)(y:ys) = f x y : zipWith' f xs ys
zipWith' _ _ _ = []

zip''' :: [a] -> [b] -> [(a,b)]
zip''' = zipWith' f
  where f x y = (x,y)

-- From previous chapter I got this as WHNF is not applied form, but not applied because of laziness, no?

-- WHNF(weak head normal form)
-- (1,1+1)
--
-- Normal form(we cannot reduce expression any further)
-- \x->x*10
--
-- Not WHNF and not Normal. arguments are calculated, but function is not applied yet.
-- "Papu" ++ "chon"
--
-- WHNF because function is not applied and thus second argument of tuple is not ready
-- (1, "Papu" ++ "chon")
