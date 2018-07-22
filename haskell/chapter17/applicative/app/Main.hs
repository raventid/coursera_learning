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


-- Chapter exercises
-- 1.
data Pair a = Pair a a deriving (Eq, Show)

instance Functor(Pair) where
  fmap f (Pair a a') = Pair (f a) (f a')

instance Applicative(Pair) where
  pure a = Pair a a

  (<*>) (Pair f f') (Pair x x') = Pair (f x) (f' x')

instance (Arbitrary a) => Arbitrary(Pair a) where
  arbitrary = do
    a <- arbitrary
    a' <- arbitrary
    return $ Pair a a'

instance (Eq a) => EqProp(Pair a) where
  (=-=) = eq

-- TODO: I'll use this approach with undefined everywhere, but I should find the way out.
testApplicativeForPair :: IO ()
testApplicativeForPair =
  quickBatch (applicative (undefined :: Pair (String, String, String)))

-- 2.
data Two a b = Two a b deriving (Eq, Show)

instance Functor(Two a) where
  fmap f (Two a b) = Two a (f b)

instance (Monoid a) => Applicative(Two a) where
  pure b = Two mempty b

  (<*>) (Two a f) (Two a' b) = Two (a <> a') (f b)

instance (Arbitrary a, Arbitrary b) => Arbitrary(Two a b) where
  arbitrary = do
    a <- arbitrary
    b <- arbitrary
    return $ Two a b

instance (Eq a, Eq b) => EqProp(Two a b) where
  (=-=) = eq

testApplicativeForTwo :: IO ()
testApplicativeForTwo = quickBatch (applicative (undefined :: Two String (String, String, String)))

-- 3.
data Three a b c = Three a b c deriving (Eq, Show)

instance Functor(Three a b) where
  fmap f (Three a b c) = Three a b (f c)

instance (Monoid a, Monoid b) => Applicative(Three a b) where
  pure a = Three mempty mempty a

  (<*>) (Three a b f) (Three a' b' x) = Three (a <> a') (b <> b') (f x)

instance (Arbitrary a, Arbitrary b, Arbitrary c) => Arbitrary(Three a b c) where
  arbitrary = do
    a <- arbitrary
    b <- arbitrary
    c <- arbitrary
    return $ Three a b c

instance (Eq a, Eq b, Eq c) => EqProp(Three a b c) where
  (=-=) = eq

testApplicativeForThree :: IO ()
testApplicativeForThree = quickBatch (applicative (undefined :: Three String String (String, String, String)))

-- 4.
data Three' a b = Three' a b b deriving (Eq, Show)

instance Functor(Three' a) where
  fmap f (Three' a b b') = Three' a (f b) (f b')

instance (Monoid a) => Applicative(Three' a) where
  pure a = Three' mempty a a

  (<*>) (Three' a f f') (Three' a' x x') = Three' (a <> a') (f x) (f' x')

instance (Arbitrary a, Arbitrary b) => Arbitrary(Three' a b) where
  arbitrary = do
    a <- arbitrary
    b <- arbitrary
    b' <- arbitrary
    return $ Three' a b b'

instance (Eq a, Eq b) => EqProp(Three' a b) where
  (=-=) = eq

testApplicativeForThreePrime :: IO ()
testApplicativeForThreePrime =
  quickBatch (applicative (undefined :: (Three' (String,String,String) (String, String, String))))

-- 5.
data Four a b c d = Four a b c d deriving (Eq, Show)

instance Functor(Four a b c) where
  fmap f (Four a b c d) = Four a b c (f d)

instance (Monoid a, Monoid b, Monoid c) => Applicative(Four a b c) where
  pure a = Four mempty mempty mempty a

  (<*>) (Four a b c f) (Four a' b' c' x) = Four (a <> a') (b <> b') (c <> c') (f x)

instance (Arbitrary a, Arbitrary b, Arbitrary c, Arbitrary d) => Arbitrary(Four a b c d) where
  arbitrary = do
    a <- arbitrary
    b <- arbitrary
    c <- arbitrary
    d <- arbitrary
    return $ Four a b c d

instance (Eq a, Eq b, Eq c, Eq d) => EqProp(Four a b c d) where
  (=-=) = eq

testApplicativeForFour :: IO ()
testApplicativeForFour = quickBatch (applicative (undefined :: Four (String, String, String) (String, String, String) (String, String, String) (String, String, String)))

-- 6.
data Four' a b = Four' a a a b deriving (Eq, Show)

instance Functor(Four' a) where
  fmap f (Four' a a' a'' b) = Four' a a' a'' (f b)

instance (Monoid a) => Applicative(Four' a) where
  pure a = Four' mempty mempty mempty a

  (<*>) (Four' a a' a'' f) (Four' b b' b'' x) = Four' (a <> b) (a' <> b') (a'' <> b'') (f x)

instance (Arbitrary a, Arbitrary b) => Arbitrary(Four' a b) where
  arbitrary = do
    a   <- arbitrary
    a'  <- arbitrary
    a'' <- arbitrary
    b   <- arbitrary
    return $ Four' a a' a'' b

instance (Eq a, Eq b) => EqProp(Four' a b) where
  (=-=) = eq

testApplicativeForFourPrime :: IO ()
testApplicativeForFourPrime =
  quickBatch(applicative (undefined :: Four' (String, String, String) (String, String, String)))

-- universal main for every task here (or it might just stay empty)
main :: IO ()
main = quickBatch (monoid Twoo)
