module Worksheet where

-- Type constructor for function is right associative
-- f :: a -> a -> a
-- associates to
-- f :: a -> (a -> a)

-- map :: (a -> b) -> [a] -> [b]
-- associates to
-- map :: (a -> b) -> ([a] -> [b])

-- We can express uncurried function using tuple like this
-- Num a => a -> a -> a to Num a => (a, a) -> a
--


-- Funny, how to make it nice to uncurry function with my custom currying

myCurry f a b = f (a, b)
myUncurry f (a, b) = f a b


-- Two possible implementation for parametriclly polymorphical function
f :: a -> a -> a
f a b = a
-- f a b = b

-- Only one possible implementation for this one
f1 :: a -> b -> b
f1 a b = b


myList = [1, 2, 3]
--magical function wich allow transform concrete Int from `length` into polymorphic Num
myIntegralValue = fromIntegral (length myList)
