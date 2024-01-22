------------------------------ MODULE scratch ------------------------------
EXTENDS Integers, TLC, Sequences

\*TruthTable == [p, q \in BOOLEAN |-> p => q]


A == {}
B == {2}
C == {2}

Eval == A \union B \union C

=============================================================================
\* Modification History
\* Last modified Sun Jul 09 20:17:45 HKT 2023 by raventid
