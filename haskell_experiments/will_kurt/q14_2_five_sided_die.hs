module FiveSidedDie where

data FiveSidedDie =
   S1
 | S2
 | S3
 | S4
 | S5 deriving(Eq, Ord)

instance Enum FiveSidedDie where
  toEnum 0 = S1
  toEnum 1 = S2
  toEnum 2 = S3
  toEnum 3 = S4
  toEnum 4 = S5

  fromEnum S1 = 0
  fromEnum S2 = 1
  fromEnum S3 = 2
  fromEnum S4 = 3
  fromEnum S5 = 4

class (Ord a, Enum a) => Die a where
  throwTheDie :: a -> Int

instance Die FiveSidedDie where
  throwTheDie = fromEnum
