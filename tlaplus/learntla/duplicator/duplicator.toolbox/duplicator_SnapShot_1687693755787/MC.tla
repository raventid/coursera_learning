---- MODULE MC ----
EXTENDS duplicator, TLC

\* INIT definition @modelBehaviorNoSpec:0
init_168769374872811000 ==
FALSE/\index = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_168769374872812000 ==
FALSE/\index' = index
----
=============================================================================
\* Modification History
\* Created Sun Jun 25 19:49:08 HKT 2023 by raventid
