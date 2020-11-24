-module(playground).
-export([start/0, quicksort/1]).

start() ->
    io:format("Hello world~n").

quicksort([]) ->
    [];
quicksort([Pivot|T]) ->
    F = fun(Comparator) -> [Elem || Elem <- T, Comparator(Elem, Pivot)] end,
    % TODO: how to capture operator as a lambda?
    quicksort(F(fun(A,B)->A<B end)) ++ [Pivot] ++ quicksort(F(fun(A,B)->A>=B end)).


% notes:
%% The reason for allowing boolean expressions in guards is to make guards
%% syntactically similar to other expressions.
%% The reason for the orelse and andalso operators is that
%% the boolean operators and/or were originally defined to evaluate both their arguments.
%% In guards, there can be differences between (and and andalso) or between (or and orelse).
%% For example, consider the following two guards:
%%
%% f(X) when (X == 0) or (1/X > 2) -> division by 0, failed
%% g(X) when (X == 0) orelse (1/X > 2) -> successfuly matched
