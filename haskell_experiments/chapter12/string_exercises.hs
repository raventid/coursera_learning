module StringExercises where

import Data.List

notThe :: String -> Maybe String
notThe str = case str /= "the" of
  True -> Just str
  False -> Nothing

-- Well it's not really fare cause it's not recursive and uses intercalate
-- This realization even makes use of Maybe questionable :)
replaceThe :: String -> String
replaceThe str = intercalate " " $ map (f . notThe) $ words str
  where f (Just str) = str
        f (Nothing) = "a"

countTheBeforeVowel :: String -> Int
countTheBeforeVowel str = go 0 $ words str
  where isVowelFirstLetter = (`elem` "aeiou") . head
        go count (x:xs)
          | x == "the" && isVowelFirstLetter (head xs) = go (count + 1) xs
          | otherwise = go count xs
        go count _ = count

countVowels :: String -> Integer
countVowels str = go 0 str
  where isVowel = (`elem` "aeiou")
        go count (x:xs)
          | isVowel(x) = go (count + 1) xs
          | otherwise = go count xs
        go count _ = count
