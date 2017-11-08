module Chapter12 where

newtype Word' =
  Word' String
  deriving (Eq, Show)

vowels = "aeiou"

-- vowels > consonants == Nothing
-- vowels < consonants == Just Word'
mkWord :: String -> Maybe Word'
mkWord str = if numberOfVowels > otherSymbols then Nothing else Just $ Word' str
  where numberOfVowels = length $ filter (`elem` vowels) str
        otherSymbols = (length str) - numberOfVowels

data Nat =
    Zero
  | Succ Nat
  deriving (Eq, Show)

natToInteger :: Nat -> Integer
natToInteger Zero = 0
natToInteger (Succ previous) = 1 + (natToInteger previous)

integerToNat :: Integer -> Maybe Nat
integerToNat i
 | i < 0 = Nothing
 | otherwise = Just $ go i
 where go i
        | i == 0 = Zero
        | otherwise = Succ (go (i - 1))
