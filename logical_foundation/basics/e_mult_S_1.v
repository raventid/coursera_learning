Theorem mult_0_plus : forall n m : nat,
  (0 + n) * m = n * m.
Proof.
  intros n m.
  rewrite -> plus_O_n.
  reflexivity. Qed.

Theorem mult_S_1 : forall n m : nat,
    m = S n ->
    m * (1 + n) = m * m.
Proof.
  intros n m.
  intros H.
  rewrite -> H.
  (* n, m : nat *)
  (* H : m = S n *)
  (* ============================ *)
  (* S n * (1 + n) = S n * S n *)

  (* if I put this visa versa I get not *)
  (* (0 + S n) * (1 + n) = S n * S n *)
  rewrite <- mult_0_plus.
  (* but error *)
  
  (* когда мы пишем rewrite <- mult_0_plus, *)
  (* то в цели ищется выражение, которое можно унифицировать с ?x * ?y (это правая часть равенства в теореме) *)
  (* и потом ?x * ?y заменяется на (0 + ?x) * ?y; *)
  (* в нашем случае, поскольку речь идёт о том, *)
  (* чтобы найти любое произведение (?x * ?y), *)
  (* то ?x унифицируется с S n, а ?y с (1 + n) *)
  reflexivity. Qed.