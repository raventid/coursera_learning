module ROT where

data FourLettersAlphabet = L1 | L2 | L3 | L4 deriving (Show, Enum, Bounded)

rotN :: (Bounded a, Enum a) => Int -> a -> a
rotN alphabetSize character = toEnum rotation
  where halfAlphabet = alphabetSize `div` 2
        offset = fromEnum character + halfAlphabet
        rotation = offset `mod` alphabetSize

largestCharNumber :: Int
largestCharNumber = fromEnum (maxBound :: Char)

rotChar :: Char -> Char
rotChar charToEncrypt = rotN sizeOfAlphabet charToEncrypt
  where sizeOfAlphabet = 1 + fromEnum (maxBound :: Char)

fourLetterAlphabetEncoder :: [FourLettersAlphabet] -> [FourLettersAlphabet]
fourLetterAlphabetEncoder vals = map rot41 vals
  where alphaSize = 1 + fromEnum (maxBound :: FourLettersAlphabet)
        rot41 = rotN alphaSize

-- Before this it worked really bad with odd numbered alphabets.

data ThreeLetterAlphabet = Alpha | Beta | Gamma deriving (Show, Enum, Bounded)

rotNdecoder :: (Bounded a, Enum a) => Int -> a -> a
rotNdecoder n c = toEnum rotation
  where halfN = n `div` 2
        offset = if even n
                    then fromEnum c + halfN
                    else 1 + fromEnum c + halfN
        rotation = offset `mod` n

threeLetterDecoder :: [ThreeLetterAlphabet] -> [ThreeLetterAlphabet]
threeLetterDecoder xs = map rot31decoder xs
  where alphaSize = 1 + fromEnum (maxBound :: ThreeLetterAlphabet)
        rot31decoder = rotNdecoder alphaSize

-- Generalized solution

rotEncoder :: String -> String
rotEncoder text = map rotChar text
  where alphaSize = 1 + fromEnum (maxBound :: Char)

rotDecoder :: String -> String
rotDecoder text = map rotCharDecoder text
  where alphaSize = 1 + fromEnum (maxBound :: Char)
        rotCharDecoder = rotNdecoder alphaSize
