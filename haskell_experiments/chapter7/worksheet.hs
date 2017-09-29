module Worksheet where

bindExp :: Integer -> String
bindExp x = let y = 5 in
              "the integer was: " ++ show x
              ++ " and y was: " ++ show y

-- bindExp1 :: Integer -> String
-- bindExp1 x = let y = 5 in
--              let z = y + x in -- ++ "the integer was: "
--              ++ show x ++ " and y was: "
--              ++ show y ++ " and z was: " ++ show z


-- addOneIfOdd n = case odd n of
--   True -> f n
--   False -> n
--   where f n = n + 1

addOneIfOdd = \n -> case odd n of
  True -> f n
  False -> n
  where f n = n + 1

-- addFive x y = (if x > y then y else x) + 5

addFive = \x -> \y -> (if x > y then y else x) + 5 -- Haskell tells that this is Integer -> Integer -> Integer, why not Num a => a -> a -> a
-- ^^^ Perhaps we need LANG noMonomorphism extension enabled?

-- mflip f = \x -> \y -> f y x

mflip = \f -> \x -> \y -> f y x

-- functionC x y = if (x > y) then x else y

functionC x y = case pred of
  True -> x
  False -> y
  where pred = x > y

-- ifEvenAdd2 n = if even n then (n+2) else n

ifEvenAdd2 n =
  case pred of
    True -> n + 2
    False -> n
  where pred = even n

nums x =
  case compare x 0 of
    LT -> -1
    GT -> 1
    _  -> 0

-- guard closes
myAbs :: Integer -> Integer
myAbs x
 | x < 0     = (-x)
 | otherwise = x


dogYrs :: Integer -> Integer
dogYrs x
  | x <= 0    = 0
  | x <= 1    = x * 15
  | x <= 2    = x * 12
  | x <= 4    = x * 8
  | otherwise = x * 6


-- (.) negate sum [1,2,3,4] -> f [1,2,3,4] ??? why is this so?????
-- negate . sum [1,2,3,4] -> negate . 15
-- negate . sum $ [1,2,3,4] -> f [1,2,3,4]

-- Pointfree functions
-- Normal function
folda :: Int -> [Int] -> Int
folda z xs = foldr (+) z xs

-- Pointfree function
folda' :: Int -> [Int] -> Int
folda' = foldr (+)

tensDigit :: Integral a => a -> a
tensDigit x = d
          where xLast = x `div` 10
                d     = xLast `mod` 10

tensDigit' :: Integral a => a -> a
tensDigit' x = fst (x `divMod` 10)


foldBool :: a -> a -> Bool -> a
foldBool x y b
  | b == True  = x
  | b == False = y

foldBool' :: a -> a -> Bool -> a
foldBool' x y b =
  case b of
    True  -> x
    False -> y

-- g :: (a -> b) -> (a, c) -> (b, c)
-- g f t
--   | fst t == True  = (f $ fst t, snd t)
--   | fst t == False = (f $ snd t, snd t)

g' :: (a -> b) -> (a, c) -> (b, c)
g' f t = (f $ fst t, snd t)
