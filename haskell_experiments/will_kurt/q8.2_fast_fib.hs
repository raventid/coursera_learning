module FastFib where

fastFib 1 1 1 = 1
fastFib _ n2 0 = n2
fastFib n1 n2 counter = fastFib (n2) (n1 + n2) (counter - 1)
