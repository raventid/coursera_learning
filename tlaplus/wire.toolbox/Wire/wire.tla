-------------------------------- MODULE wire --------------------------------
EXTENDS Integers

(*--algorithm wire
variables
    people = {"alice", "bob"},
    acc = [p \in people |-> 5];
define
    NoOverdrafts == \A p \in people: acc[p] >= 0
end define;

process Wire \in 1..2
    variables
        sender = "alice",
        receiver = "bob",
        amount \in 1..acc[sender];
    begin
      CheckFunds:
        if amount <= acc[sender] then
            Withdraw:
                acc[sender] := acc[sender] - amount;
            Deposit:
                acc[receiver] := acc[receiver] + amount;
        end if;
end process;
        
end algorithm;*)
\* BEGIN TRANSLATION
VARIABLES people, acc, pc

(* define statement *)
NoOverdrafts == \A p \in people: acc[p] >= 0

VARIABLES sender, receiver, amount

vars == << people, acc, pc, sender, receiver, amount >>

ProcSet == (1..2)

Init == (* Global variables *)
        /\ people = {"alice", "bob"}
        /\ acc = [p \in people |-> 5]
        (* Process Wire *)
        /\ sender = [self \in 1..2 |-> "alice"]
        /\ receiver = [self \in 1..2 |-> "bob"]
        /\ amount \in [1..2 -> 1..acc[sender[CHOOSE self \in  1..2 : TRUE]]]
        /\ pc = [self \in ProcSet |-> "CheckFunds"]

CheckFunds(self) == /\ pc[self] = "CheckFunds"
                    /\ IF amount[self] <= acc[sender[self]]
                          THEN /\ pc' = [pc EXCEPT ![self] = "Withdraw"]
                          ELSE /\ pc' = [pc EXCEPT ![self] = "Done"]
                    /\ UNCHANGED << people, acc, sender, receiver, amount >>

Withdraw(self) == /\ pc[self] = "Withdraw"
                  /\ acc' = [acc EXCEPT ![sender[self]] = acc[sender[self]] - amount[self]]
                  /\ pc' = [pc EXCEPT ![self] = "Deposit"]
                  /\ UNCHANGED << people, sender, receiver, amount >>

Deposit(self) == /\ pc[self] = "Deposit"
                 /\ acc' = [acc EXCEPT ![receiver[self]] = acc[receiver[self]] + amount[self]]
                 /\ pc' = [pc EXCEPT ![self] = "Done"]
                 /\ UNCHANGED << people, sender, receiver, amount >>

Wire(self) == CheckFunds(self) \/ Withdraw(self) \/ Deposit(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in 1..2: Wire(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION

=============================================================================
\* Modification History
\* Last modified Thu Jan 30 00:12:35 MSK 2020 by juliankulesh
\* Created Tue Jan 28 22:32:42 MSK 2020 by juliankulesh
