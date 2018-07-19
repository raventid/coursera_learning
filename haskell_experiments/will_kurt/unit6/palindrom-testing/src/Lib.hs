module Lib
    ( isPalindrom
      , preprocess
    ) where

import Data.Char (isPunctuation)

preprocess :: String -> String
preprocess text = filter (not . isPunctuation) text

isPalindrom :: String -> Bool
isPalindrom text = cleanText == reverse cleanText
  where cleanText = preprocess text
