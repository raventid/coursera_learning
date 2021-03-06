module Worksheet where

-- In this import will get Sum and Product for numbers.
import Data.Monoid

-- Monoids and semigroups research

-- Monoid is a thing which looks like that:
-- class Monoid m where
--   mempty :: m
--   mappend :: m -> m -> m
--   mconcat :: [m] -> m
--   mconcat = foldr mappend mempty

-- As far as I understand now mempty is a 'Identity'

-- Numberic do not have Monoid instance.(it's not comprehensible what operation should it be - summation or multiplication)
-- i.e. should mappend 1 1 be 1 + 1 or 1 * 1 ? :)

-- We can use newtypes from Data.Monoid, wich solve this problem with numeric monoids.
-- Sum's monoid is `+` and Product's monoid is `*`
-- Sum "Frank" <> Sum "Herbert"
-- No instance for (Num [Char]) arising from a use of ‘<>’

-- We cannot(quite expectedly) use mappend with 3 arguments:
-- mappend (Sum 8) (Sum 9) (Sum 10)
-- But we can definitely be smart and do this:
-- mconcat [(Sum 8), (Sum 9), (Sum 10)]

-- Monoid concept is very strongly associated with catamorphism.
-- foldr mappend mempty ([2, 4, 6] :: [Product Int])
-- foldr mappend mempty ["blah", "woot"]

-- One more time about newtype:
-- newtype create constraint that we have only 1 unary constructor
-- that means that we won't have any runtime overhead
-- It's smth like single member C union
-- TODO: Find the way to watch memory layout and disasm code.
-- 1) intention
-- 2) type-safetry
-- 3) add instance of typeclass for your type

-- Laws of Monoid:

-- 1) Left identity
-- mappend memty x = x

-- 2) Right identity
-- mappend x memty = x

-- 3) Associativity
-- mappend x (mappend y z) = mappend (mappend x y) z

-- 4) The binary operation must be associative and it must have a sensible identity value

-- For every monoid, for every type, rules above - are laws.
mappendingBool :: Bool
mappendingBool = getAll $ All True <> All True

mappendingBool' :: Bool
mappendingBool' = getAny $ Any True <> Any False

mappendingMaybe :: Maybe Int
mappendingMaybe =  getFirst $ First (Just 1) `mappend` First (Just 2)

mappendingMaybe' :: Maybe Int
mappendingMaybe' = getLast $ Last (Just 1) `mappend` Last (Just 2)


-- `a` is a phantom
data Booly a =
    True'
  | False'
  deriving (Eq, Show)

-- GHC don't ask me to add Monoid constraint to `a`, cause it is phantom.
-- But GHC will ask for mempty impelementation wich is not here.
instance Monoid (Booly a) where
  mappend False' _ = False'
  mappend _ False' = False'
  mappend True' True' = True'


-- Madness

type Verb = String
type Adjective = String
type Adverb = String
type Noun = String
type Exclamation = String


madlibbin' :: Exclamation
           -> Adverb
           -> Noun
           -> Adjective
           -> String
madlibbin' e adv noun adj = mconcat [
  e, " !he said",
  e , "! he said " ,
  adv , " as he jumped into his car " ,
  noun , " and drove off with his " ,
  adj , " wife." ]
