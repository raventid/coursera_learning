module Chapter16 where

-- Fmap looks like plain map, when used with lists:
-- > fmap (\x -> x > 3) [1..6]
-- > [False,False,False,True,True,True]

-- Results are the same and behaviour looks quite similar:
-- > map (\x -> x > 3) [1..6]
-- > [False,False,False,True,True,True]

-- But if we will try to do something like that:
-- > map (+1) (Just 1)
-- Couldn't match expected type ‘[b]’ with actual type ‘Maybe Integer’
-- Oops, simple map cannot look inside our Data Constructor

-- But we can do this with fmap
-- > fmap (+1) (Just 1)
-- > Just 2



-- Add to repl to examine types:
-- :set -XTypeApplications

-- :type fmap @Maybe
-- fmap @Maybe :: (a -> b) -> Maybe a -> Maybe b

-- :type fmap @(Either _)
-- fmap @(Either _) :: (a -> b) -> Either t a -> Either t b


-- I didn't get that, so I've decided to write function with weird signature
-- TODO: Finish that crap:
newtype WeirdType a = WeirdType a

class WeirdTypeClass f where
 e :: b -> f (g a b c)

-- instance WeirdTypeClass(WeirdType) where
--   e b = WeirdType $ Just $ Right $ Just "Hello"

-- Functor realization misleadingly uses f in definition for Functor and f in realization
-- for function (a -> b)
-- fmap :: Functor f
--      => (a -> b) ->     f a      ->         f b
-- fmap       f          (Pls a)    =        Pls (f a)


-- Functor laws:

-- 1. The first law is the law of identity:
-- fmap id == id
-- So if you apply (fmap id) or (id) to `int` it should be the same `int` after.

-- 2. Law of composition
-- fmap (f . g) = fmap f . fmap g
-- If implementation of fmap does not do that - Functor is broken.


-- By combining (fmap . fmap) and more times we can go deeper into the structure.

-- Just fmap - deconstruct external list
-- (fmap . fmap) - goes inside Just, Nothing, Just
-- (fmap. fmap . fmap) - goes inside list, inside Just, Nothing, Just
-- [Just ['a', 'b'], Nothing, Just ['a', 'b']]
