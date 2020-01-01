module Module42 where

import Data.List.Split (splitOn)
import Data.Char
import Data.List
import Data.Tuple

data Bit = Zero | One deriving Show
data Sign = Minus | Plus deriving Show
data Z = Z Sign [Bit] deriving Show

example :: Z
example = Z Minus [One, One, One] -- right one is higher bit so 2 is [Zero, One] not [One, Zero]

add :: Z -> Z -> Z
add a b = toBits $ (fromBits a) + (fromBits b)

mul :: Z -> Z -> Z
mul a b = toBits $ (fromBits a) * (fromBits b)

fromBits :: Z -> Integer
fromBits (Z Plus bitList) = fst $ fromBits' bitList
fromBits (Z Minus bitList) = negate $ fst $ fromBits' bitList
fromBits' = foldl (\(total, pow) x -> (total + (bitToInt x) * 2^pow, pow+1)) (0, 0)

-- unfold :: (a -> (b, Maybe a)) -> a -> NonEmpty b
toBits :: Integer -> Z
toBits n | n == 0 = Z Plus []
         | n > 0 = Z Plus (bitVec n)
         | otherwise = Z Minus (bitVec (-n))
  where
     bitVec n = map intToBit $ unfoldr (\n -> if n == 0 then Nothing else Just $ swap $ divMod n 2) n

bitToInt Zero = 0
bitToInt One = 1

intToBit 0 = Zero
intToBit 1 = One



data Coord a = Coord a a

distance :: Coord Double -> Coord Double -> Double
distance (Coord x1 y1) (Coord x2 y2) = sqrt ((x2 - x1)^2 + (y2 - y1)^2)

manhDistance :: Coord Int -> Coord Int -> Int
manhDistance (Coord x1 y1) (Coord x2 y2) = (abs (x1 - x2)) + (abs (y1 - y2))


findDigit :: [Char] -> Maybe Char
findDigit = f . filter isDigit
  where
    f [] = Nothing
    f xs = Just $ head xs

-- "firstName = John\nlastName = Connor\nage = 30"
-- "firstName = John Smith\nlastName = Connor\nage = 30\nasde=as11"
-- "firstName=Barbarian\nlastName=Conn On\nage=30"

parseInput :: String -> [String]
parseInput = splitOn "\n"

parseOnePair :: String -> Either Error (String, String)
parseOnePair xs =
  let
    parsed = splitOn "=" xs
    -- dropWhileEnd might not work on older Haskell
    -- trim = dropWhileEnd isSpace . dropWhile isSpace
    trim = lstrip . rstrip
    lstrip = dropWhile (`elem` " \tn")
    rstrip = reverse . lstrip . reverse
  in
    if length parsed == 2
    then Right ((trim . head) parsed, (trim . head . tail) parsed)
    else Left ParsingError -- где-то невалидная пара

parsePairs :: [String] -> Either Error [(String, String)]
parsePairs xs =
  let
    mapped = map parseOnePair xs
  in
    if length (filter isLeft mapped) > 0
    then Left ParsingError
    else Right $ map (\(Right x) -> x) mapped
  where
    isLeft (Left _) = True
    isLeft (Right _) = False

filterField :: [(String, String)] -> Either Error [(String, String)]
filterField xs =
  let
    filtered = filter f xs
  in
    if length filtered == 3 then Right filtered else Left IncompleteDataError
  where f (name, value) = name == "firstName" || name == "lastName" || name == "age"

validateAge :: String -> Either Error Int
validateAge value = if any (not . isDigit) value then Left $ IncorrectDataError value else Right (read value)

data Error = ParsingError | IncompleteDataError | IncorrectDataError String deriving Show

data Person = Person { firstName :: String, lastName :: String, age :: Int } deriving Show

parsePerson :: String -> Either Error Person
parsePerson input = case parsePairs $ parseInput input of
                     (Right pairs) ->
                       case filterField pairs of
                          (Right pairs) ->
                            case validateAge (age pairs) of
                              (Right age) -> Right $ Person (firstName pairs) (lastName pairs) age
                              (Left error) -> Left error
                          (Left error) -> Left error
                     (Left error) -> Left error
  where
    firstName = snd . head. filter (\(field,_) -> field == "firstName")
    lastName = snd . head . filter (\(field,_) -> field == "lastName")
    age = snd . head . filter (\(field,_) -> field == "age")


