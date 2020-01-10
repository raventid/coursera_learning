list = [(x,y) | x <- [1,2,3], y <- [4,5,6]]

list' = do
  x <- [1,2,3]
  y <- [4,5,6]
  return (x,y)

list'' =
  [1,2,3] >>= (\x -> [4,5,6] >>= (\y -> return (x,y)))
