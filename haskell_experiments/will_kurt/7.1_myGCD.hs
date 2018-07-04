module GCD where

-- If `b > a` we'll just swap them on the first run.

myGCD a b =  if remainder == 0
             then b
             else myGCD b remainder
  where remainder = a `mod` b

-- myGCD a b 0 = b
-- myGCD a b remainder = myGCDa 
-- myGCD a b remainder = 
