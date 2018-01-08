module Chapter18 where

import Control.Monad (join)
import Control.Applicative


-- Keep in mind this is (>>=) flipped
bind :: Monad m => (a -> m b) -> m a -> m b
bind f xs = join $ fmap f xs


twiceWhenEven :: [Integer] -> [Integer]
twiceWhenEven xs = do
  x <- xs
  if even x
    then [x*x, x*x]
    else []
