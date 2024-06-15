---------------------------- MODULE orchestrator ----------------------------

EXTENDS Integers, TLC, FiniteSets

Servers == {"s1", "s2"}

(*--algorithm threads
variables 
  online = Servers;
  
define
  Invariant == \E s \in Servers: s \in online
  Safety == \E s \in Servers: [](s \in online)
  Liveness == ~[](online = Servers)
end define;

process orchestrator = "orchestrator"
begin
  Change:
    while TRUE do
      with s \in Servers do
       either
          await s \notin online;
          online := online \union {s};
        or
          await s \in online;
          await Cardinality(online) > 1;
          online := online \ {s};
        end either;
      end with;
    end while;
end process;

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "7fc2378a" /\ chksum(tla) = "c797959f")
VARIABLE online

(* define statement *)
Invariant == \E s \in Servers: s \in online
Safety == \E s \in Servers: [](s \in online)
Liveness == ~[](online = Servers)


vars == << online >>

ProcSet == {"orchestrator"}

Init == (* Global variables *)
        /\ online = Servers

orchestrator == \E s \in Servers:
                  \/ /\ s \notin online
                     /\ online' = (online \union {s})
                  \/ /\ s \in online
                     /\ Cardinality(online) > 1
                     /\ online' = online \ {s}

Next == orchestrator

Spec == Init /\ [][Next]_vars

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Jul 31 00:15:35 HKT 2023 by raventid
\* Created Mon Jul 31 00:14:14 HKT 2023 by raventid
