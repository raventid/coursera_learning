module Chapter18 where

import Control.Monad (join)
import Control.Applicative


-- keep in mind this is (>>=) flipped
bind :: Monad m => (a -> m b) -> m a -> m b
bind f xs = join $ fmap f xs
