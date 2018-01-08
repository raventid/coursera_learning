module Chapter18 where

import Control.Monad (join)
import Control.Applicative

-- Monad types and rules as a nice reminder for me.
-- (>>) :: Monad m => m a -> m b -> m b -- the same as applicative `*>`
-- (>>=) :: Monad m => m a -> (a -> m b) -> m b
-- return :: a -> m a -- the same as applicative `pure`

-- This `bind` function is just a (>>=) flipped.
bind :: Monad m => (a -> m b) -> m a -> m b
bind f xs = join $ fmap f xs

twoBinds :: IO ()
twoBinds = do
  putStrLn "name pls:"
  name <- getLine
  putStrLn "age pls:"
  age <- getLine
  putStrLn ("y helo thar: " ++ name ++ " whois: " ++ age ++ " years old.")

twoBinds' :: IO ()
twoBinds' =
  putStrLn "name pls:" >>
  getLine >>=
  \name -> putStrLn "age pls:" >>
  getLine >>=
  \age -> putStrLn ("y helo thar: " ++ name ++ " whois: " ++ age ++ " years old.")


twiceWhenEven :: [Integer] -> [Integer]
twiceWhenEven xs = do
  x <- xs
  if even x
    then [x*x, x*x]
    else [x]

-- It looks like mapping in imperative languages, but it is not.
-- My past experiance make it look like iteration, but it's a more abstract concept we see here.
-- fmap for list works like map, but for Maybe, Either? No, it does not.
-- So, yeah, it's better to avoid thinking about fmap in terms of iteration.
twiceWhenEven' :: [Integer] -> [Integer]
twiceWhenEven' xs = xs >>= \x -> if even x then [x*x, x*x] else [x]
