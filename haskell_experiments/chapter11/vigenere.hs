module Vigenere where
import Data.Char

-- Mi + Ki mod 26
-- This works correctly according to test, but code is really ugly! Rewrite.
transform :: Char -> Char -> Char
transform c n = chr $ (+) (denormalizeLetterPosition c) $ findPosition $ (+) (normalizeLetterPosition c) (normalizeLetterPosition n)

findPosition :: Int -> Int
findPosition p = p `mod` 26

normalizeLetterPosition :: Char -> Int
normalizeLetterPosition c
  | c `elem` ['A'..'Z'] = ord c - ord 'A'
  | c `elem` ['a'..'z'] = ord c - ord 'a'
  | otherwise = ord c

denormalizeLetterPosition :: Char -> Int
denormalizeLetterPosition  c
  | c `elem` ['A'..'Z'] = ord 'A'
  | c `elem` ['a'..'z'] = ord 'a'
  | otherwise = ord c

-- Laziness is the most awesome thing I've ever seen, just look at this cool crap!!!
prepareKey :: String -> Int -> String
prepareKey key length = take length $ concat $ repeat key

vigenere :: String -> String -> String
vigenere xs cipher =  zipWith transform xs key
  where key = prepareKey cipher $ length xs

testVigenere :: IO ()
testVigenere = putStrLn $ vigenere "MEETATDAWN" "ALLY"
