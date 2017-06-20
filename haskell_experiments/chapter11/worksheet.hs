{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleInstances #-}

module Worsheet where

-- 'sum type' is a type where we might use more than one constructor
-- 'product types' definition is left for later
--
--
-- Type constructors are resolved at compile time. Data constructors is runtime object generation.
-- 'True' and 'False' in Bool are data constructors.

-- Type constructors - compile time
-- Data constructors - run     time
data Doggies a =
        Husky a
      | Mastiff a
      deriving(Eq, Show)

data Price =  -- Price is type contructor
      Price Integer deriving(Eq, Show) -- Price is data constructor; Integer is price argument

data Size =
     Size Integer deriving(Eq, Show)

data Manufacturer =
       Mini
     | Mazda
     | Tata
     deriving(Eq, Show)

data Airline =
       PapuAir
     | CatapultsR'Us
     | TakeYourChances
     deriving(Eq, Show)

data Vehicle = Car Manufacturer Price
             | Plane Size Airline
             deriving(Eq, Show)

myCar = Car Mini (Price 14000)
urCar = Car Mazda (Price 20000)
clownCar = Car Tata (Price 7000)
doge = Plane (Size 10) PapuAir

isCar :: Vehicle -> Bool
isCar x =
  case x of
   Car _ _  -> True
   _        -> False

isPlane :: Vehicle -> Bool
isPlane x =
  case x of
   Plane _ _ -> True
   _         -> False

areCars :: [Vehicle] -> [Bool]
areCars = foldr (\x acc -> isCar(x) : acc) []

getManu :: Vehicle -> Manufacturer
getManu x =
  case x of
    Car m _ -> m

class TooMany a where
  tooMany :: a -> Bool

instance TooMany Int where
  tooMany n = n > 42

instance TooMany (Int, String) where -- I've used FlexibleInstances pragma to write this
  tooMany (n, m) = n > 10

instance TooMany (Int, Int) where
  tooMany (n, m) = (n+m) > 42

-- Here I'm trying to impelent TooMany for type synonim.
type MyInt = Int


-- If I try to compile this code, then I get `Duplicate instance declarations`
-- instance TooMany MyInt where
--  tooMany n = n > 38

-- This requires Ord, so comment this for now
-- TODO: in this exercise I lied and added Ord to a
instance (Num a, TooMany a, Ord a) => TooMany (a, a) where
   tooMany (n, m) = (n + m) > 10

--with generalized pragma I can use this
newtype Goats = Goats Int deriving (Eq, Show, TooMany)

-- Already derived TooMany with pragma. This is duplicated definition.
-- instance TooMany Goats where
--   tooMany (Goats n) = n > 43 -- with generalized pragma I don't need this
