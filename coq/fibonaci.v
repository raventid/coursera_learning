Require Import Arith.

(* The direct implementation *)
Fixpoint fib_direct (n : nat) : nat :=
  match n with
    | 0 => 0
    | S n' => match n' with
                | 0 => 1
                | S n'' => fib_direct n' + fib_direct n''
              end
  end.

Compute fib_direct 10.


(* The tail recursive Fibonacci *)
Fixpoint fib_accumulator (n : nat) (a : nat) (b : nat) : nat :=
  match n with
    | 0     => b
    | (S n') => fib_accumulator n' (a+b) a
  end.

(* An alias to scrape away unnecessary information *)
Definition fib_acc (n : nat) := fib_accumulator n 1 0.

(* Test that it *)
Compute fib_acc 10.

Lemma fib_accum : forall n, fib_accumulator (S n) 1 0 = fib_accumulator n 2 1. Admitted.

Theorem eqb_fib : forall n, fib_direct n = fib_acc n.
Proof.
  intros n.
  induction n as [| n' I].
  - simpl. reflexivity.
  - simpl.
    (* rewrite I. *)
    unfold fib_acc.
    simpl.
    unfold fib_acc in I.
    destruct n' as [|n'''] eqn:E.
    + simpl. reflexivity.
    + simpl.
      rewrite fib_accum in I.
      rewrite <- I.
      simpl.

Definition specification_of_fibonacci (f : nat -> nat) :=
  f 0 = 0
  /\
  f 1 = 1
  /\
  forall n : nat, f (S (S n)) = f (S n) + f n.
