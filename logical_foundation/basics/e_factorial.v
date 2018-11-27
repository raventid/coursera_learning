Fixpoint factorial (n : nat) : nat :=
  match n with
  | 0 => 1
  | S n' => n * (factorial (n'))
  end.

Example test_factorial1 : (factorial 3) = 6.
Example test_factorial2 : (factorial 5) = (mult 10 12).
Example test_factorial3 : (factorial 0) = 0.