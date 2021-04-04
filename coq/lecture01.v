From mathcomp Require Import ssreflect.

Inductive bool : Type :=
| true
| false.

Check true : bool.

Definition idb := fun b : bool => b.

Definition negb (b : bool) :=
  match b with
  | true => false
  | false => true
  end.
