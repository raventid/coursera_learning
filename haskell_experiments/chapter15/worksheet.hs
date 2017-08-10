module Worksheet where

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

-- NOTE: Numberic do not have Monoid instance.(it's not comprehensible what operation should it be - summation or multiplication)
-- i.e. should mappend 1 1 be 1 + 1 or 1 * 1 ? :)
