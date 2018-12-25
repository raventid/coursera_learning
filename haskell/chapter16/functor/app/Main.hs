module Main where

import Test.QuickCheck
import Test.QuickCheck.Function

-- Functor QuickCheck property test. Based on functor laws.
functorIdentity :: (Functor f, Eq (f a)) => f a -> Bool
functorIdentity f = fmap id f == f

functorCompose :: (Eq(f c), Functor f) => (a -> b) -> (b -> c) -> f a -> Bool
functorCompose f g x = (fmap g (fmap f x)) == (fmap (g . f) x)

-- QuickCheck will give us Fun (quickCheckSpecialFunctionWeDontNeed, generalFunction)
-- We'll take general haskell funtion and use in our prover.
functorCompose' :: (Eq(f c), Functor f) => f a -> Fun a b -> Fun b c -> Bool
functorCompose' x (Fun _ f) (Fun _ g) = (fmap g (fmap f x)) == (fmap (g . f) x)

-- To check this we run standard quickCheck scenario:
-- quickCheck (functorIdentity :: [Int] -> Bool)

-- To prove composion we need more advanced tool:
-- c = functorCompose (+1) (*2)
-- li x = c (x :: [Int])
-- quickCheck li

-- We can generate function with quickCheck this way.
-- This is the type for QuickCheck to work with:
-- type IntToInt = Fun Int Int

-- This is the type for whole proof.
-- type IntFC = [Int] -> IntToInt -> IntToInt -> Bool

-- quickCheck (functorCompose' :: IntFC)
-- There is a legend that `verboseCheck` cannot print Fun, but it could smth like this:
-- $ Passed:
-- $ [8,-44,-36,39]
-- $ <fun>
-- $ <fun>
-- Which is not so bad in my opinion.


-- Exercise: Instances of Func (IOF)

-- General setup. I will use Ints everywhere in specs.
type IntToInt = Fun Int Int

type ID a = a -> Bool -- For Identity proof.
type FC a = a -> IntToInt -> IntToInt -> Bool -- For composition proof.

-- Could be nice to generate types dynamically with this. Not sure how to do it.
-- proofIdentity :: a -> b
-- proofIdentity x = functorIdentity :: (IntID x)

-- AFAIK there is no currently any technology to apply this.

-- And the same with composition.
-- proofComposition


-- 1.
newtype Identity a = Identity a deriving(Eq, Show)

instance Functor(Identity) where
  fmap f (Identity x) = Identity $ f x

instance (Arbitrary a) => Arbitrary(Identity a) where
  arbitrary = do
    x <- arbitrary
    return $ Identity x

type IdentityBase = Identity Int -- Concrete type

runIOF1spec :: IO ()
runIOF1spec = do
  quickCheck (functorIdentity :: (ID IdentityBase))
  quickCheck (functorCompose' :: (FC IdentityBase))

-- 2.
data Pair a = Pair a a deriving(Eq, Show)

instance Functor(Pair) where
  fmap f (Pair a b) = Pair (f a) (f b)

instance (Arbitrary a) => Arbitrary(Pair a) where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    return $ Pair x y

type PairBase = Pair Int

runIOF2Spec :: IO ()
runIOF2Spec = do
  quickCheck (functorIdentity :: (ID PairBase))
  quickCheck (functorCompose' :: (FC PairBase))

-- 3.
data Two a b = Two a b

instance Functor(Two a) where
  fmap f (Two a b) = Two a $ f b

instance (Arbitrary a, Arbitrary b) => Arbitrary(Two a b) where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    return $ Two x y

type TwoBase = Two Int Int

runIOF3Spec :: IO ()
runIOF3Spec = do
  quickCheck (functorIdentity :: (ID PairBase))
  quickCheck (functorCompose' :: (FC PairBase))

-- 4.
data Three a b c = Three a b c deriving(Eq, Show)

instance Functor(Three a b) where
  fmap f (Three a b c) = Three a b $ f c

instance (Arbitrary a, Arbitrary b, Arbitrary c) => Arbitrary(Three a b c) where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    z <- arbitrary
    return $ Three x y z

type ThreeBase = Three Int Int Int

runIOF4Spec :: IO ()
runIOF4Spec = do
  quickCheck (functorIdentity :: (ID ThreeBase))
  quickCheck (functorCompose' :: (FC ThreeBase))

-- 5.
data Three' a b = Three' a b b deriving(Eq, Show)

instance Functor(Three' a) where
  fmap f (Three' a b c) = Three' a (f b) (f c)

instance (Arbitrary a, Arbitrary b) => Arbitrary(Three' a b) where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    z <- arbitrary
    return $ Three' x y z

type ThreeBase' = Three' Int Int

runIOF5Spec :: IO ()
runIOF5Spec = do
  quickCheck (functorIdentity :: (ID ThreeBase'))
  quickCheck (functorCompose' :: (FC ThreeBase'))

-- 6.
data Four a b c d = Four a b c d deriving(Eq, Show)

instance Functor(Four a b c) where
  fmap f (Four a b c d) = Four a  b c (f d)

instance (Arbitrary a, Arbitrary b, Arbitrary c, Arbitrary d) => Arbitrary(Four a b c d) where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    z <- arbitrary
    w <- arbitrary
    return $ Four x y z w

type FourBase = Four Int Int Int Int

runIOF6Spec :: IO ()
runIOF6Spec = do
  quickCheck (functorIdentity :: (ID FourBase))
  quickCheck (functorCompose' :: (FC FourBase))


-- 7.
data Four' a b = Four' a a a b deriving(Eq, Show)

instance Functor(Four' a) where
  fmap f (Four' a b c d) = Four' a  b c (f d)

instance (Arbitrary a, Arbitrary b) => Arbitrary(Four' a b) where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    z <- arbitrary
    w <- arbitrary
    return $ Four' x y z w

type FourBase' = Four' Int Int

runIOF7Spec :: IO ()
runIOF7Spec = do
  quickCheck (functorIdentity :: (ID FourBase'))
  quickCheck (functorCompose' :: (FC FourBase'))

data Possibly a =
    LolNope
  | Yep a
  deriving (Eq, Show)

instance Functor (Possibly) where
  fmap _ LolNope = LolNope
  fmap f (Yep a) = Yep (f a)

instance Arbitrary a => Arbitrary (Possibly a) where
  arbitrary = do
    a <- arbitrary
    elements [Yep a, LolNope]

runPossibleSpec :: IO ()
runPossibleSpec = do
  -- Just for fun. Let's run 1000 examples instead of 100.
  quickCheckWith stdArgs {maxSuccess = 1000} (functorIdentity :: (ID (Possibly Int)))
  quickCheck (functorCompose' :: (FC (Possibly Int)))

data Some a b =
    First a
  | Second b
  deriving (Show, Eq)

instance Functor (Some a) where
  fmap _ (First a) = First a
  fmap f (Second b) = Second (f b)

instance (Arbitrary a, Arbitrary b) => Arbitrary(Some a b) where
  arbitrary = do
    a <- arbitrary
    b <- arbitrary
    elements [First a, Second b]

runSomeSpec :: IO ()
runSomeSpec = do
  quickCheckWith stdArgs {maxSuccess = 250} (functorIdentity :: (ID (Some Int Int)))
  quickCheckWith stdArgs {maxSuccess = 250} (functorCompose' :: (FC (Some Int Int)))


-- Main function. Stub, I'm not using.
main :: IO ()
main = putStrLn "Main stub as usual."
