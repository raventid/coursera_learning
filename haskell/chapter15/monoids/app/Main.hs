module Main where


import Data.Monoid hiding ((<>))
import Data.Semigroup
import Test.QuickCheck
import Unsafe.Coerce

-- λ> verboseCheck monoidAssoc
--
--    Passed:
--    ()
--    ()
--    ()
--    // ...repeated 100 times...
--
-- This is how it works by default and this is a problem, we do not check anything actually.

monoidAssoc :: (Eq m, Semigroup m, Monoid m) => m -> m -> m -> Bool
monoidAssoc a b c = (a <> (b <> c)) == ((a <> b) <> c)

-- We can run this in REPL and verify that monoid works! Awesome!
-- quickCheck (monoidAssoc :: String -> String -> String -> Bool)
-- verboseCheck instead of quickCheck will show every data generated by arbitrary

-- There is a difference if you call
--  `verboseCheck monoidLeftIdentity`
--              AND
--  `verboseCheck (monoidLeftIdentity :: String -> Bool)`
-- GHC will use `()` in the first case and we won't get any randomization (see above ^^^)
-- So we specialise function type by hand (it's possible and it's awesome)

monoidLeftIdentity :: (Eq m, Semigroup m, Monoid m) => m -> Bool
monoidLeftIdentity a = (mempty <> a) == a

monoidRightIdentity :: (Eq m, Semigroup m, Monoid m) => m -> Bool
monoidRightIdentity a = (a <> mempty) == a

-- Let's run tests against our Bull type
data Bull =
    Fools
  | Twoo
  deriving (Eq, Show)

instance Arbitrary Bull where
  arbitrary = frequency [ (1, return Fools)
                        , (1, return Twoo) ]

instance Semigroup Bull where
  _ <> _ = Fools

-- This is definitely a wrong Monoid instance.
-- It returns Fools everywhere without counting on mempty or variable values.
instance Monoid Bull where
  mempty = Fools
  mappend = (<>)

-- This is Monoid -> Monoid -> Monoid -> Bool
-- I will use this to make monoidAssoc type specialised.
type BullMappend = Bull -> Bull -> Bull -> Bool

runBullTests :: IO ()
runBullTests = do
  let ma = monoidAssoc
      mli = monoidLeftIdentity
      mlr = monoidRightIdentity
  quickCheck (ma :: BullMappend)
  quickCheck (mli :: Bull -> Bool)
  quickCheck (mlr :: Bull -> Bool)


-- Copied Optional to this file from exercises of this chapter.
data Optional a =
    Nada
  | Only a
  deriving (Eq, Show)

instance (Semigroup a, Monoid a) => Monoid(Optional a) where
  mempty = Nada

  -- mappend
  mappend (Only x) (Only y) = Only ((<>) x y)
  mappend (Only x) _ = Only ((<>) x mempty)
  mappend _ (Only y) = Only ((<>) mempty y)
  mappend Nada Nada = mempty

-- Crap, had to write Arbitrary for my own Optional. I'm suffering :)
genOnly :: Arbitrary a => Gen (Optional a)
genOnly = do
  x <- arbitrary
  return $ Only x

instance Arbitrary a => Arbitrary (Optional a) where
  arbitrary =
    frequency [ (1, genOnly)
              , (1, return Nada) ]


-- Exercise Maybe Another Monoid
-- I modified signature and made an ad-hoc polymorphic and not fully, I want this guaranty.
newtype First' a =
  First' { getFirst' :: Optional a }
  deriving (Eq, Show)

instance (Semigroup a, Monoid a) => Monoid (First' a) where
  mempty =  First' { getFirst' = Nada }
  mappend (First' { getFirst' =  x }) (First' { getFirst' = y }) = First' { getFirst' = (mappend x  y) }

firstMappend :: (Semigroup a, Monoid a) => First' a -> First' a -> First' a
firstMappend = mappend

-- It might seem weird that it works, but as far as I understand it does it like this. It looks that I'm using FirstMappend in quickCheck
-- and it sees that I'm generating correct arbitrary data for it, so GHC allow me to write this, despite original type
-- requires Optional wrapper.
type FirstMappend = First' String -> First' String -> First' String -> Bool

type FstId = First' String -> Bool

genFirst :: Arbitrary a => Gen (First' a)
genFirst = do
  x <- arbitrary
  return First' { getFirst' = x }

instance Arbitrary a => Arbitrary (First' a) where
  arbitrary = genFirst

monoidAssoc' :: (Eq m, Monoid m) => m -> m -> m -> Bool
monoidAssoc' a b c = (a `mappend` (b `mappend` c)) == ((a `mappend` b) `mappend` c)

monoidLeftIdentity' :: (Eq m, Monoid m) => m -> Bool
monoidLeftIdentity' a = (mempty `mappend` a) == a

monoidRightIdentity' :: (Eq m, Monoid m) => m -> Bool
monoidRightIdentity' a = (a `mappend` mempty) == a


runMaybeAnotherMonoidTest :: IO ()
runMaybeAnotherMonoidTest = do
  quickCheck (monoidAssoc' :: FirstMappend)
  quickCheck (monoidLeftIdentity' :: FstId)
  quickCheck (monoidRightIdentity' :: FstId)


newtype Combine a b = Combine { unCombine :: a -> b }

instance Semigroup b => Semigroup (Combine a b) where
  Combine f <> Combine g = Combine (f <> g)
-- Data.Semigroup.<>
-- Monoid exercises
-- Monoid exercises are duplicating Semigroup exercises a bit. Hope it's not terrible.

instance Semigroup b => Monoid(Combine a b) where
  -- TODO: This is the worst mempty you can imagine. But I've been tired, so just wanted this
  -- code to compile, ahaha :)
  mempty = Combine { unCombine = unsafeCoerce }
  mappend = (<>)

data Trivial = Trivial deriving (Eq, Show)

instance Semigroup Trivial where
  _ <> _ = Trivial

instance Monoid Trivial where
  mempty = undefined
  mappend = (<>)

instance Arbitrary Trivial where
  arbitrary = return Trivial

type TrivAssoc = Trivial -> Trivial -> Trivial -> Bool

runExercise1Spec :: IO ()
runExercise1Spec = do
  let mli = monoidLeftIdentity
      mlr = monoidRightIdentity
      ma  = monoidAssoc
  quickCheck (ma  :: Trivial -> Trivial -> Trivial -> Bool)
  quickCheck (mli :: Trivial -> Bool)
  quickCheck (mlr :: Trivial -> Bool)

main :: IO ()
main = putStrLn "You've hitted main stub. Write your code in main."
