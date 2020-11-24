-module(world).
-export([start/0]).

start() ->
    Julian = spawn(person, init, ["Raventid"]),
    Rita = spawn(person, init, ["Hornuglan"]).
