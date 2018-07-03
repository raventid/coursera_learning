module GCD where

-- If `b > a` we'll just swap them on the first run.

myGCD a b =  if remainder == 0
             then b
             else myGCD a remainder
  where remainder = a `mod` b
