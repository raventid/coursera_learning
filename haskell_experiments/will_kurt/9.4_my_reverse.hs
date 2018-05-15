module MyReverse where

myReverse :: String -> String
myReverse str = foldl (flip (:)) [] str
