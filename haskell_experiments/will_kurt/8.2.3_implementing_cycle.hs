module Weird where

finiteCycle :: [a] -> [a]
finiteCycle (x:xs) = x:xs ++ [x]

myCycle :: [a] -> [a]
myCycle (x:xs) = x:myCycle (xs++[x])


-- Ackerman function
ackerman 0 n = n + 1
ackerman m 0 = ackerman (m - 1) 1
ackerman m n = ackerman (m - 1) (ackerman m (n - 1))
