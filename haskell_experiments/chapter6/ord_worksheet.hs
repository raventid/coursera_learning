module Worksheet where


data DayOfWeek =
  Mon | Tue | Weds | Thu | Fri | Sat | Sun
  deriving(Show, Eq)
  -- deriving (Ord, Show, Eq)
  -- If you need to automatically implement Ord, this is the way to go.

instance Ord DayOfWeek where
  compare Fri Fri = EQ
  compare Fri _   = GT
  compare _ Fri   = LT
  compare _ _     = EQ

