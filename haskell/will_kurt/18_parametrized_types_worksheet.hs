module ParametrizedTypes where

import Data.List (intercalate)
import qualified Data.Map as Map
import Data.Maybe (isNothing)

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

-- mapL (+15) (Cons 10 (Cons 5 Empty))

mapL :: (a -> b) -> List a -> List b
mapL _ Empty = Empty
mapL f (Cons x xs) = Cons (f x) (mapL f xs)


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

cleanList :: String
cleanList = intercalate ", " organList



-- Next task:
-- You’ll be given a drawer ID.
-- You need to retrieve an item from the drawer.
-- Then you’ll put the organ in the appropriate container (a vat, a cooler, or a bag).
-- Finally, you’ll put the container in the correct location.
-- Here are the rules for containers and locations:

-- For containers:
--  Brains go in a vat.
--  Hearts go in a cooler.
--  Spleens and kidneys go in a bag.

-- For locations:
--  Vats and coolers go to the lab.
--  Bags go to the kitchen.

data Container = Vat Organ | Cooler Organ | Bag Organ

instance Show Container where
  show (Vat organ) = show organ ++ " in a vat"
  show (Cooler organ) = show organ ++ " in a cooler"
  show (Bag organ) = show organ ++ " in a bag"

data Location = Lab | Kitchen | Bathroom deriving Show

organToContainer :: Organ -> Container
organToContainer Brain = Vat Brain
organToContainer Heart = Cooler Heart
organToContainer organ = Bag organ

placeInLocation :: Container -> (Location, Container)
placeInLocation (Vat a) = (Lab, Vat a)
placeInLocation (Cooler a) = (Lab, Cooler a)
placeInLocation (Bag a) = (Kitchen, Bag a)

process :: Organ -> (Location, Container)
process organ = placeInLocation (organToContainer organ)

report :: (Location, Container) -> String
report (location, container) = show container ++ " in the " ++ show location

proccessRequest :: Int -> Map.Map Int Organ -> String
proccessRequest id catalog = processAndReport organ
  where organ = Map.lookup id catalog

-- Right now your processRequest function handles
-- reporting when there’s an error.
-- Ideally, you’d like the report function to handle this.
-- But to do that given your knowledge so far,
-- you’d have to rewrite process to accept a Maybe.
-- You’d be in a worse situation, because you’d no
-- longer have the advantage of writing a processing function
-- that you can guarantee doesn’t have to worry about a missing value.
processAndReport :: (Maybe Organ) -> String
processAndReport (Just organ) = report (process organ)
processAndReport Nothing = "error, id not found"

-- q19.1
emptyDrawers :: Int
emptyDrawers = length $ filter isNothing $ availableOrgans
