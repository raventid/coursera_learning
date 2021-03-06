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



-- Bad monad stuff (fixed after my tweaks)
data CountMe a = CountMe Integer a deriving (Eq, Show)

instance Functor CountMe where
  fmap f (CountMe i a) = CountMe i (f a) -- it was ... CountMe (i + 1) ...

instance Applicative CountMe where
  pure = CountMe 0
  CountMe n f <*> CountMe n' a = CountMe (n + n') (f a)

instance Monad CountMe where
  return = pure
  CountMe n a >>= f =
    let CountMe n' b = f a -- was -> CountMe _ b ...
    in  CountMe (n + n') b -- was -> CountMe (n + 1) ...

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


data Nope a =
  NopeDotJpg

-- instance Monoid Nope where


data PhhhbbtttEither b a =
  Left a
  | Right b

newtype Identity a = Identity a deriving (Eq, Ord, Show)

instance Functor Identity where
  fmap = undefined

instance Applicative Identity where
  pure = undefined
  (<*>) = undefined

instance Monad Identity where
  return = pure
  (>>=) = undefined

data List a =
  Nil
  | Cons a (List a)

main :: IO ()
main = putStrLn "My favorite stub function for main, the way I like it"
