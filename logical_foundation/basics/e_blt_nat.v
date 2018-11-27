(* Test if numbers are equal *)
Fixpoint beq_nat (n m : nat) : bool :=
  match n with
  | O => match m with
        | O => true
        | S m' => false
        end
  | S n' => match m with
           | O => false
           | S m' => beq_nat n' m'
           end
  end.
Example test_beq_nat1: (beq_nat 2 2) = true.
Proof. simpl. reflexivity. Qed.
Example test_beq_nat2: (beq_nat 2 3) = false.
Proof. simpl. reflexivity. Qed.

(* Test if first number is smaller or equal to second*)
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
Proof. simpl. reflexivity. Qed.
Example test_leb2: (leb 2 4) = true.
Proof. simpl. reflexivity. Qed.
Example test_leb3: (leb 4 2) = false.
Proof. simpl. reflexivity. Qed.

(* Synthetic function with a complicated meaning :-) *)
Definition blt_nat (n m : nat) : bool :=
  match beq_nat n m with
  | true => false
  | false => leb n m
  end.
Example test_blt_nat1: (blt_nat 2 2) = false.
Proof. simpl. reflexivity. Qed.
Example test_blt_nat2: (blt_nat 2 4) = true.
Proof. simpl. reflexivity. Qed.
Example test_blt_nat3: (blt_nat 4 2) = false.
Proof. simpl. reflexivity. Qed.
