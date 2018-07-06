module MyReverse where

rcons :: [a] -> a -> [a]
rcons x y = y:x

myExampleReverse :: [a] -> [a]
myExampleReverse xs = foldl rcons [] xs


-- Looks much better with `flip`
-- my personal preference...
myReverse :: String -> String
myReverse str = foldl (flip (:)) [] str
