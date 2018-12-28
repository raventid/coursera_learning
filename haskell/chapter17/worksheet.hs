module Chapter17 where

import Control.Applicative
import Data.Monoid
import Data.List (elemIndex)
import Control.Applicative (liftA3)

-- Idea is quite straightforward
-- We have to unify high level types and apply function to arguments
-- This is not real code or any programming language.
-- f mappend f -> f
-- (a -> b) $ a -> b

-- f (a -> b) -> f a -> f b
-- Just (*2) <*> Just 2

f x =
  lookup x [ (3, "hello")
           , (4, "julie")
           , (5, "kbai")]

g y =
  lookup y [ (7, "sup?")
           , (8, "chris")
           , (9, "aloha")]

h z =
  lookup z [ (2,3)
           , (5,6)
           , (7,8)]

m x =
  lookup x [ (4,10)
           , (8,13)
           , (1,9001)]


-- (++) <$> f 3 <*> g 7
-- liftA2 (++) (f 3) (g 7)

-- Exercises: Lookups

-- 1.
added :: Maybe Integer
added = (+3) <$> (lookup 3 $ zip [1, 2, 3] [4, 5, 6])

-- 2.
y :: Maybe Integer
y = lookup 3 $ zip [1,2,3] [4,5,6]

z :: Maybe Integer
z = lookup 2 $ zip [1,2,3] [4,5,6]

tupled :: Maybe (Integer, Integer)
tupled = (,) <$> y <*> z

-- 3.
x' :: Maybe Int
x' = elemIndex 3 [1,2,3,4,5]

y' :: Maybe Int
y' = elemIndex 4 [1,2,3,4,5]

max' :: Int -> Int -> Int
max' = max

maxed :: Maybe Int
maxed = max' <$> x' <*> y'

-- 4.
xs = [1,2,3]
ys = [4,5,6]
xs' = [9,9,9]

x'' :: Maybe Integer
x'' = lookup 3 $ zip xs ys

y'' :: Maybe Integer
y'' = lookup 2 $ zip xs ys

summed :: Maybe Integer
summed = fmap sum $ (,) <$> x'' <*> y''

-- Exercise: Identity Instances
newtype Identity a = Identity a deriving (Eq, Ord, Show)

instance Functor Identity where
  fmap f (Identity a) = Identity (f a)

instance Applicative Identity where
  pure a = Identity a
  (<*>) (Identity f) (Identity x) = Identity (f x)

-- Exercise: Constant Instance
newtype Constant a b =
  Constant { getConstant :: a } deriving (Eq, Ord, Show)

instance Functor (Constant a) where
  fmap _ (Constant a) = Constant a

instance Monoid a => Applicative (Constant a) where
  pure a = Constant { getConstant = mempty }
  (<*>) (Constant a) (Constant a') = Constant { getConstant = (a <> a') }

-- Validations. Maybe applicative.
validateLength :: Int -> String -> Maybe String
validateLength maxLen s =
  if (length s) > maxLen
  then Nothing
  else Just s

newtype Name =
   Name String deriving (Eq, Show)

newtype Address =
  Address String deriving (Eq, Show)

newtype Dog =
  Dog String deriving (Eq, Show)

mkName :: String -> Maybe Name
mkName s = fmap Name $ validateLength 25 s

mkAddress :: String -> Maybe Address
mkAddress s = fmap Address $ validateLength 100 s

mkDog :: String -> Maybe Dog
mkDog s = fmap Dog $ validateLength 5 s

data Person =
  Person Name Address Dog
  deriving (Eq, Show)

mkPerson :: String -> String -> String -> Maybe Person
mkPerson n a d =
  case mkName n of
    Nothing -> Nothing
    Just n' ->
      case mkAddress a of
        Nothing -> Nothing
        Just a' ->
          case mkDog d of
            Nothing -> Nothing
            Just d' ->
              Just $ Person n' a' d'

mkPerson' :: String -> String -> String -> Maybe Person
mkPerson' n a d = Person <$> mkName n <*> mkAddress a <*> mkDog d


-- Just a reminder
-- instance Applicative Maybe where
--   pure = Just

--   Nothing <*> _ = Nothing
--   _ <*> Nothing = Nothing
--   Justf <*> Just a = Just (f a)

-- Exercise: Fixer Upper

fu1 = const <$> Just "Hello" <*> pure "world"
fu2 = (,,,) <$> Just 90 <*> Just 10 <*> Just "Tierness" <*> pure [1, 2, 3]
-- ($ 2) applies second argument and waits for function to apply
trick = pure ($ 2) <*> Just (+ 2)


--  List Applicative Exercise
data List a =
    Nil
  | Cons a (List a)
  deriving (Eq, Show)

instance Functor List where
  fmap f Nil = Nil
  fmap f (Cons x xs) = Cons (f x) (fmap f xs)

instance Applicative List where
  pure a = Cons a Nil

  _ <*> Nil = Nil
  Nil <*> _ = Nil
  (Cons f fs) <*> xs = append (f <$> xs) (fs <*> xs)

-- let f = Cons (+1) (Cons (*2) Nil)
-- let v = Cons 1 (Cons 2 Nil)
-- f <*> v
-- (Cons (+1) (Cons (*2) Nil)) <*> (Cons 1 (Cons 2 Nil)) -- one liner
-- Cons 2 (Cons 3 (Cons 2 (Cons 4 Nil))) -- It should be this, as an answer.

append :: List a -> List a -> List a
append Nil ys = ys
append (Cons x xs) ys = Cons x $ xs `append` ys


-- Exercise from the end of chapter - Combinations with listA3
stops :: String
stops = "pbtdkg"

vowels :: String
vowels = "aeiou"

combos :: [a] -> [b] -> [c] -> [(a, b, c)]
combos = liftA3 (,,)
