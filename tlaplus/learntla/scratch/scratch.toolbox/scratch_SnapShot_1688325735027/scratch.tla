------------------------------ MODULE scratch ------------------------------
EXTENDS Integers, TLC, Sequences

TruthTable == [p, q \in BOOLEAN |-> p => q]

Eval == TruthTable

=============================================================================
\* Modification History
\* Last modified Mon Jul 03 03:21:45 HKT 2023 by raventid
