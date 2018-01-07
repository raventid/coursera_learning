module Main where

import Data.Monoid
import Test.QuickCheck hiding (Success, Failure)
import Test.QuickCheck.Checkers
import Test.QuickCheck.Classes

-- I'm a bit tired of writing quickChecks by hand, let's see what checkers can do for me.
data Bull =
    Fools
  | Twoo
  deriving (Eq, Show)

instance Arbitrary Bull where
  arbitrary =
    frequency [ (1, return Fools)
              , (1, return Twoo) ]

instance Monoid Bull where
  mempty = Fools
  mappend _ _ = Fools

instance EqProp Bull where (=-=) = eq


-- Exercise: ZipList Applicative Exercise
data List a =
    Nil
  | Cons a (List a)
  deriving (Eq, Show)

-- take' 2 (Cons 2 (Cons 3 (Cons 2 (Cons 4 Nil))))
take' :: Int -> List a -> List a
take' _ Nil = Nil
take' 0 _ = Nil
take' count (Cons x xs) = Cons x (take' (count - 1) xs)

instance Monoid (List a) where
  mempty = Nil
  mappend = append

-- Function for internal use in mappend
append :: List a -> List a -> List a
append Nil ys = ys
append (Cons x xs) ys = Cons x $ xs `append` ys

instance Functor List where
  fmap _ Nil = Nil
  fmap f (Cons x xs) = Cons (f x) (fmap f xs)

instance Applicative List where
  pure a = Cons a Nil

  (<*>) _ Nil = Nil
  (<*>) Nil _ = Nil
  (<*>) (Cons f fs) xs = (f <$> xs) <> (fs <*> xs) -- Like a pro :)

newtype ZipList' a = ZipList' (List a) deriving (Eq, Show)

instance Eq a => EqProp (ZipList' a) where
  xs =-= ys = xs' `eq` ys'
    where xs' = let (ZipList' l) = xs
                in take' 3000 l
          ys' = let (ZipList' l) = ys
                in take' 3000 l

instance Functor ZipList' where
  fmap f (ZipList' xs) = ZipList' $ fmap f xs

-- Oneliner to check Applicative.
-- (ZipList' (Cons (+9) (Cons (*2) (Cons (+8) Nil)))) <*> (ZipList' (Cons 1 (Cons 2 (Cons 3 Nil))))

-- Helper function for applicative
zipWith' :: (List (b->c)) -> (List b) -> (List c)
zipWith' Nil _                   = Nil
zipWith' _ Nil                   = Nil
zipWith' (Cons f fs) (Cons y ys) = Cons (f y) (zipWith' fs ys)

instance Applicative ZipList' where
  pure a = ZipList' (Cons a Nil)

  (<*>) (ZipList' Nil) _ = ZipList' Nil
  (<*>) _ (ZipList' Nil) = ZipList' Nil
  (<*>) (ZipList' fs) (ZipList' xs) = ZipList' (zipWith' fs xs)


-- Validation Exercise. Test with checkers.
data Validation e a =
      Failure e
    | Success a
    deriving (Eq, Show)

-- same as Either
instance Functor (Validation e) where
  fmap f (Success a) = Success (f a)
  fmap _ (Failure e) = Failure e

-- This is different
instance Monoid e => Applicative (Validation e) where
  pure a = Success a

  (Success a) <*> (Success a') = Success (a a')
  (Failure e) <*> (Success a)  = Failure e
  (Success a) <*> (Failure e)  = Failure e
  (Failure e) <*> (Failure e') = Failure (e <> e')


instance (Arbitrary a, Arbitrary e) => Arbitrary(Validation e a) where
  arbitrary = genArbitraryValidation

-- I'm using this for practice, but surely we can put this code inside instance realization.

genArbitraryValidation :: (Arbitrary a, Arbitrary e) => Gen(Validation e a)
genArbitraryValidation = do
  a <- arbitrary
  e <- arbitrary
  elements [Failure e, Success a]


instance (Eq a, Eq e) => EqProp(Validation e a) where
  (=-=) = eq


testApplicativeForValidation :: IO ()
testApplicativeForValidation = do
  putStrLn "Test Validation's applicative instance:"
  -- TODO: This is ugly. Not sure how to make it looks nice.
  quickBatch (applicative (undefined :: Validation String (String, String, String)))


-- universal main for every task here (or it might just stay empty)
main :: IO ()
main = quickBatch (monoid Twoo)
