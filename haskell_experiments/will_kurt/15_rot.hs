module ROT where

data FourLettersAlphabet = L1 | L2 | L3 | L4 deriving (Show, Enum, Bounded)

-- A couple of notes:
-- `div` - one more time, 4 `div` 2 = 2 and 5 `div` 2 = 2 too.
-- `mod` has a superpower btw, it allows you to rotate values
-- inside some bounds like this:
-- λ> 28 `mod` 4
-- 0
-- λ> 29 `mod` 4
-- 1
-- λ> 30 `mod` 4
-- 2
-- λ> 31 `mod` 4
-- 3
-- λ> 32 `mod` 4
-- 0
rotN :: (Bounded a, Enum a) => Int -> a -> a
rotN alphabetSize character = toEnum rotation
  where halfAlphabet = alphabetSize `div` 2
        -- To rotate, you add half of your alphabet size
        -- to the Int value of your letter.
        offset = fromEnum character + halfAlphabet
        -- For half of your Enum values,
        -- adding half the size of the alphabet will
        -- give you an Int outside the bounds of your enum.
        -- To solve this, you modulo your offset by the alphabet size.
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
