module Main where

-- Making head function more rock-solid
-- λ> Main.head example
-- []
-- λ> Prelude.head example
-- *** Exception: Prelude.head: empty list
head :: Monoid a => [a] -> a
head (x:xs) = x
head [] = mempty

example :: [[Int]]
example = []

main :: IO ()
main = undefined
