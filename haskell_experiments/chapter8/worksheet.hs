module Worksheet where

import Data.List(intersperse)

applyTimes :: (Eq a, Num a) =>
              a -> (b -> b) -> b -> b
applyTimes 0 f b = b
applyTimes n f b = f . applyTimes (n-1) f $ b

-- applyTimes 5 (+1) 5
--
-- (+1) (applyTimes ((5-1) (+1) $ 5))
-- (+1) ((+1) (applyTimes ((4-1) (+1) $ 5)))
-- (+1) ((+1) ((+1) (applyTimes ((3-1) (+1) $ 5))))
-- (+1) ((+1) ((+1) ((+1) (applyTimes ((2-1) (+1) $ 5)))))
-- (+1) ((+1) ((+1) ((+1) ((+1) (applyTimes ((1-1) (+1) $ 5))))))
-- (+1) ((+1) ((+1) ((+1) ((+1) (5))))))
-- 10
--

dividedBy :: Integral a => a -> a -> (a, a)
dividedBy num denom = go num denom 0
  where go n d count
          | n < d = (count, n)
          | otherwise = go (n - d) d (count + 1)

summator :: (Eq a, Num a) => a -> a
summator n = go n 0
  where go n acc
         | n == 0 = acc
         | otherwise = go (n - 1) (acc + n)

multiplicator :: Integral a => a -> a -> a
multiplicator x y = go x y 0
  where go x y res
         | y == 0 = res
         | otherwise = go x (y - 1) (res + x)

-- McCarthy function
m91 n
 | n > 100 = n - 10
 | n <= 100 = m91(m91(n+11))
