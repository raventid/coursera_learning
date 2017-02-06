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

