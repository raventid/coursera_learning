sum'n'count :: Integer -> (Integer, Integer)
sum'n'count x = (sum str, toInteger $ length str)
  where
    str = show $ abs x
    sum = foldl (\acc x -> acc + (read [x] :: Integer)) 0

-- like previous one, but a bit more structured
sum'n'count' :: Integer -> (Integer, Integer)
sum'n'count' x =
  let
    numbers = map (\x -> read [x] :: Integer) $ show $ abs x
  in
    (sum numbers, toInteger $ length numbers)

-- more verbose, but without introducing string (redundant conversion)
sum'n'count'' :: Integer -> (Integer, Integer)
sum'n'count'' x = go (0, 0, abs(x))
  where
    go (n, sum, x)
      | x < 10 = (x + sum, n + 1)
      | otherwise = go(n + 1, sum + x `mod` 10, x `div` 10)
