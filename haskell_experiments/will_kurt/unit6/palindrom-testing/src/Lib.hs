module Lib
    ( isPalindrom
    ) where

isPalindrom :: String -> Bool
isPalindrom text = text == reverse text
