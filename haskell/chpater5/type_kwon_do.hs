module TypeKwonDo where

f :: Int -> String
f = undefined

g :: String -> Char
g = undefined

h :: Int -> Char
h i = g(f(i))


data A
data B
data C

q :: A -> B
q = undefined

w :: B -> C
w = undefined

m :: A -> C
m a = w(q(a))


munge :: (x -> y) -> (y -> (w, z)) -> x -> w
munge f f1 v = fst $ f1 $ f v
