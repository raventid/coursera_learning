doorPrize :: [Integer]
doorPrize = [10, 20]

boxMultiplier :: [Integer]
boxMultiplier = [10]

calculate :: [Integer]
calculate = pure (*) <*> doorPrize <*> boxMultiplier

allFmap :: Applicative f => (a -> b) -> f a -> f b
allFmap f v =  fmap f v


spec1 = allFmap (+ 1) [1,2,3] == [2,3,4]
spec2 = allFmap (+ 1) (Just 5) == Just 6
spec3 = allFmap (+ 1) Nothing == Nothing

specs = all (\x -> x == True) [spec1, spec2, spec3]

example :: Maybe Int
example = (pure (*)) <*> (pure ((+) 2 4)) <*> pure 6
