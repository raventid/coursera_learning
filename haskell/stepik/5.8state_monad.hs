module StateMonad58 where

import Control.Monad (replicateM)


newtype State s a = State { runState :: s -> (a,s) }

instance Functor (State s) where
  fmap _ _ = undefined

instance Applicative (State s) where
  pure = undefined
  _ <*> _ = undefined

instance Monad (State s) where
  return a = State $ \state -> (a, state)
  m >>= k = State $ \state -> let
      (a, st') = runState m state
      m' = k a
    in
      runState m' st'
