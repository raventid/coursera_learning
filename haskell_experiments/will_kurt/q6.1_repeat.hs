module JustSomeStuff where
  repeat :: a -> [a]
  repeat v = cycle [v]

  -- If you'd call this somewhere it will hang
  -- because Haskell will follow reverse implementation
  -- and he will never reach the end of list to reverse it
  backwordInfinity = reverse [1..]
