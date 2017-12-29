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

type IntID a = a -> Bool -- For Identity proof.
type IntFC a = a -> IntToInt -> IntToInt -> Bool -- For composition proof.

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
  quickCheck (functorIdentity :: (IntID IdentityBase))
  quickCheck (functorCompose' :: (IntFC IdentityBase))

-- 2. data Pair a = Pair a a
-- 3. data Two a b = Two a b
-- 4. data Three a b c = Three a b c
-- 5. data Three' a b = Three' a b b
-- 6. data Four a b c d = Four a b c d
-- 7. data Four' a b = Four' a a a b

main :: IO ()
main = putStrLn "Main stub as usual."
