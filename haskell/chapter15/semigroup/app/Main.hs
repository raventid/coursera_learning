module Main where

import qualified Data.Monoid as M
import Data.Semigroup
import Data.List.NonEmpty
import Test.QuickCheck

-- We can create custom symbolic constructors!
-- But this symbolic constructor cannot be prefix, only infix :(

-- How cool is that? I think it's the coolest things I've ever seen. (perhaps, no)
-- λ> 10 :!!: "Raventid"
-- 10 :!!: "Raventid" :: Q

data Q =
  Int :!!: String

-- Let's start exercises part:

-- Our semigroup rule we will use for every proof:
semigroupAssoc :: (Eq m, Semigroup m) => m -> m -> m -> Bool
semigroupAssoc a b c =
 (a <> (b <> c)) == ((a <> b) <> c)


-- 1.
data Trivial = Trivial deriving (Eq, Show)

-- This is one is extremely straightforward
instance Semigroup Trivial where
  _ <> _ = Trivial

instance Arbitrary Trivial where
  arbitrary = return Trivial

type TrivAssoc = Trivial -> Trivial -> Trivial -> Bool

runExercise1Spec :: IO ()
runExercise1Spec = quickCheck (semigroupAssoc :: TrivAssoc)

-- 2.
newtype Identity a = Identity a deriving (Eq, Show)

instance (Semigroup a) => Semigroup (Identity a) where
  (Identity x) <> (Identity y) = Identity (x <> y)

instance (Arbitrary a) => Arbitrary (Identity a) where
  arbitrary = do
    x <- arbitrary
    return (Identity x)

type IdentAssoc = Identity String -> Identity String -> Identity String -> Bool

runExercise2Spec :: IO ()
runExercise2Spec = quickCheck (semigroupAssoc :: IdentAssoc)

-- 3.
data Two a b = Two a b deriving (Eq, Show)

instance (Semigroup a, Semigroup b) => Semigroup (Two a b) where
  (Two x y) <> (Two x' y') = Two (x <> x') (y <> y')

instance (Arbitrary a, Arbitrary b) => Arbitrary (Two a b) where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    return (Two x y)

type TwoAssoc = Two String (Sum Int) -> Two String (Sum Int) -> Two String (Sum Int) -> Bool

runExercise3Spec :: IO ()
runExercise3Spec = quickCheck (semigroupAssoc :: TwoAssoc)

-- 4.
data Three a b c = Three a b c deriving (Eq, Show)

instance (Semigroup a, Semigroup b, Semigroup c) => Semigroup (Three a b c) where
  (Three x y z) <> (Three x' y' z') = Three (x <> x') (y <> y') (z <> z')

instance (Arbitrary a, Arbitrary b, Arbitrary c) => Arbitrary (Three a b c) where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    z <- arbitrary
    return (Three x y z)

type ThreeAssoc =
  Three String (Sum Int) (Product Int)
  -> Three String (Sum Int) (Product Int)
  -> Three String (Sum Int) (Product Int)
  -> Bool

runExercise4Spec :: IO()
runExercise4Spec = quickCheck (semigroupAssoc :: ThreeAssoc)

-- 5. It's already boring a bit, but I'll do this.
data Four a b c d = Four a b c d

instance (Eq a, Eq b, Eq c, Eq d) => Eq(Four a b c d) where
  (==) (Four x y z w) (Four x' y' z' w') = x == x' && y == y' && z == z' && w == w'

instance (Show a, Show b, Show c, Show d) => Show(Four a b c d) where
  show (Four x y z w) =
    "Four " ++ show x ++ " " ++ show y ++ " " ++ show z ++ " " ++ show w

instance (Semigroup a, Semigroup b, Semigroup c, Semigroup d) => Semigroup(Four a b c d) where
  (Four x y z w) <> (Four x' y' z' w') = Four (x <> x') (y <> y') (z <> z') (w <> w')

instance (Arbitrary a, Arbitrary b, Arbitrary c, Arbitrary d) => Arbitrary(Four a b c d) where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    z <- arbitrary
    w <- arbitrary
    return (Four x y z w)

type FourAssoc =
  Four String (Sum Int) (Product Int) String
  -> Four String (Sum Int) (Product Int) String
  -> Four String (Sum Int) (Product Int) String
  -> Bool

runExercise5Spec :: IO ()
runExercise5Spec = quickCheck (semigroupAssoc :: FourAssoc)

-- 6.
newtype BoolConj = BoolConj Bool deriving(Eq, Show)

instance Semigroup(BoolConj) where
  (BoolConj True) <> (BoolConj True) = BoolConj True
  _ <> _ = BoolConj False

instance Arbitrary(BoolConj) where
  arbitrary = do
    x <- arbitrary
    return (BoolConj x)

type BoolConjAssoc = BoolConj -> BoolConj -> BoolConj -> Bool

runExercise6Spec :: IO ()
runExercise6Spec = quickCheck (semigroupAssoc :: BoolConjAssoc)

-- 7.
newtype BoolDisj = BoolDisj Bool deriving (Eq, Show)

instance Semigroup(BoolDisj) where
  (BoolDisj True) <> (BoolDisj True) = BoolDisj True
  (BoolDisj True) <> (BoolDisj False) = BoolDisj True
  (BoolDisj False) <> (BoolDisj True) = BoolDisj True
  _ <> _ = BoolDisj False

instance Arbitrary(BoolDisj) where
  arbitrary = do
    x <- arbitrary
    return (BoolDisj x)

type BoolDisjAssoc = BoolDisj -> BoolDisj -> BoolDisj -> Bool

runExercise7Spec :: IO ()
runExercise7Spec = quickCheck (semigroupAssoc :: BoolDisjAssoc)

-- 8.
data Or a b =
    Fst a
  | Snd b
  deriving (Eq, Show)

instance (Semigroup a, Semigroup b) => Semigroup(Or a b) where
  (Fst x) <> (Fst y) = Fst y
  (Fst x) <> (Snd y) = Snd y
  (Snd x) <> (Fst y) = Snd x
  (Snd x) <> (Snd y) = Snd y

instance (Arbitrary a, Arbitrary b) => Arbitrary(Or a b) where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    oneof [ return $ Fst x
          , return $ Snd y ]


type OrAssoc = Or String (Sum Int) -> Or String (Sum Int) -> Or String (Sum Int) -> Bool

runExercise8Spec :: IO ()
runExercise8Spec = quickCheck (semigroupAssoc :: OrAssoc)

-- 9.

newtype Combine a b = Combine { unCombine :: a -> b }

instance Semigroup b => Semigroup (Combine a b) where
  Combine f <> Combine g = Combine (f <> g)

-- genFunc :: (CoArbitrary a, Arbitrary b) => Gen (a -> b)
-- genFunc = arbitrary

-- genCombine :: (CoArbitrary a, Arbitrary b) => Gen (Combine a b)
-- genCombine = do
--   f <- genFunc
--   return $ Combine f

instance (CoArbitrary a, Arbitrary b) => Arbitrary (Combine a b) where
    arbitrary = do
      f <- arbitrary
      return $ Combine f

-- Not sure about this one, should think a bit more.
-- runExercise9Spec :: IO ()
-- runExercise9Spec = quickCheck (semigroup :: Combine)

-- 10.
-- TODO

-- 11.
data Validation a b =
    Failure' a
  | Success' b
  deriving (Eq, Show)

-- Playing with syntax. It's a bit more concise, but I'm not sure it's beautiful.
instance Semigroup (Validation a b) where
      f@(Failure' x) <> Success' _ = f
      Success' _ <> f@(Failure' x) = f
      f@(Failure' x) <> Failure' _ = f
      s@(Success' x) <> Success' _ = s

instance (Arbitrary a, Arbitrary b) => Arbitrary (Validation a b) where
  arbitrary = genValidation

-- Just play with this. Writing code right inside of an Arbitrary instance hides
-- Gen wrapper. Here we make it clean and visible.
genValidation :: (Arbitrary a, Arbitrary b) => Gen (Validation a b)
genValidation = do
  a <- arbitrary
  b <- arbitrary
  elements [ Failure' a
           , Success' b ]

type ValidationAssoc = Validation String [Int] -> Validation String [Int] -> Validation String [Int] -> Bool

runExercise11Spec :: IO ()
runExercise11Spec = quickCheck (semigroupAssoc :: ValidationAssoc)

main :: IO ()
main = putStrLn "Stub main function. Write your code in main."
