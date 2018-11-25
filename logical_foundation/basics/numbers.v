Module NatPlayground.
  Inductive nat : Type :=
  | O : nat
  | S : nat -> nat.

  Inductive nat' : Type :=
  | stop : nat'
  | tick : nat' -> nat'.

  Definition pred (n : nat') :=
    match n with
    | stop => stop
    | tick n' => n' (* if n has the form tick n' for some n', then return n'. *)
    end.
End NatPlayground.

Module NatPlayground2.
  Fixpoint plus (n : nat) (m : nat) : nat :=
    match n with
    | O => m
    | S n' => S (plus n' m)
    end.

  Compute (plus 3 2).

 (*  plus (S (S (S O))) (S (S O))
==> S (plus (S (S O)) (S (S O)))
      by the second clause of the match
==> S (S (plus (S O) (S (S O))))
      by the second clause of the match
==> S (S (S (plus O (S (S O)))))
      by the second clause of the match
==> S (S (S (S (S O))))
      by the first clause of the match
*)

  (* Multiple args with the same type notation *)
  Fixpoint mult (n m : nat) : nat :=
    match n with
    | O => O
    | S n' => plus m (mult n' m)
    end.
End NatPlayground2.