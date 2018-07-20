data PrimeError = TooLarge | InvalidValue

instance Show PrimeError where
  show TooLarge = "Value is too large"
  show InvalidValue = "Value is invalid"

isPrime :: Int -> Either PrimeError Bool
isPrime n
 | n < 2 = Left InvalidValue
 | n > maxN = Left TooLarge
 | otherwise = Right (n `elem` primes)
