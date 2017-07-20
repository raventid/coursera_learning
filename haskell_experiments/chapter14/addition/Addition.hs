module Addition where

import Test.Hspec
import Test.QuickCheck

trivialInt :: Gen Int
trivialInt = return 1

oneThroughThree :: Gen Int
oneThroughThree = elements [1, 2, 3]

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

