module Addition where

import Test.Hspec
import Test.QuickCheck

trivialInt :: Gen Int
trivialInt = return 1

oneThroughThree :: Gen Int
oneThroughThree = elements [1, 2, 3]

genBool :: Gen Bool
genBool = choose (False, True)

genBool' :: Gen Bool
genBool' = elements [False, True]

genOrdering :: Gen Ordering
genOrdering = elements [LT, EQ, GT]

genChar :: Gen Char
genChar = elements ['a'..'z']

genTuple :: (Arbitrary a, Arbitrary b) => Gen(a, b)
genTuple = do
  a <- arbitrary
  b <- arbitrary
  return (a, b)

genThreeple :: (Arbitrary a, Arbitrary b, Arbitrary c) => Gen(a, b, c)
genThreeple = do
  a <- arbitrary
  b <- arbitrary
  c <- arbitrary
  return (a, b, c)

genEither :: (Arbitrary a, Arbitrary b) => Gen(Either a b)
genEither = do
  a <- arbitrary
  b <- arbitrary
  elements [Left a, Left b]

sayHello :: IO ()
sayHello = putStrLn "Hello!!!"

summator :: (Eq a, Num a) => a -> a -> a
summator _ 0 = 0
summator a b = a + summator a (b - 1)

main :: IO ()
main = hspec $ do
  describe "Addition" $ do
    it "1 + 1 is greater then 1" $ do
      (1 + 1) > 1 `shouldBe` True
    it "2 + 2 is equal to 4" $ do
      (2 + 2) `shouldBe` 4

  describe "summator" $ do
    it "takes 2 and 10 and returns 20" $ do
      summator 2 10 `shouldBe` 20

  describe "first quickCheck" $ do
    it "x + 1 is always greater than x" $ do
      property $ \x -> x + 1 > (x :: Int)

