module Main where

import Data.Semigroup
import Data.List.NonEmpty

-- We can create custom symbolic constructors!
-- But this symbolic constructor cannot be prefix, only infix :(
data Q =
  Int :!!: String

main :: IO ()
main = putStrLn "Stub main function. Write your code in main."
