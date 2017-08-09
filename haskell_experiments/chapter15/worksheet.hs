module Worksheet where

-- Monoids and semigroups research

-- Monoid is a thing which looks like that:
-- class Monoid m where
--   mempty :: m
--   mappend :: m -> m -> m
--   mconcat :: [m] -> m
--   mconcat = foldr mappend mempty

-- List is one of many classes who have Monoid instance.
