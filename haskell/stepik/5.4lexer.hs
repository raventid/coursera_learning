module Lexer54 where

import Data.Char

data Token = Number Int | Plus | Minus | LeftBrace | RightBrace deriving (Eq, Show)

asToken :: String -> Maybe Token
asToken token | all isDigit token = Just $ Number (read token :: Int)
              | token == "+" = Just Plus
              | token == "-" = Just Minus
              | token == "(" = Just LeftBrace
              | token == ")" = Just RightBrace
              | otherwise = Nothing

tokenize :: String -> Maybe [Token]
tokenize input = extract . map asToken . words $ input

extract :: [Maybe Token] -> Maybe [Token]
extract [] = return []
extract xs = if any (\x -> x == Nothing) xs then Nothing else Just $ map (\(Just token) -> token) xs
