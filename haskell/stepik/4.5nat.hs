module Nat45 where

data Nat = Zero | Suc Nat deriving (Show, Eq)

fromNat :: Nat -> Integer
fromNat Zero = 0
fromNat (Suc n) = fromNat n + 1

toNat :: Integer -> Nat
toNat 0 = Zero
toNat x = Suc (toNat (x-1))

add :: Nat -> Nat -> Nat
add a b = toNat $ (fromNat a) + (fromNat b)

mul :: Nat -> Nat -> Nat
mul a b = toNat $ (fromNat a) * (fromNat b)

fac :: Nat -> Nat
fac = toNat . f . fromNat
  where f 0 = 0
        f 1 = 1
        f x = x * f (x - 1)

testAddition = add (Suc (Suc (Suc (Suc (Suc Zero))))) (Suc (Suc (Suc (Suc (Suc Zero))))) == Suc (Suc (Suc (Suc (Suc (Suc (Suc (Suc (Suc (Suc Zero)))))))))

testMultiplication = mul (Suc (Suc (Suc Zero))) (Suc (Suc (Suc Zero))) == Suc (Suc (Suc (Suc (Suc (Suc (Suc (Suc (Suc Zero))))))))

testFactorial = fac (Suc (Suc (Suc Zero))) == Suc (Suc (Suc (Suc (Suc (Suc Zero)))))
