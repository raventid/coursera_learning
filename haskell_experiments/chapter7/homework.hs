module Homework where

tensDigit :: Integral a => a -> a
tensDigit x = d
  where xLast = x `div` 10
        d = xLast `mod` 10

tensDigit1 :: Integral a => a -> a
tensDigit1 x = f2 $ f1 $ x
  where f1 = fst . f
        f2 = snd . f
        f = (`divMod` 10)

foldBool :: a -> a -> Bool -> a
foldBool a b c = a

foldBool2 :: a -> a -> Bool -> a
foldBool2 x y c
  | c == True = x
  | c == False = y

foldBool3 :: a -> a -> Bool -> a
foldBool3 x y c = case(c) of
  (True) -> x
  (False) -> y
