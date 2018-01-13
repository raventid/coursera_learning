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



-- Bad monad stuff

data CountMe a = CountMe Integer a deriving (Eq, Show)

instance Functor CountMe where
  fmap f (CountMe i a) = CountMe (i + 1) (f a)

instance Applicative CountMe where
  pure = CountMe 0
  CountMe n f <*> CountMe n' a = CountMe (n + n') (f a)

instance Monad CountMe where
  return = pure
  CountMe n a >>= f = let CountMe _ b = f a in CountMe (n+1) b

instance Arbitrary a => Arbitrary (CountMe a) where
  arbitrary = CountMe <$> arbitrary <*> arbitrary

instance Eq a => EqProp (CountMe a) where
  (=-=) = eq

badMonadSpec :: IO ()
badMonadSpec = do
  let trigger :: CountMe (Int, String, Int)
      trigger = undefined
  quickBatch $ functor trigger
  quickBatch $ applicative trigger
  quickBatch $ monad trigger

main :: IO ()
main = putStrLn "My favorite stub function for main, the way I like it"
