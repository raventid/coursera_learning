-module(walks).
-export([plan_route/2]).

-spec plan_route(point(), point()) -> route().

-type direction() :: north | south | east | west.
-type point() :: {integer(), integer()}.
-type route() :: [{go, direction(), integer()}].
