module Main where

import Data.Monoid
import Test.QuickCheck

monoidAssoc :: (Eq m, Monoid m) => m -> m -> m -> Bool
monoidAssoc a b c = (a <> (b <> c)) == ((a <> b) <> c)

-- We can run this in REPL and verify that monoid works! Awesome!
-- quickCheck (monoidAssoc :: String -> String -> String -> Bool)
-- verboseCheck instead of quickCheck will show every data generated by arbitrary

monoidLeftIdentity :: (Eq m, Monoid m) => m -> Bool
monoidLeftIdentity a = (mempty <> a) == a

monoidRightIdentity :: (Eq m, Monoid m) => m -> Bool
monoidRightIdentity a = (a <> mempty) == a

-- Let's run tests against our Bull type
data Bull =
    Fools
  | Twoo
  deriving (Eq, Show)

instance Arbitrary Bull where
  arbitrary = frequency [ (1, return Fools)
                       , (1, return Twoo) ]

instance Monoid Bull where
  mempty = Fools
  mappend _ _ = Fools

type BullMappend = Bull -> Bull -> Bull -> Bool

runBullTests :: IO ()
runBullTests = do
  let ma = monoidAssoc
      mli = monoidLeftIdentity
      mlr = monoidRightIdentity
  quickCheck (ma :: BullMappend)
  quickCheck (mli :: Bull -> Bool)
  quickCheck (mlr :: Bull -> Bool)


-- Execrcise Maybe Another Monoid
newtype First' a =
  First' { getFirst' :: Maybe a }
  deriving (Eq, Show)

instance Monoid (First' a) where
  mempty = undefined
  mappend = undefined

firstMappend :: First' a -> First' a -> First' a
firstMappend = mappend

type FirstMappend =
     First' String
  -> First' String
  -> First' String
  -> Bool

type FstId = First' String -> Bool

runMaybeAnotherMonoidTest :: IO ()
runMaybeAnotherMonoidTest = do
  quickCheck (monoidAssoc :: FirstMappend)
  quickCheck (monoidLeftIdentity :: FstId)
  quickCheck (monoidRightIdentity :: FstId)

main :: IO ()
main = putStrLn "You've hitted main stub. Write your code in main."
