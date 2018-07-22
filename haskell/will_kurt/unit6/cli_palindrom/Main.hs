module Main where

import Palindrom

main :: IO ()
main = do
  print "Enter a word and I'll let you know if it's a palindrom!"
  text <- getLine
  let response = if isPalindrom text
                 then "it is!"
                 else "it is not!"
  print response
