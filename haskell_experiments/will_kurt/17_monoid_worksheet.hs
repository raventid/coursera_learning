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
type Events = [String]
type Probs = [Double]

data PTable = PTable Events Probs

-- FIXME: There is no check for user which
-- helps to avoid this constructor:
-- createPTable ["Event1", "Event2"] [1,2,3]
-- We'll silently get the wrong answer :(
createPTable :: Events -> Probs -> PTable
createPTable events probs = PTable events normalizedProbs
  where totalProbs = sum probs
        normalizedProbs = map (\x -> x/totalProbs) probs

showPair :: String -> Double -> String
showPair event prob = mconcat [event, "|", show prob, "\n"]

instance Show PTable where
  show (PTable events probs) = mconcat pairs
    where pairs = zipWith showPair events probs
