module FoldingsOneMoreTime where

-- Yep, traditinal dig into why foldr works with infinite list
-- and foldl does not.



-- This definition might support incorrect intuition about
-- the fact that foldl works with infinite collection.
-- Because we create newInit right now and go to the next
-- iteration.

-- Left folding looks like this, if we write
-- how it works explicitly:

-- f (... (f ( f (f z x1) x2) x3) ...) xn
-- foldl use (\acc elem -> ...) as f

myFoldl f init [] = init
myFoldl f init (x:xs) = myFoldl f newInit xs
  where newInit = f init x


-- Right folding looks like this:
-- f x1 (f x2 (f x3 (...(f xn z) ...)))

-- foldr use (\elem acc -> ...) as f
myFoldr f init [] = init
myFoldr f init (x:xs) = f x rightResult
  where rightResult = myFoldr f init xs
