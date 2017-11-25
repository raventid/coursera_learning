module Chapter13 where

import Control.Monad
import System.Exit (exitSuccess)

palindrome :: IO ()
palindrome = forever $ do
    putStr "Enter your word: "
    line1 <- getLine
    case (line1 == reverse line1) of
      True -> putStrLn "It's a palindrome!"
      False -> do
                putStrLn "Nope!"
                exitSuccess

type Name = String
type Age = Integer

data Person = Person Name Age deriving Show

data PersonInvalid = NameEmpty
  | AgeTooLow
  | PersonInvalidUnknown String deriving (Eq, Show)

mkPerson :: Name
         -> Age
         -> Either PersonInvalid Person
mkPerson name age
  | name /= "" && age > 0 = Right $ Person name age
  | name == "" = Left NameEmpty
  | not (age > 0) = Left AgeTooLow
  | otherwise = Left $ PersonInvalidUnknown $
    "Name was: " ++ show name ++
    "Age was: " ++ show age

gimmePerson :: IO ()
gimmePerson = do
  putStr "Please, enter your name:  "
  name <- getLine
  putStr "And your age too, please: "
  age <- getLine
  case mkPerson name (read age :: Integer) of
    Right p -> putStrLn $ "Yay! Successfully got a person: " ++ show p
    Left NameEmpty -> putStrLn "Empty name. It's impossible ;)"
    Left AgeTooLow -> putStrLn "This guy is too young. Toooooo young to be truth."
    Left (PersonInvalidUnknown err) -> putStrLn $ "Unknown invalid: " ++ err
