module Worksheet where

-- Data construction
data My = False | True

-- Here we are using deriving which allows us to take something from Show
data Mood = Blah | Woot deriving Show
--   [1]    [2]    [3]
-- 1 - Type constructor
-- 2 - Data constructor
-- 3 - Data constructor


changeMood :: Mood -> Mood
changeMood Blah = Woot
changeMood    _ = Blah

isPalindrom :: (Eq a) => [a] -> Bool
isPalindrom x = x == reverse x

myAbs :: Integer -> Integer
myAbs x = if x >= 0 then x else (-x)

f :: (a, b) -> (c, d) -> ((b, d), (a, c))
f (a,b)(c,d) = ((b,d), (a,c))

x = (+)

myF xs = w `x` 1
         where w = length xs

myId = \x -> x

matcher = \(x : xs) -> x

f1 (a, b) = a
