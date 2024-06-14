------------------------------- MODULE dekker -------------------------------

EXTENDS TLC, Sequences, Integers, FiniteSets

Threads == 1..2

(*--algorithm dekker

variables
  intent = [i \in Threads |-> FALSE]; \* intent for each thread
  turn = 1; \* who's turn?
  criticalSectionVisitor = {}

define  
  OneThreadInCriticalSection ==
    Cardinality(criticalSectionVisitor) <= 1
end define; 

process thread \in Threads
variables other = 3 - self; \* if (self is 1) then { 2 } else { 1 } 
begin
  SignalIntent:
    intent[self] := TRUE;
    
  CheckEntranceEligibility:
    if intent[other] /\ turn # self then
      intent[self] := FALSE; 
    end if;
    \* await ~intent[other] /\ turn = self; // will lead to a deadlock
    
  WaitForMyTurn:
    await turn = self;
    intent[self] := TRUE;
    criticalSectionVisitor := criticalSectionVisitor \union {self};
    
  EnterCriticalSection:
    turn := other;
    intent[self] := FALSE;
    criticalSectionVisitor := criticalSectionVisitor \ {self};
    
end process;

end algorithm; *) 


\* BEGIN TRANSLATION (chksum(pcal) = "742fa880" /\ chksum(tla) = "7edd7687")
VARIABLES intent, turn, criticalSectionVisitor, pc

(* define statement *)
OneThreadInCriticalSection ==
  Cardinality(criticalSectionVisitor) <= 1

VARIABLE other

vars == << intent, turn, criticalSectionVisitor, pc, other >>

ProcSet == (Threads)

Init == (* Global variables *)
        /\ intent = [i \in Threads |-> FALSE]
        /\ turn = 1
        /\ criticalSectionVisitor = {}
        (* Process thread *)
        /\ other = [self \in Threads |-> 3 - self]
        /\ pc = [self \in ProcSet |-> "SignalIntent"]

SignalIntent(self) == /\ pc[self] = "SignalIntent"
                      /\ intent' = [intent EXCEPT ![self] = TRUE]
                      /\ pc' = [pc EXCEPT ![self] = "CheckEntranceEligibility"]
                      /\ UNCHANGED << turn, criticalSectionVisitor, other >>

CheckEntranceEligibility(self) == /\ pc[self] = "CheckEntranceEligibility"
                                  /\ IF intent[other[self]] /\ turn # self
                                        THEN /\ intent' = [intent EXCEPT ![self] = FALSE]
                                        ELSE /\ TRUE
                                             /\ UNCHANGED intent
                                  /\ pc' = [pc EXCEPT ![self] = "WaitForMyTurn"]
                                  /\ UNCHANGED << turn, criticalSectionVisitor, 
                                                  other >>

WaitForMyTurn(self) == /\ pc[self] = "WaitForMyTurn"
                       /\ turn = self
                       /\ intent' = [intent EXCEPT ![self] = TRUE]
                       /\ criticalSectionVisitor' = (criticalSectionVisitor \union {self})
                       /\ pc' = [pc EXCEPT ![self] = "EnterCriticalSection"]
                       /\ UNCHANGED << turn, other >>

EnterCriticalSection(self) == /\ pc[self] = "EnterCriticalSection"
                              /\ turn' = other[self]
                              /\ intent' = [intent EXCEPT ![self] = FALSE]
                              /\ criticalSectionVisitor' = criticalSectionVisitor \ {self}
                              /\ pc' = [pc EXCEPT ![self] = "Done"]
                              /\ other' = other

thread(self) == SignalIntent(self) \/ CheckEntranceEligibility(self)
                   \/ WaitForMyTurn(self) \/ EnterCriticalSection(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in Threads: thread(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
 
 

=============================================================================
\* Modification History
\* Last modified Mon Aug 07 00:24:08 HKT 2023 by raventid
\* Created Sat Aug 05 23:30:38 HKT 2023 by raventid
