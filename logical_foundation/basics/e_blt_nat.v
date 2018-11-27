Fixpoint leb (n m : nat) : bool :=
  match n with
  | O => true
  | S n' =>
    match m with
    | O => false
    | S m' => leb n' m'
    end
  end.

Example test_leb1: (leb 2 2) =  true.
Example test_leb2: (leb 2 4) = false.
Example test_leb3: (leb 4 2) = true.


Definition blt_nat (n m : nat) : bool := leb n m.

Example test_blt_nat1: (blt_nat 2 2) = false.
Example test_blt_nat2: (blt_nat 2 4) = true.
Example test_blt_nat3: (blt_nat 4 2) = false.
Example test_blt_nat4: (blt_nat 0 10) = false.
