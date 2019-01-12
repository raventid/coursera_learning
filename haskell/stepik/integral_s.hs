-- trapezoidal sums
integration' :: (Double -> Double) -> Double -> Double -> Double
integration' f a b =
    h * (((f a + f b) / 2) + innerSum)
  where
    n = 1000 -- number of intervals
    h = (b - a) / n -- interval step for [a,b]
    innerSum = sum $ map f $ points' (n-1) a b h
    points' 0 _ _ _ = []
    points' index acc b h = (acc + h) : points' (index-1) (acc + h) b h

-- more elegant trapezoid? perhaps.
integration :: (Double -> Double) -> Double -> Double -> Double
integration f a b = h * ((f a + f b) / 2 + go (n-1) 0) where
    n = 1000 -- number of intervals
    h = (abs b - abs a) / n -- interval step for [a,b]
    go 0 acc = acc
    go n acc = go (n-1) (acc + f (b - h * n)) -- main difference is here

integrationKortes :: (Double -> Double) -> Double -> Double -> Double
integrationKortes f a b = (b - a) * ((f a + f b) / 2 + sum (map fi [1 .. (n - 1)])) / n
  where fi i = f $ a + (b - a) * i / n
        n = 1000

test :: IO ()
test = if integration' sin pi 0 == (-2.0) then print "success" else error "your trapezoid failed!1!11"

test1 :: IO ()
test1 = if integration (\x -> 1) 0 10 == 10 then print "success" else error "not 10, wow!1!"
