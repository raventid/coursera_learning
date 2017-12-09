module Main where

import Data.Monoid
import Test.QuickCheck

monoidAssoc :: (Eq m, Monoid m) => m -> m -> m -> Bool
monoidAssoc a b c = (a <> (b <> c)) == ((a <> b) <> c)

-- We can run this in REPL and verify that monoid works! Awesome!
-- quickCheck (monoidAssoc :: String -> String -> String -> Bool)

monoidLeftIdentity :: (Eq m, Monoid m) => m -> Bool
monoidLeftIdentity a = (mempty <> a) == a

monoidRightIdentity :: (Eq m, Monoid m) => m -> Bool
monoidRightIdentity a = (a <> mempty) == a


main :: IO ()
main = putStrLn "My project was build successfully!"
