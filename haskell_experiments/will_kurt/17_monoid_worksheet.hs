module MonoidWorksheet where

-- MONOID RULES ONE MORE TIME, PLS:

-- The first is that mappend mempty x is x.
-- Remembering that mappend is the same as (++),
-- and mempty is [] for lists, this intuitively means that
--        []  ++ [1,2,3] = [1,2,3]

-- The second is just the first with the order reversed:
-- mappend x mempty is x. In list form this is
--        [1,2,3] ++ [] = [1,2,3]

-- The third is that mappend x (mappend y z) = mappend (mappend x y) z.
-- This is just associativity, and again for lists this seems rather obvious:
--        [1] ++ ([2] ++ [3]) = ([1] ++ [2]) ++ [3]

-- Because this is a Semigroup law,
-- then if mappend is already implemented as <>,
-- this law can be assumed because it’s required by the Semigroup laws.

-- The fourth is just our definition of mconcat:
-- mconcat = foldr mappend mempty
