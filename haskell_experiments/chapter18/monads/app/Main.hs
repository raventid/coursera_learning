module Main where

-- Monad laws:

-- 1.
-- right identity
-- m >>= return = m

-- 2.
-- left identity
-- return x >>= f = fx

-- 3.
-- Associativity
-- (m >>= f) >>= g = m >>= (\x -> f x >>= g)

main :: IO ()
main = putStrLn "My favorite stub function for main, the way I like it"
