-- Fixes behaviour of spaces and other special signs

module Cipher where
import Data.Char

transform :: Char -> Int -> Char
transform c n = chr $ (+) (denormalizeLetterPosition c) $ findPosition $ (+) (normalizeLetterPosition c) n

findPosition :: Int -> Int
findPosition p = p `mod` 26

normalizeLetterPosition :: Char -> Int
normalizeLetterPosition c
  | c `elem` ['A'..'Z'] = ord c - ord 'A'
  | c `elem` ['a'..'z'] = ord c - ord 'a'
  | otherwise = ord c 

denormalizeLetterPosition :: Char -> Int
denormalizeLetterPosition c
  | c `elem` ['A'..'Z'] = ord 'A'
  | c `elem` ['a'..'z'] = ord 'a'
  | otherwise = ord c

caesar :: String -> Int -> String
caesar (x:xs) n = transform x n : caesar xs n
caesar _ _ = []

