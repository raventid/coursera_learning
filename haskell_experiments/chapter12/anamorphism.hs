module Anamorphism where

-- As far as I understand this it is like stream in Racket:
-- (define ones (lambda () (cons 1 ones)))
-- But Racket can easily store different elements in list (dynamic types), I think that Haskell does
-- the next thing. GHC looks at this code and thinks - Hmmm, he asks me to build a list, but it's an
-- infinite recursion, oh I'm lazy! I can typecheck this and if thats write I can calculate tail only
-- when it's needed. The question is how does it know how to finish the list with ` lastElement : []`?
myIterate :: (a -> a) -> a -> [a]
myIterate f a = a : myIterate f (f a)

myUnfoldr :: (b -> Maybe (a, b)) -> b -> [a]
myUnfoldr f b = case f b of
  Just (a,b) -> a : myUnfoldr f b
  Nothing -> []

-- Well, how laziness works here? # TODO: do not understand completely
betterIterate :: (a -> a) -> a -> [a]
betterIterate f x = myUnfoldr (\x -> Just (x, f x)) x
