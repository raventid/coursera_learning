-------------------------------- MODULE wire --------------------------------
EXTENDS TLC, Integers

People == {"alice", "bob"}
Money == 1..10
NumTransfers == 2

(* --algorithm wire
variables
  acct \in [People -> Money];

define
  NoOverdrafts ==
    \A p \in People:
      acct[p] >= 0
end define;

process wire \in 1..NumTransfers
variable
  amnt \in 1..5;
  from \in People;
  to \in People
begin
  Check:
    if acct[from] >= amnt then
      Withdraw:
        acct[from] := acct[from] - amnt;
      Deposit:
        acct[to] := acct[to] + amnt;
    end if;
end process;
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "28763263" /\ chksum(tla) = "fca14ce1")
VARIABLES acct, pc

(* define statement *)
NoOverdrafts ==
  \A p \in People:
    acct[p] >= 0

VARIABLES amnt, from, to

vars == << acct, pc, amnt, from, to >>

ProcSet == (1..NumTransfers)

Init == (* Global variables *)
        /\ acct \in [People -> Money]
        (* Process wire *)
        /\ amnt \in [1..NumTransfers -> 1..5]
        /\ from \in [1..NumTransfers -> People]
        /\ to \in [1..NumTransfers -> People]
        /\ pc = [self \in ProcSet |-> "Check"]

Check(self) == /\ pc[self] = "Check"
               /\ IF acct[from[self]] >= amnt[self]
                     THEN /\ pc' = [pc EXCEPT ![self] = "Withdraw"]
                     ELSE /\ pc' = [pc EXCEPT ![self] = "Done"]
               /\ UNCHANGED << acct, amnt, from, to >>

Withdraw(self) == /\ pc[self] = "Withdraw"
                  /\ acct' = [acct EXCEPT ![from[self]] = acct[from[self]] - amnt[self]]
                  /\ pc' = [pc EXCEPT ![self] = "Deposit"]
                  /\ UNCHANGED << amnt, from, to >>

Deposit(self) == /\ pc[self] = "Deposit"
                 /\ acct' = [acct EXCEPT ![to[self]] = acct[to[self]] + amnt[self]]
                 /\ pc' = [pc EXCEPT ![self] = "Done"]
                 /\ UNCHANGED << amnt, from, to >>

wire(self) == Check(self) \/ Withdraw(self) \/ Deposit(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in 1..NumTransfers: wire(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Jun 18 01:29:53 HKT 2023 by raventid
\* Created Sun Jun 18 00:50:45 HKT 2023 by raventid
