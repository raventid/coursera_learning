{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleInstances #-}

module Worsheet where

import Data.Char

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

data Fiction = Fiction deriving Show
data Nonfiction = Nonfiction deriving Show

-- Sum type
data BookType = FictionBook Fiction
              | NonfictionBook Nonfiction
              deriving Show

type AuthorName = String

-- Tuple is a classical represantation of a product type
data Author = Author (AuthorName, BookType)

-- Classical example of recursive structure
type Number = Int
type Add = (Expr, Expr)
type Minus = Expr
type Mult = (Expr, Expr)
type Divide = (Expr, Expr)

-- type Expr =
--   Either Number
--    (Either Add
--      (Either Minus
--       (Either Mult Divide)))

data Expr =
  Number Int
  | Add Expr Expr
  | Minus Expr
  | Mult Expr Expr
  | Divide Expr Expr

-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- Sum and product types. Subtopic: Constructing values.
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

-- trivialValue :: GuessWhat
-- trivialValue = Chickenbutt

data Id a =
  MkId a deriving (Eq, Show)

idInt :: Id Integer
idInt = MkId 10

idIdentity :: Id (a -> a)
idIdentity = MkId $ \x -> x

data Sum a b =
  First a
  | Second b
  deriving (Eq, Show)

data Twitter =
  Twitter deriving (Eq, Show)

data AskFm =
  AskFm deriving (Eq, Show)

-- AAAAAAAA, Haskell is awesome, this is unreal!!!
socialNetwork :: Sum Twitter AskFm
socialNetwork = First Twitter

-- It does not work because Haskell is awesome, I'm crying it load right now!!!!
-- You might not believe me, but I'm really crying right now, this is so awesome!!!!
-- socialTest :: Sum Twitter AskFm
-- socialTest = Second Twitter
-- This code works like this

--  -Dear Haskell I have a type Sum which has `a` as Twitter and `b` as AskFm!
--  -Sure, my friend, then I let you construct First Twitter and Second AskFm.
--  -Thank you, mister Haskell!

-- Wow, but Haskell could not save my ass in this case:
type Gogo = String
type RustRust = String

askFm :: Sum Gogo RustRust
askFm = Second "Gogo"

data OperatingSystem =
       GnuPlusLinux
       | OpenBSDPlusNevermindJustBSDStill
       | Mac
       | Windows
       deriving (Eq, Show)

data ProgrammingLanguage =
       Haskell
       | Agda
       | Idris
       | PureScript deriving (Eq, Show)

data Programmer =
       Programmer { os :: OperatingSystem
                    , lang :: ProgrammingLanguage } deriving (Eq, Show)

allOperatingSystems :: [OperatingSystem]
allOperatingSystems = [ GnuPlusLinux
                        , OpenBSDPlusNevermindJustBSDStill
                        , Mac
                        , Windows
                      ]

allLanguages :: [ProgrammingLanguage]
allLanguages = [ Haskell
                 , Agda
                 , Idris
                 , PureScript
               ]

-- Wow, once again Haskell is wow!!! I can use types as first class things!!!
-- I wanna work with Haskell full time!!!
allProgrammers :: [Programmer]
allProgrammers = [Programmer a b | a <- allOperatingSystems, b <- allLanguages]

-- builder pattern? Look at this ->
data ThereYet =
  There Integer Float String Bool
  deriving (Eq, Show)

nope :: Float -> String -> Bool -> ThereYet
nope = There 10

notYet :: String -> Bool -> ThereYet
notYet = nope 25.5

notQuite :: Bool -> ThereYet
notQuite = notYet "woohoo"

yussss :: ThereYet
yussss = notQuite True


data Quantum =
    Yes
    |No
    | Both
    deriving (Eq, Show)

-- `->` function is exponential
-- Let's write all possible values of this:
-- Quantum has cardinality 3 and Bool -2. So the result is 2^3 possible functions.
convert1 :: Quantum -> Bool
convert1 Yes = True
convert1 No = True
convert1 Both = True

convert2 :: Quantum -> Bool
convert2 Yes = True
convert2 No = True
convert2 Both = False

convert3 :: Quantum -> Bool
convert3 Yes = True
convert3 No = False
convert3 Both = True

convert4 :: Quantum -> Bool
convert4 Yes = True
convert4 No = False
convert4 Both = False

convert5 :: Quantum -> Bool
convert5 Yes = False
convert5 No = True
convert5 Both = True

convert6 :: Quantum -> Bool
convert6 Yes = False
convert6 No = True
convert6 Both = False

convert7 :: Quantum -> Bool
convert7 Yes = False
convert7 No = False
convert7 Both = True

convert8 :: Quantum -> Bool
convert8 Yes = False
convert8 No = False
convert8 Both = False

-- Polymorphic product type.
data Silly a b c d = MkSilly a b c d deriving Show



-- **********************************************************************
-- Binary tree.
-- **********************************************************************

data BinaryTree a =
  Leaf
  | Node (BinaryTree a) a (BinaryTree a)
  deriving (Eq, Ord, Show)

insert' :: Ord a => a -> BinaryTree a -> BinaryTree a
insert' b Leaf = Node Leaf b Leaf
insert' b (Node left a right)
  | b == a = Node left a right
  | b < a = Node (insert' b left) a right
  | b > a = Node left a (insert' b right)

mapTree :: (a -> b) -> BinaryTree a -> BinaryTree b
mapTree _ Leaf = Leaf
mapTree f (Node left a right) = Node (mapTree f left) (f a) (mapTree f right)

-- Tree for example
tree = Node (Node Leaf 10 Leaf) 1 (Node Leaf 11 Leaf)

result' = mapTree (\x -> x + 100) tree

-- **********************************************************************
-- As-patterns.
-- **********************************************************************
isSubsequenceOf :: (Eq a) => [a] -> [a] -> Bool
isSubsequenceOf [] [] = True
isSubsequenceOf [] _ = True
isSubsequenceOf _ [] = False
isSubsequenceOf (x:xs) ys = x `elem` ys && isSubsequenceOf xs ys

-- We split string twice it's not the best way to code this once again.
capitalizeWords :: String -> [(String, String)]
capitalizeWords str = zip (splitBy ' ' str) $ map upperCase $ splitBy ' ' str

upperCase :: String -> String
upperCase [] = []
upperCase (x:xs) = toUpper x:xs

splitBy :: (Foldable b, Eq a) => a -> b a -> [[a]]
splitBy delimiter = foldr f [[]]
            where f c l@(x:xs) | c == delimiter = []:l
                               | otherwise = (c:x):xs


-- Just my function to present number as 1_123_123 and not 1123123
-- Does not work yet. And should be pretty!
prettifyNumber :: String -> String
prettifyNumber xs = reverse $ foldl f "" $ reverse xs
              where f s a = if ((length s) `mod` 3) == 0 then ('_' : a : s) else (a : s)

-- It's an internal function for prettifyNumber - make chunks of appropriate size from list
chunkOf :: Int -> String -> [String]
chunkOf xs = undefined
