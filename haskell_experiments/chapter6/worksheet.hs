module Typeclasses where

import Data.List

data Trivial = Trivial'

instance Eq Trivial where
  Trivial' == Trivial' = True


data DayOfWeek =
  Mon | Tue | Weds | Thu | Fri | Sat | Sun

data Date =
  Date DayOfWeek Int

instance Eq DayOfWeek where
  (==) Mon Mon = True
  (==) Tue Tue = True
  (==) Weds Weds = True
  (==) Thu Thu = True
  (==) Fri Fri = True
  (==) Sat Sat = True
  (==) Sun Sun = True
  (==) _   _   = False

instance Eq Date where
  (==) (Date weekday dayOfMonth)
       (Date weekday' dayOfMonth') =
    weekday == weekday' && dayOfMonth == dayOfMonth'

data Identity a = Identity a

-- We should use type contraint syntax, or GHC would not know anything about 'a'
instance Eq a => Eq (Identity a) where
  (==) (Identity v)(Identity v') = v == v'


-- This is some part of homework
--
i :: Num a => a
i = 1

f :: RealFrac a => a
f = 1.0

freud :: Ord a => a -> a
freud x = x

freud' :: Int -> Int
freud' x = x


jung :: [Int] -> Int
jung xs = head (sort xs)

young :: Ord a => [a] -> a
young xs = head (sort xs)

mySort :: [Char] -> [Char]
mySort = sort

-- signifier :: Ord a => [a] -> a
-- signifier xs = head (mySort xs)

chk :: Eq b => (a -> b) -> a -> b -> Bool
chk f a b = f a == b

arith :: Num b => (a -> b) -> Integer -> a -> b
arith f i a = f a -- + (fromInteger i) -- in fact it's not necessary

type Subject = String
type Verb = String
type Object = String

data Sentence = Sentence Subject Verb Object deriving (Eq, Show)

s = Sentence "dog" "cat"
