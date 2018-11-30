Theorem plus_O_n : forall n : nat, 0 + n = n.
Proof.
  intros n. reflexivity. Qed.

(* why not plus_1_n? *)
Theorem plus_1_1 : forall n:nat, 1 + n = S n.
Proof.
  intros n. reflexivity. Qed.

Theorem mult_0_1 : forall n:nat, 0 * n = 0.
Proof.
  intros n. reflexivity. Qed.