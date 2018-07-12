module ParametrizedTypes where

import qualified Data.Map as Map

data Triple a = Triple a a a deriving Show

first :: Triple a -> a
first (Triple x _ _) = x

second :: Triple a -> a
second (Triple _ x _) = x

third :: Triple a -> a
third (Triple _ _ x) = x

transform :: (a -> a) -> Triple a -> Triple a
transform f (Triple x y z) = Triple (f x) (f y) (f z)

toList :: Triple a -> [a]
toList (Triple x y z) = [x, y, z]


type Point3D = Triple Double

aPoint :: Point3D
aPoint = Triple 0.1 53.2 12.3

cool_stuff_you_can_do_with_transform = transform (* 3) aPoint


-- Lists

-- λ> :info []
-- data [] a = [] | a : [a] 	-- Defined in ‘GHC.Types’

-- λ> :type []
-- [] :: [t]

-- λ> :kind []
-- [] :: * -> *

-- Kinds are deprecated now (now it's Types). From GHC 8.6 (Should check, not sure).

data List a = Empty | Cons a (List a) deriving Show

data Organ = Heart | Brain | Kidney | Spleen deriving (Show, Eq)

-- The idea is to put organs into labeled lockers (let's create this labels)
ids :: [Int]
ids = [2,7,13,14,21,24]

organs :: [Organ]
organs = [Heart, Heart, Brain, Spleen, Spleen, Kidney]
