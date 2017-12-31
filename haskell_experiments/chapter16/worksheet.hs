module Chapter16 where

-- Fmap looks like plain map, when used with lists:
-- > fmap (\x -> x > 3) [1..6]
-- > [False,False,False,True,True,True]

-- Results are the same and behaviour looks quite similar:
-- > map (\x -> x > 3) [1..6]
-- > [False,False,False,True,True,True]

-- But if we will try to do something like that:
-- > map (+1) (Just 1)
-- Couldn't match expected type ‘[b]’ with actual type ‘Maybe Integer’
-- Oops, simple map cannot look inside our Data Constructor

-- But we can do this with fmap
-- > fmap (+1) (Just 1)
-- > Just 2


-- Add to repl to examine types:
-- :set -XTypeApplications

-- :type fmap @Maybe
-- fmap @Maybe :: (a -> b) -> Maybe a -> Maybe b

-- :type fmap @(Either _)
-- fmap @(Either _) :: (a -> b) -> Either t a -> Either t b


-- I didn't get that, so I've decided to write function with weird signature
-- TODO: Finish that crap:
newtype WeirdType a = WeirdType a

class WeirdTypeClass f where
 e :: b -> f (g a b c)

-- instance WeirdTypeClass(WeirdType) where
--   e b = WeirdType $ Just $ Right $ Just "Hello"

-- Functor realization misleadingly uses f in definition for Functor and f in realization
-- for function (a -> b)
-- fmap :: Functor f
--      => (a -> b) ->     f a      ->         f b
-- fmap       f          (Pls a)    =        Pls (f a)


-- Functor laws:

-- 1. The first law is the law of identity:
-- fmap id == id
-- So if you apply (fmap id) or (id) to `int` it should be the same `int` after.

-- 2. Law of composition
-- fmap (f . g) = fmap f . fmap g
-- If implementation of fmap does not do that - Functor is broken.


-- By combining (fmap . fmap) and more times we can go deeper into the structure.

-- Just fmap - deconstruct external list
-- (fmap . fmap) - goes inside Just, Nothing, Just
-- (fmap. fmap . fmap) - goes inside list, inside Just, Nothing, Just
-- [Just ['a', 'b'], Nothing, Just ['a', 'b']]

replaceWithP :: b -> Char
replaceWithP = const 'p'

lms :: [Maybe [Char]]
lms = [Just "Ave", Nothing, Just "woohoo"]

-- Just making the argument more specific
replaceWithP' :: [Maybe [Char]] -> Char
replaceWithP' = replaceWithP

liftedReplace :: Functor f => f a -> f Char
liftedReplace = fmap replaceWithP

liftedReplace' :: [Maybe [Char]] -> [Char]
liftedReplace' = liftedReplace


-- With double unwrapping with fmap!

-- Prelude> :t (fmap . fmap) replaceWithP
-- (fmap . fmap) replaceWithP :: (Functor f1, Functor f) => f (f1 a) -> f (f1 Char)
twiceLifted :: (Functor f1, Functor f) => f (f1 a) -> f (f1 Char)
twiceLifted = (fmap . fmap) replaceWithP

-- Making it more specific
twiceLifted' :: [Maybe [Char]] -> [Maybe Char]
twiceLifted' = twiceLifted
-- f ~ []
-- f1 ~ Maybe


-- With triple unwrapping with fmap!

-- Prelude> let rWP = replaceWithP
-- Prelude> :t (fmap . fmap . fmap) rWP
-- (fmap . fmap . fmap) replaceWithP
--   :: (Functor f2, Functor f1, Functor f)
-- => f (f1 (f2 a)) -> f (f1 (f2 Char))
thriceLifted :: (Functor f2, Functor f1, Functor f) => f (f1 (f2 a)) -> f (f1 (f2 Char))
thriceLifted = (fmap . fmap . fmap) replaceWithP

-- More specific or "concrete"
thriceLifted' :: [Maybe [Char]] -> [Maybe [Char]]
thriceLifted' = thriceLifted
-- f ~ []
-- f1 ~ Maybe
-- f2 ~ []

fromCharToInt' :: Char -> Int
fromCharToInt' c = 7

fromCharLifted' :: [Maybe [Char]] -> [Maybe [Int]]
fromCharLifted' = (fmap . fmap .fmap) fromCharToInt'

fromCharLifted'' :: [Maybe [Char]] -> [Maybe [Int]]
fromCharLifted'' = (fmap . fmap . fmap) (\c -> 7)

runExamplesForReplacement :: IO ()
runExamplesForReplacement = do
  putStr "replaceWithP' lms: "
  print (replaceWithP' lms)
  putStr "liftedReplace lms: "
  print (liftedReplace lms)
  putStr "liftedReplace' lms:  "
  print (liftedReplace' lms)
  putStr "twiceLifted lms:     "
  print (twiceLifted lms)
  putStr "twiceLifted' lms:    "
  print (twiceLifted' lms)
  putStr "thriceLifted lms:    "
  print (thriceLifted lms)
  putStr "thriceLifted' lms:   "
  print (thriceLifted' lms)


-- Exercises: Heavy lifting.
-- There is a small misunderstanding from my side. I don't feel why Functor is the same
-- as composition in case of  fmap (+2) (+3) == (+2) . (+3)
-- 1.
a = map (+1) $ read "[1]" :: [Int]
-- Prelude> a
-- [2]

-- 2.
b = (fmap . fmap) (++ "lol") (Just ["Hi,", "Hello"])
-- Prelude> b
-- Just ["Hi,lol","Hellolol"]

-- 3.
c = fmap (*2) (\x -> x - 2)
-- Prelude> c 1
-- -2

-- 4.
d = fmap ((return '1' ++) . show) (\x -> [x, 1..3])
-- Prelude> d 0
-- "1[0,1,2,3]"

-- 5. Cannot simply use `e` here, cause I declared it before, in Ruby I can(source of sorrow)
e' :: IO Integer
e' = let ioi = readIO "1" :: IO Integer
         changed = fmap (read . ("123"++) . show) ioi
    in fmap (*3) changed
-- Prelude> e
-- 3693


-- Let's use Functor for refactoring!
incIfJust :: Num a => Maybe a -> Maybe a
incIfJust (Just n) = Just $ n + 1
incIfJust Nothing = Nothing

showIfJust :: Show a => Maybe a -> Maybe String
showIfJust (Just s) = Just $ show s
showIfJust Nothing = Nothing


-- OK, there is a pattern here(a bit like in folds), so let's use fmap!
incMaybe'' :: Num a => Maybe a -> Maybe a
incMaybe'' = fmap (+1)

showMaybe'' :: Show a => Maybe a -> Maybe String
showMaybe'' = fmap show

-- But, wait! fmap works with functors! Yeah, we can make our functions more abstract
-- 'lifted' because they've been
-- lifted over some structure f
liftedInc :: (Functor f, Num b) => f b -> f b
liftedInc = fmap (+1)

liftedShow :: (Functor f, Show a) => f a -> f String
liftedShow = fmap show
-- Now we can use them with every Functor defined in the World!

-- Just a small exercise from chapter. Extremly simple.
data Possibly a =
    LolNope
  | Yeppers a
  deriving (Eq, Show)

instance Functor Possibly where
  fmap f (Yeppers x) = Yeppers (f x)
  fmap f LolNope = LolNope

-- The same stuff with Either
data Sum a b =
    First a
  | Second b
  deriving (Eq, Show)

instance Functor (Sum a) where
  fmap f (First x) = First x
  fmap f (Second y) = Second (f y)


-- IO Functor theory
-- `fmap` can lift over

-- In this case the side effect of fmap is that we'll block until user enter smth on getLine
-- getLine :: IO String
-- read :: Read a => String -> a

-- We use `fmap to jump inside IO and use String`


getInt :: IO Int
getInt = fmap read getLine
