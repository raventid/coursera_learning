module Weird where

finiteCycle :: [a] -> [a]
finiteCycle (x:xs) = x:xs ++ [x]

myCycle :: [a] -> [a]
myCycle (x:xs) = x:myCycle (xs++[x])
