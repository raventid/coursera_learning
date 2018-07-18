import Control.Monad

evensGuard :: Int -> [Int]
evensGuard n = do
  val <- [1..n]
  guard (even val)
  return val

-- Filter function using do-notation.
-- Looks cool! Btw.
myFilter :: (a -> Bool) -> [a] -> [a]
myFilter f xs = do
  val <- xs
  guard $ f val
  return val

-- TODO: implement my own Alternative typeclass and guard function.
