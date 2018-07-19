module Lib
    ( isPalindrom
      , preprocess
    ) where

preprocess :: String -> String
preprocess text = filter (not . (`elem` ['!','.'])) text

isPalindrom :: String -> Bool
isPalindrom text = cleanText == reverse cleanText
  where cleanText = preprocess text
