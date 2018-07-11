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

newtype Events = Events [String]
newtype Probs = Probs [Double]

data PTable = PTable Events Probs

-- FIXME: There is no check for user which
-- helps to avoid this constructor:
-- createPTable ["Event1", "Event2"] [1,2,3]
-- We'll silently get the wrong answer :(
createPTable :: Events -> Probs -> PTable
createPTable (Events events) (Probs probs) = PTable (Events events) (Probs normalizedProbs)
  where totalProbs = sum probs
        normalizedProbs = map (\x -> x/totalProbs) probs

showPair :: String -> Double -> String
showPair event prob = mconcat [event, "|", show prob, "\n"]

instance Show PTable where
  show (PTable (Events events) (Probs probs)) = mconcat pairs
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

instance Semigroup Events where
  (<>) e1 (Events []) = e1
  (<>) (Events []) e2 = e2
  (<>) (Events e1) (Events e2) = Events $ cartCombine combiner e1 e2
    where combiner = (\x y -> mconcat [x, "-", y])

instance Monoid Events where
  mempty = Events []
  mappend = (<>)

instance Semigroup Probs where
  (<>) p1 (Probs []) = p1
  (<>) (Probs []) p2 = p2
  (<>) (Probs p1) (Probs p2) = Probs $ cartCombine (*) p1 p2

instance Monoid Probs where
  mempty = Probs []
  mappend = (<>)

instance Semigroup PTable where
  (<>) ptable1 (PTable (Events []) (Probs [])) = ptable1
  (<>) (PTable (Events []) (Probs [])) ptable2 = ptable2
  (<>) (PTable e1 p1) (PTable e2 p2) = createPTable (e1 <> e2) (p1 <> p2)

instance Monoid PTable where
  mempty = PTable (Events []) (Probs [])
  mappend = (<>)


-- If you want to know the probability of getting tails
-- on the coin and blue on the spinner,
-- you can use your <> operator:
coin :: PTable
coin = createPTable (Events ["heads", "tails"]) (Probs [0.5, 0.5])

spinner :: PTable
spinner = createPTable (Events ["red", "blue", "green"]) (Probs [0.1, 0.2, 0.7])

-- We combine two probabilities (coin + spinner)
-- The answer we get is "What is the probability to see heads and blue pill"
first_composition = coin <> spinner
throw_coin_three_times = mconcat [coin, coin, coin]
