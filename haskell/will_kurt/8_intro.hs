module EightIntro where

drop :: Integer -> [a] -> [a]
drop 0 xs = xs
drop _ [] = []
drop c l = EightIntro.drop (c-1) (tail l)
