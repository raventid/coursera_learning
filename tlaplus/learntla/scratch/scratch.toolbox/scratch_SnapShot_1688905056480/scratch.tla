------------------------------ MODULE scratch ------------------------------
EXTENDS Integers, TLC, Sequences

\*TruthTable == [p, q \in BOOLEAN |-> p => q]


A == {}
B == {2}
C == {2}

Eval == A \union B

=============================================================================
\* Modification History
\* Last modified Sun Jul 09 20:17:24 HKT 2023 by raventid
