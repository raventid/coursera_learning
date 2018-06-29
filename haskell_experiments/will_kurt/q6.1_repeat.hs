module JustSomeStuff where
  repeat :: a -> [a]
  repeat v = cycle [v]

  backwordInfinity = reverse [1..]
