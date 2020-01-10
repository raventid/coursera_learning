data Log a = Log [String] a deriving (Eq, Show)

returnLog :: a -> Log a
returnLog = Log []

-- Lawfull bind
-- bindLog :: Log a -> (a -> Log b) -> Log b
-- bindLog (Log l1 x) f = let (Log l2 y) = f x
--                         in Log (l1 ++ l2) y

-- Very bad bind
-- Edit and save:
bindLog (Log l1 x) f = let (Log l2 y) = f x
                        in Log (l2 ++ l1 ++ l2) y

instance Functor Log where
  fmap = undefined

instance Applicative Log where
  pure = undefined
  (<*>) = undefined

instance Monad Log where
  return = returnLog
  (>>=) = bindLog

checkLaws :: (Monad m, Eq (m z), Eq (m x), Eq (m y)) => (x -> m y) -> (y -> m z) -> x -> m x -> [Bool]
checkLaws f g a m =
  [ (return a >>= f) == f a                        -- return a >>= k === k a
  , (m >>= return)   == m                          -- m >>= return   === m
  , (m >>= f >>= g)  == (m >>= (\x -> f x >>= g))] -- m >>= k >>= k' === m >>= (\x -> k x >>= k')


toLogger :: (a -> b) -> String -> (a -> Log b)
toLogger f msg = \x -> Log [msg] (f x)

add1Log = toLogger (+1) "added one"
mult2Log = toLogger (* 2) "multiplied by 2"

-- > checkLaws add1Log mult2Log 1 (Log [] 1) => [True, True, True]

-- > :r
-- > checkLaws add1Log mult2Log 1 (Log [] 1) => [True, True, True]

-- ((Log [] 1) >>= mult2Log >>= add1Log)
-- Log ["added one","multiplied by 2","multiplied by 2","added one"] 3

-- ((Log [] 1) >>= (\x -> mult2Log x >>= add1Log))
-- Log ["added one","multiplied by 2","added one","added one","multiplied by 2","added one"] 3

-- 1) building (Log [] 1)
-- 2) first >>= extracts value 1 from (Log [] 1) and pass it to (\x -> mult2Log x >>= add1Log)
-- 3) mult2Log works with the value and outputs (Log [msg1] x1)
-- 4) second >>= receives (Log [msg1] x1), extracts value x1 and pass it into add1Log
-- 5) add1Log creates new: (Log [msg2] x2)
-- 6) second >>= glues (Log [msg1] x1) and (Log [msg2] x2) into this: (Log [msg2, msg1, msg2] x2)
-- 7) first >>= glues (Log [] 1) and (Log [msg2, msg1, msg2] x2) into this: (Log [msg2, msg1, msg2, msg2, msg1, msg2] x2)

-- So in this cobination the third monad law does not work, unfortunately

