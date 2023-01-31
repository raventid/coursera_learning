Require Import Arith.
Module Import PrimFloatNotationsInternalB.

Inductive fizzbuzz : expr? -> nat -> P :=
  | FizzBuzz : forall n : nat, fizzbuzz () (n / 15)
  | Fizz
  | Buzz



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
