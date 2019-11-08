module Kleisli where

import Data.Char

type Writer a = (a, String)

-- Our morphisms are functions from an arbitrary type to some Writer type:
-- f :: a -> Writer b

-- This is an identity for our morphism
return :: a -> Writer a
return x = (x, "")

upCase :: String -> Writer String
upCase s = (map toUpper s, "upCase")

toWords :: String -> Writer [String]
toWords s = (words s, "toWords")

-- Our custom composition function
(>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
m1 >=> m2 = \x -> let (y, s1) = m1 x -- It's equivalent to (y, s1) = (a -> Writer b) x = (x, String)
                      (z, s2) = m2 y -- It's equivalent to (z, s2) = (b -> Writer c) y = (y, String)
                  in
                      (z, s1 ++ " " ++ s2) -- z is a result of applying m2 after m1 (Could've used Monoid!), also we join two strings with space in between

process :: String -> Writer [String]
process = upCase >=> toWords


main :: Writer [String]
main = process "Julian is cool"
