module MonoidWorksheet where

import Data.Semigroup

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

-- Calculate Cartesian product
cartCombine :: (a -> b -> c) -> [a] -> [b] -> [c]
cartCombine func l1 l2 = zipWith func newL1 cycledL2
  where
    -- You need to repeat each element
    -- in the first list once for
    -- each element in the second.
    nToAdd = length l2

    -- Maps l1 and makes nToAdd copies of the element
    -- λ> map (take 10 . repeat) [1,2]
    -- [[1,1,1,1,1,1,1,1,1,1],[2,2,2,2,2,2,2,2,2,2]]
    repeatedL1 = map (take nToAdd . repeat) l1

    -- The preceding line leaves you with
    -- a lists of lists, and you need to join them.
    newL1 = mconcat repeatedL1

    -- By cycling the second list,
    -- you can use zipWith to combine these two lists.
    cycledL2 = cycle l2

combineEvents :: Events -> Events -> Events
combineEvents e1 e2 = cartCombine combiner e1 e2
  where combiner = (\x y -> mconcat [x, "-", y])

combineProbs :: Probs -> Probs -> Probs
combineProbs p1 p2 = cartCombine (*) p1 p2

instance Semigroup PTable where
  (<>) ptable1 (PTable [] []) = ptable1
  (<>) (PTable [] []) ptable2 = ptable2
  (<>) (PTable e1 p1) (PTable e2 p2) = createPTable newEvents newProbs
    where newEvents = combineEvents e1 e2
          newProbs = combineProbs p1 p2

instance Monoid PTable where
  mempty = PTable [] []
  mappend = (<>)
