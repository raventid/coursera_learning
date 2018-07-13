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

data Organ = Heart | Brain | Kidney | Spleen deriving (Show, Eq, Ord)

-- The idea is to put organs into labeled lockers (let's create this labels)
ids :: [Int]
ids = [2,7,13,14,21,24]

organs :: [Organ]
organs = [Heart, Heart, Brain, Spleen, Spleen, Kidney]

-- We'll use Map.fromList to create the Map!
-- λ> Map.fromList
-- Map.fromList :: Ord k => [(k, a)] -> Map.Map k a
-- keys sould be Ord-ered because of the lookup way.

pairs = [(2, Heart), (7, Heart), (13, Brain)]

organPairs :: [(Int, Organ)]
organPairs = zip ids organs

organCatalog :: Map.Map Int Organ
organCatalog = Map.fromList organPairs

-- My organ inventory. Organ is key.
-- Value - is list of lockers. (it's better to use Set I guess)
organInventory :: Map.Map Organ [Int]
organInventory = Map.fromList [(Heart, [1,2,3])]

possibleDrawers :: [Int]
possibleDrawers = [1..50]

getDrawerContents :: [Int] -> Map.Map Int Organ -> [Maybe Organ]
getDrawerContents ids catalog = map getContents ids
  where getContents = \id -> Map.lookup id catalog

availableOrgans :: [Maybe Organ]
availableOrgans = getDrawerContents possibleDrawers organCatalog

countOrgan :: Organ -> [Maybe Organ] -> Int
countOrgan organ available = length (filter
                                    (\x -> x == Just organ)
                                    available)

-- Let's create a beautifull printing for
-- Maybe organs.

isSomething :: Maybe Organ -> Bool
isSomething Nothing = False
isSomething (Just _) = True

justTheOrgans :: [Maybe Organ]
justTheOrgans = filter isSomething availableOrgans

showOrgan :: Maybe Organ -> String
showOrgan (Just organ) = show organ
showOrgan Nothing = ""

organList :: [String]
organList = map showOrgan justTheOrgans
