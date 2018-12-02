Theorem plus_id_exercise : forall n m o : nat,
    n = m -> m = o -> n + m = m + o.
Proof.
  intros n m o.
  intros H.
  intros H1.
  rewrite -> H.
  (*instead of `o = o` will get `m = m` here*)
  rewrite <- H1.
  reflexivity. Qed.
