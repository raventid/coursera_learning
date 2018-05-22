module XorBool where

xorBool :: Bool -> Bool -> Bool
xorBool left right = (left || right) && (not (left && right))

xorPair :: (Bool, Bool) -> Bool
xorPair (x, y) = xorBool x y

xor :: [Bool] -> [Bool] -> [Bool]
xor xs ys = map xorPair (zip xs ys)

type Bits = [Bool]

intoBits' :: Int -> Bits
intoBits' 0 = [False]
intoBits' 1 = [True]
intoBits' n = if remainder == 0
              then False : intoBits' nextVal
              else True : intoBits' nextVal
  where
    remainder = n `mod` 2
    nextVal = n `div` 2
