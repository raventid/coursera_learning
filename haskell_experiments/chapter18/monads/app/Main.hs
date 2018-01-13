module Main where

import Test.QuickCheck hiding (Success, Failure)
import Test.QuickCheck.Checkers
import Test.QuickCheck.Classes

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

-- Profs to REPL:
-- quickBatch (monad [(1, 2, 3)])


main :: IO ()
main = putStrLn "My favorite stub function for main, the way I like it"
