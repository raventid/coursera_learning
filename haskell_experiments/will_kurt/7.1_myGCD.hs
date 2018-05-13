module GCD where

myGCD a b =  if remainder == 0
             then b
             else myGCD a remainder
  where remainder = a `mod` b
