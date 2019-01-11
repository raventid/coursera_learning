-- 𝑎𝑘 = 𝑎𝑘−1 + 𝑎𝑘−2 − 2𝑎𝑘−3, 𝑘∈ℕ, 𝑘>3
seqA :: Integer -> Integer
seqA 0 = 1
seqA 1 = 2
seqA 2 = 3
seqA n =
  let
    k1' = seqA 2
    k2' = seqA 1
    k3' = seqA 0
    acc' = k1' + k2' - 2 * k3'
    go acc k2 k3 m
      | m /= 0 = go (acc + k2 - (2 * k3)) (acc) (k2) (m - 1)
      | otherwise = acc
  in
    go acc' k1' k2' (n - 3)

-- better from mathematical notation point of view in my opinion :)
seqA' :: Integer -> Integer
seqA' n =
  let
    seq k0 k1 k2 n
                 | n == 0 = k0
                 | otherwise = seq k1 k2 (k1 + k2 - 2 * k0) (n - 1)
  in
    seq 1 2 3 n
