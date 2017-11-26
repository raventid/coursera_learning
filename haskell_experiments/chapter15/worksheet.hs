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

-- List is one of many classes who have Monoid instance.
-- For list there is a funny thing:
-- foldr mappend mempty == foldr append []

-- As far as I understand now mempty is a 'Identity'

-- Numberic do not have Monoid instance.(it's not comprehensible what operation should it be - summation or multiplication)
-- i.e. should mappend 1 1 be 1 + 1 or 1 * 1 ? :)

-- We can use newtypes from Data.Monoid, wich solve this problem with numeric monoids.
-- Sum's monoid is `+` and Product's monoid is `*`
-- Sum "Frank" <> Sum "Herbert"
-- No instance for (Num [Char]) arising from a use of ‘<>’

data Server = Server String

-- newtype create constraint that we have only 1 unary constructor
-- that means that we won't have any runtime overhead
-- It's smth like single member C union
-- TODO: Find the way to watch memory layout and disasm code.
-- 1) intention 2) type-safetry 3) add instance of typeclass for your type
newtype Server' = Server' String

-- left identity
-- mappend memty x = x

-- right identity
-- mappend x memty = x

-- Associativity
-- mappend x (mappend y z) = mappend (mappend x y) z


