module DataBase where

import Data.Time

data DatabaseItem = DbString String
                  | DbNumber Integer
                  | DbDate UTCTime
                  deriving (Eq, Ord, Show)

theDatabase :: [DatabaseItem]
theDatabase =
  [ DbDate (UTCTime
             (fromGregorian 1911 5 1)
             (secondsToDiffTime 34123)
           )
  , DbNumber 9001
  , DbString "Hello, world!"
  , DbDate (UTCTime
             (fromGregorian 1921 5 1)
             (secondsToDiffTime 34123)
           )
  ]

-- Stub data
str1 = DbString "Roberto"
str2 = DbString "Alberto"
num1 = DbNumber 10
num2 = DbNumber 15

-- Write a function that filters for DbDate values and returns a list
-- of the UTCTime values inside them.
filterDbDate :: [DatabaseItem] -> [UTCTime]
filterDbDate xs = map mapper $ filter go xs
  where go val = case val of
                   (DbDate date) -> True
                   _             -> False
        mapper (DbDate time) = time

filterDbDate' :: [DatabaseItem] -> [UTCTime]
filterDbDate' =
  foldr maybeCons []
    where maybeCons (DbDate date) b = date : b
          maybeCons _             b = b


-- Write a function that filters for DbNumber values and returns a list
-- of the Integer values inside them.

filterDbNumber :: [DatabaseItem] -> [Integer]
filterDbNumber =
  foldr collectNumbers []
    where collectNumbers a b =
            case a of
             (DbNumber int) -> int : b
             _ -> b

-- Write a function that gets the most recent date.
myMaximumBy :: (a -> a -> Ordering) -> [a] -> a
myMaximumBy _ (x:[]) = x
myMaximumBy f (x:xs) =
  let max = myMaximumBy f xs
  in case f max x of
       GT -> max
       LT -> x
       EQ -> x

mostRecent :: [DatabaseItem] -> UTCTime
mostRecent = myMaximumBy (compare) .  filterDbDate

-- Write a function that sums all of the DbNumber values.

sumDb :: [DatabaseItem] -> Integer
sumDb = sum . filterDbNumber

-- Write a function that gets the average of the DbNumber values.
-- You'll probably need to use fromIntegral
-- to get from Integer to Double.
avgDb :: [DatabaseItem] -> Double
avgDb xs = (sum $ map fromIntegral $ filteredNumbers) / (fromIntegral $ length $ filteredNumbers)
  where filteredNumbers = filterDbNumber xs
