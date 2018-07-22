module Chapter18 where

import Control.Monad (join)
import Control.Applicative
import Data.Monoid ((<>))

-- Monad types and rules as a nice reminder for me.
-- (>>) :: Monad m => m a -> m b -> m b -- the same as applicative `*>`
-- (>>=) :: Monad m => m a -> (a -> m b) -> m b
-- return :: a -> m a -- the same as applicative's `pure`

-- This `bind` function is just a (>>=) flipped.
bind :: Monad m => (a -> m b) -> m a -> m b
bind f xs = join $ fmap f xs

twoBinds :: IO ()
twoBinds = do
  putStrLn "name pls:"
  name <- getLine
  putStrLn "age pls:"
  age <- getLine
  putStrLn ("y helo thar: " ++ name ++ " whois: " ++ age ++ " years old.")

twoBinds' :: IO ()
twoBinds' =
  putStrLn "name pls:" >>
  getLine >>=
  \name -> putStrLn "age pls:" >>
  getLine >>=
  \age -> putStrLn ("y helo thar: " ++ name ++ " whois: " ++ age ++ " years old.")


twiceWhenEven :: [Integer] -> [Integer]
twiceWhenEven xs = do
  x <- xs
  if even x
    then [x*x, x*x]
    else [x]

-- It looks like mapping in imperative languages, but it is not.
-- My past experiance make it look like iteration, but it's a more abstract concept we see here.
-- fmap for list works like map, but for Maybe, Either? No, it does not.
-- So, yeah, it's better to avoid thinking about fmap in terms of iteration.
twiceWhenEven' :: [Integer] -> [Integer]
twiceWhenEven' xs = xs >>= \x -> if even x then [x*x, x*x] else [x]

data Cow = Cow {
    name :: String
  , age :: Int
  , weight :: Int
} deriving (Eq, Show)

noEmpty :: String -> Maybe String
noEmpty "" = Nothing
noEmpty s = Just s

noNegative :: Int -> Maybe Int
noNegative n | n >= 0 = Just n
             | otherwise = Nothing

weightCheck :: Cow -> Maybe Cow
weightCheck c =
  let w = weight c
      n = name c
  in if n == "Bess" && w > 499
     then Nothing
     else Just c

mkSphericalCow :: String -> Int -> Int -> Maybe Cow
mkSphericalCow name' age' weight' =
  case noEmpty name' of
    Nothing -> Nothing
    Just nammy ->
      case noNegative age' of
        Nothing -> Nothing
        Just agey ->
          case noNegative weight' of
            Nothing -> Nothing
            Just weighty -> weightCheck (Cow nammy agey weighty)

mkSphericalCow' :: String -> Int -> Int -> Maybe Cow
mkSphericalCow' name' age' weight' = do
  nammy <- noEmpty name'
  agey <- noNegative age'
  weighty <- noNegative weight'
  weightCheck (Cow nammy agey weighty)

mkSphericalCow'' :: String -> Int -> Int -> Maybe Cow
mkSphericalCow'' name' age' weight' =
  noEmpty name' >>=
  \nammy ->
    noNegative age' >>=
    \agey ->
      noNegative weight' >>=
      \weighty ->
        weightCheck (Cow nammy agey weighty)

f' :: Integer -> Maybe Integer
f' 0 = Nothing
f' n = Just n

g' :: Integer -> Maybe Integer
g' i = if even i then Just (i + 1) else Nothing

h' :: Integer -> Maybe String
h' i = Just ("10191" ++ show i)

doSomething' n = do
  a <- f' n
  b <- g' a
  c <- h' b
  pure (a, b, c)

-- rewrite without do notation
doSomething'' n =
  f' n >>= \a -> g' a >>= \b -> h' b >>= \c -> pure (a, b, c)
-- m a -> (a -> m b) --> m b -> (b -> m c) --> m c -> (c -> m d) -> m d
-- -> has the lowest priority, so:
-- f' n >>= (\a -> g' a >>= (\b -> h' b >>= (\c -> pure (a, b, c))))
-- execution order is like that one.

-- doSomething''' = \x -> x + 1 \y -> \z -> x + y + z

-- try to rewrite with applicative (which is impossible, but we should try)
-- doSomething''' n =
--  f' n <*> g' a <*> h' b


-- Either monad

-- years ago
type Founded = Int

-- number of programmers
type Coders = Int

data SoftwareShop = Shop {
    founded :: Founded
  , programmers :: Coders
} deriving (Eq, Show)

data FoundedError =
    NegativeYears Founded
  | TooManyYears Founded
  | NegativeCoders Coders
  | TooManyCoders Coders
  | TooManyCodersForYears Founded Coders
  deriving (Eq, Show)

validateFounded :: Int -> Either FoundedError Founded
validateFounded n | n < 0 = Left $ NegativeYears n
                  | n > 500 = Left $ TooManyYears n
                  | otherwise = Right n

-- Tho, many programmers *are* negative.
validateCoders :: Int -> Either FoundedError Coders
validateCoders n | n < 0 = Left $ NegativeCoders n
                 | n > 5000 = Left $ TooManyCoders n
                 | otherwise = Right n

mkSoftware :: Int -> Int -> Either FoundedError SoftwareShop
mkSoftware years coders = do
  founded <- validateFounded years
  programmers <- validateCoders coders
  if programmers > div founded 10
    then Left $ TooManyCodersForYears founded programmers
    else Right $ Shop founded programmers

-- We have to unpack Either values here to use them.
-- mkSoftware' :: Int -> Int -> Either FoundedError SoftwareShop
-- mkSoftware' years coders = if programmers > div founded 10
--                            then Left $ TooManyCodersForYears founded programmers
--                            else Right $ Shop founded programmers
--                            where programmers = validateCoders coders
--                                  founded = validateFouned years

-- Exercise: Either monad
data Sum a b =
    First a
  | Second b
  deriving (Eq, Show)

instance Functor (Sum a) where
  fmap _ (First a) = First a
  fmap f (Second b) = Second (f b)

-- In Haskell std we return `First a` if we have `First` anywhere, which is correct in
-- my opinion. But in previous exervices I used Monoid to merge the same heads, which is wrong?
-- But my checkers spec passed, so looks like it worked correclty in both ways...
-- TODO: Find out the truth.
instance Applicative (Sum a) where
  pure = Second

  (<*>) (First a)  (First a') = First a -- I used to write (a <> a'), added todo.
  (<*>) _          (First a)  = First a
  (<*>) (Second f) (Second x) = Second (f x)

instance Monad (Sum a) where
  return = pure

  (>>=) (First a) _ = First a
  (>>=) (Second b) f = f b


-- Composition based on Monads
-- It happens that monads composing extremly well!
mcomp :: Monad m => (b -> m c) -> (a -> m b) -> a -> m c
mcomp f g a = join (f <$> (g a))

mcomp'' :: Monad m => (b -> m c) -> (a -> m b) -> a -> m c
mcomp'' f g a = g a >>= f
