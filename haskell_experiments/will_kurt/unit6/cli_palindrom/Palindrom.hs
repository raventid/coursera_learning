module Palindrom(isPalindrom) where

import Data.Char (toLower, isSpace, isPunctuation)

stripWhiteSpaces :: String -> String
stripWhiteSpaces text = filter (not . isSpace) text

stripPunctuation :: String -> String
stripPunctuation text = filter (not . isPunctuation) text

toLowerCase :: String -> String
toLowerCase text = map toLower text

preprocess :: String -> String
preprocess = stripPunctuation . stripWhiteSpaces . toLowerCase

isPalindrom :: String -> Bool
isPalindrom text = cleanText == reverse cleanText
  where cleanText = preprocess text -- typo page 452
