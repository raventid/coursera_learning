--learn.hs

module Learn where

x = 10 * 5 + y

myResult = x * 5

y = 10

foo x =
    let y = x * 2
        z = x ^ 2
    in 2 * y * z
