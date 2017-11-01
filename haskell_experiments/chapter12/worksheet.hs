module Chapter12 where

import Data.List

-- Let's start with Maybe
ifEvenAdd2 :: Integer -> Maybe Integer
ifEvenAdd2 n = if even n then Just (n + 2) else Nothing

type Name = String
type Age = Integer

-- Can we use empty string? - Yes! This is a problem!
data Person = Person Name Age deriving Show

-- We solved our problem with constructor function.
-- We call this `Smart constructor` - very popular term in Haskell.
mkPerson :: Name -> Age -> Maybe Person
mkPerson name age
  | name /= "" && age >= 0 = Just $ Person name age
  | otherwise = Nothing

-- Let's make it a bit better.
-- We have to derive equality to compare values.
data PersonInvalid = NameEmpty
                     | AgeTooLow
                     deriving (Eq, Show)

blah :: PersonInvalid -> String
blah pi
  | pi == NameEmpty = "NameEmpty"
  | pi == AgeTooLow = "AgeTooLow"
  | otherwise = "???"

-- Let's improve our smart constructor and write it like this.
mkPerson' :: Name -> Age -> Either PersonInvalid Person
mkPerson' name age
  | name /= "" && age >= 0 = Right $ Person name age
  | name == "" = Left NameEmpty
  | otherwise = Left AgeTooLow

type ValidatePerson a = Either [PersonInvalid] a

ageOkay :: Age -> Either [PersonInvalid] Age
ageOkay age = case age > 0 of
  True -> Right age
  False -> Left [AgeTooLow]

nameOkay :: Name -> Either [PersonInvalid] Name
nameOkay name = case name /= "" of
  True -> Right name
  False -> Left [NameEmpty]


mkPerson'' :: Name -> Age -> ValidatePerson Person
mkPerson'' name age = mkPerson''' (nameOkay name) (ageOkay age)

mkPerson''' :: ValidatePerson Name
            -> ValidatePerson Age
            -> ValidatePerson Person
mkPerson''' (Right nameOk) (Right ageOk) = Right (Person nameOk ageOk)
mkPerson''' (Left badName) (Left badAge) = Left (badName ++ badAge)
mkPerson''' (Left badName) _ = Left badName
mkPerson''' _ (Left badAge) = Left badAge

-- One more time about HKT and type constants:
-- Int is a type constant, it does not accept any type
-- Some general idea is that type constant is fully applied type. Type constructor is not
-- fully applied type, who have (->) in their kind (not sure I'm using terms correctly)

-- Let's take a look at this type:
data ThisIsTypeConstructor a = Blah | Blah' | Blah'' a
-- this is a Type Constructor because it accepts a as a parameter, which is used by
-- Blah'' Data Constructor

-- One more thing here - there are lifted(*) and unlifted(#) types
-- * are mainstream types
-- # are raw pointers and native types

-- Newtypes are very special in this case, they are unlifted, but in the same time, they are *.

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
