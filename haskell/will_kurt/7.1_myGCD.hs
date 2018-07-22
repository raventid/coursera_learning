module GCD where

-- If `b > a` we'll just swap them on the first run.

myGCD a b =  if remainder == 0
             then b
             else myGCD b remainder
  where remainder = a `mod` b

myRecGCD a b = goMyRecGCD a b 1
goMyRecGCD a b 0 = a
goMyRecGCD a b _remainder = goMyRecGCD b remainder remainder
  where
    remainder = a `mod` b
