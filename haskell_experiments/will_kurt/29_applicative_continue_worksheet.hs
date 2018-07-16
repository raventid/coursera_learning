doorPrize :: [Integer]
doorPrize = [10, 20]

boxMultiplier :: [Integer]
boxMultiplier = [10]

calculate :: [Integer]
calculate = pure (*) <*> doorPrize <*> boxMultiplier
