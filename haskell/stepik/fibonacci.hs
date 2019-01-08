fibonacci :: Integer -> Integer
fibonacci 0 = 0
fibonacci n = go 1 0 ((abs n) - 1)
     where go acc prev m
                       | m /= 0 = go (acc + prev) (acc) (m - 1)
                       | otherwise = sign * acc
           sign = if n < 0 then (-1)^((abs n)+1) else 1
