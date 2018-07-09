module Harmonic where

harmonic :: (Fractional a, Enum a) => Int -> a
harmonic n = foldl (+) 0 $ take n $ foldr (\denominator acc -> (1/denominator):acc) [] [1..]


-- runHarmonic :: Fractional a => Int -> [a]
-- runHarmonic n = take n sumHarmonic

-- sumHarmonic :: Fractional a => a -> a
-- sumHarmonic 1 = 1
-- sumHarmonic i = 1/i + sumHarmonic (i-1)
