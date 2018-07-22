{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text as T
import Data.Semigroup

aWord :: T.Text
aWord = "Cheese"

combinedTextMonoid :: T.Text
combinedTextMonoid = mconcat ["some", "text"]

combinedTextSemigroup :: T.Text
combinedTextSemigroup = "some" <> "text"

myLines :: T.Text -> [T.Text]
myLines text = T.splitOn "\n" text

myUnlines :: [T.Text] -> T.Text
myUnlines xs = T.intercalate "\n" xs


main :: IO ()
main = do
  print aWord
