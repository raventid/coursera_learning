open import IO

data ℕ : Set where
  zero : ℕ
  suc  : ℕ → ℕ

seven = suc (suc (suc (suc (suc (suc (suc zero))))))

main = run (putStrLn "Hello, world!")
