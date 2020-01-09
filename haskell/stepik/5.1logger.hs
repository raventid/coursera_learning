module Logger51 where

data Log a = Log [String] a deriving Show

toLogger :: (a -> b) -> String -> (a -> Log b)
toLogger f msg = \x -> Log [msg] (f x)

execLoggers :: a -> (a -> Log b) -> (b -> Log c) -> Log c
execLoggers x f g = case f x of
                      Log logs value -> case g value of
                                          Log logs' value' -> Log (logs' ++ logs) value'
