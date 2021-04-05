-- This code is a copy of gist:
-- https://gist.github.com/david-christiansen/3660d5d45e9287c25a5e

module FizzBuzzC

%default total

-- Dependently typed FizzBuzz, constructively

-- A number is fizzy if it is evenly divisible by 3
data Fizzy : Nat -> Type where
  ZeroFizzy : Fizzy 0
  Fizz : Fizzy n -> Fizzy (3 + n)

-- Fizzy is a correct specification of divisibility by 3 - that is, if n is
-- fizzy then there exists some k such that n = 3*k.
fizzyCorrect : (n : Nat) -> Fizzy n -> (k : Nat ** n = 3 * k)
fizzyCorrect Z ZeroFizzy = (Z ** Refl)
fizzyCorrect (S (S (S k))) (Fizz x) =
  let (k' ** ih) = fizzyCorrect k x
  in (S k' ** ?fizzyIsAOK)

-- Basic fizziness lemmas
oneNotFizzy : Not (Fizzy 1)
oneNotFizzy (Fizz f) impossible

twoNotFizzy : Not (Fizzy 2)
twoNotFizzy (Fizz f) impossible

fizzyUp : Not (Fizzy n) -> Not (Fizzy (3 + n))
fizzyUp nope ZeroFizzy impossible
fizzyUp nope (Fizz f) = nope f

-- Fizziness is decidable
decFizzy : (n : Nat) -> Dec (Fizzy n)
decFizzy Z = Yes ZeroFizzy
decFizzy (S Z) = No oneNotFizzy
decFizzy (S (S Z)) = No twoNotFizzy
decFizzy (S (S (S k))) with (decFizzy k)
  decFizzy (S (S (S k))) | (Yes prf) = Yes (Fizz prf)
  decFizzy (S (S (S k))) | (No contra) = No $ fizzyUp contra

-- A number is buzzy if it is evenly divisible by 5
data Buzzy : Nat -> Type where
  ZeroBuzzy : Buzzy 0
  Buzz : Buzzy n -> Buzzy (5 + n)

-- Correctness of buzziness spec elided due to verbosity

oneNotBuzzy : Not (Buzzy 1)
oneNotBuzzy (Buzz b) impossible

twoNotBuzzy : Not (Buzzy 2)
twoNotBuzzy (Buzz b) impossible

threeNotBuzzy : Not (Buzzy 3)
threeNotBuzzy (Buzz b) impossible

fourNotBuzzy : Not (Buzzy 4)
fourNotBuzzy (Buzz b) impossible

buzzOff : Not (Buzzy n) -> Not (Buzzy (5 + n))
buzzOff nope ZeroBuzzy impossible
buzzOff nope (Buzz b) = nope b

decBuzzy : (n : Nat) -> Dec (Buzzy n)
decBuzzy Z = Yes ZeroBuzzy
decBuzzy (S Z) = No oneNotBuzzy
decBuzzy (S (S Z)) = No twoNotBuzzy
decBuzzy (S (S (S Z))) = No threeNotBuzzy
decBuzzy (S (S (S (S Z)))) = No fourNotBuzzy
decBuzzy (S (S (S (S (S k))))) with (decBuzzy k)
  decBuzzy (S (S (S (S (S k))))) | (Yes prf) = Yes (Buzz prf)
  decBuzzy (S (S (S (S (S k))))) | (No way) = No (buzzOff way)

-- A version of Dec that tracks two properties - DoubleDec A B is isomorphic
-- to (Dec A, Dec B). This is just for readability.
data DoubleDec : Type -> Type -> Type where
  Neither : Not a -> Not b -> DoubleDec a b
  First : a -> Not b -> DoubleDec a b
  Second : Not a -> b -> DoubleDec a b
  Both : a -> b -> DoubleDec a b

decFizzBuzz : (n : Nat) -> DoubleDec (Fizzy n) (Buzzy n)
decFizzBuzz n with (decFizzy n, decBuzzy n)
  decFizzBuzz n | (Yes f, Yes b) = Both f b
  decFizzBuzz n | (No nf, Yes b) = Second nf b
  decFizzBuzz n | (Yes f, No nb) = First f nb
  decFizzBuzz n | (No nf, No nb) = Neither nf nb


-- Let's show some fizzing and buzzing. Start with all the nats:
nats : Stream Nat
nats = iterate S Z

-- and the fizzed and buzzed nats
fizzBuzz : Stream (n : Nat ** DoubleDec (Fizzy n) (Buzzy n))
fizzBuzz = map (\n => (n ** (decFizzBuzz n))) (tail nats)

instance Show (n : Nat ** DoubleDec (Fizzy n) (Buzzy n)) where
  show (x ** Neither _ _) = show x
  show (x ** First _ _)   = "Fizz"
  show (x ** Second _ _)  = "Buzz"
  show (x ** Both _ _)    = "FizzBuzz"

-- Take the first 100 numbers' FizzBuzzes, then print them to the screen.
namespace Main
  main : IO ()
  main = sequence_ . map (putStrLn . show) . take 100 $ fizzBuzz

---------- Proofs ----------

FizzBuzzC.fizzyIsAOK = proof
  compute
  intros
  rewrite plusSuccRightSucc k' (plus k' 0)
  rewrite plusSuccRightSucc k' (S (plus k' (plus k' 0)))
  rewrite plusSuccRightSucc k' (plus k' (plus k' 0))
  rewrite ih
  trivial
