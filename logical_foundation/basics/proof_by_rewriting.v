Theorem plus_id_example : forall n m : nat,
    n = m ->
    n + n = m + m.
Proof.
  (*move both quantitifers into the context*)
  intros n m.
  (*move hypothesis into context*)
  intros H.
  (*rewrite the goal using the hypothesis*)
  rewrite -> H.
  reflexivity. Qed.