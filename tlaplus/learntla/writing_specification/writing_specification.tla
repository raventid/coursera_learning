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

=============================================================================
\* Modification History
\* Last modified Sun Jun 25 19:16:34 HKT 2023 by raventid
\* Created Sun Jun 25 19:16:14 HKT 2023 by raventid
