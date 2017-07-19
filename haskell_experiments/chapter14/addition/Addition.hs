module Addition where

import Test.Hspec

sayHello :: IO ()
sayHello = putStrLn "Hello!!!"

summator :: (Eq a, Num a) => a -> a -> a
summator a 0 = 0
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
