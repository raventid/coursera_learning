module Lib
    ( isPalindrom
    ) where

isPalindrom :: String -> Bool
isPalindrom text = cleanText == reverse cleanText
  where cleanText = filter (not . (== '!')) text
