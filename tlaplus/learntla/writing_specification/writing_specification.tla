----------------------- MODULE writing_specification -----------------------

EXTENDS Integers, TLC

(* --algorithm pluscal
variables
 x = 2;
 y = TRUE;

begin
  A:
    x := x + 1;
  B:
    x := x + 1;
    y := FALSE;
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "673e7138" /\ chksum(tla) = "1d801c1a")
VARIABLES x, y, pc

vars == << x, y, pc >>

Init == (* Global variables *)
        /\ x = 2
        /\ y = TRUE
        /\ pc = "A"

A == /\ pc = "A"
     /\ x' = x + 1
     /\ pc' = "B"
     /\ y' = y

B == /\ pc = "B"
     /\ x' = x + 1
     /\ y' = FALSE
     /\ pc' = "Done"

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == A \/ B
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Jun 25 19:21:36 HKT 2023 by raventid
\* Created Sun Jun 25 19:16:14 HKT 2023 by raventid
