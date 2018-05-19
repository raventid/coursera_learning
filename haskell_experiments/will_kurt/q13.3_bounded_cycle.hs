{-# LANGUAGE ScopedTypeVariables #-}

module BoundedCycle where

cycleSucc :: (Bounded a, Enum a, Ord a) => a -> a
cycleSucc n = if n == maxBound then minBound else succ n
