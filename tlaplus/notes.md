# Notes about TLA+

## PlusCal

Randomizing input to spec.

It's trivial to randomize simple variable: _Instead of_ `x = 1`, put `x \in 1..3`

Random note: _Tla+ defines a shorthand BOOLEAN for the set {TRUE, FALSE}_


But what if we want to randomize input represented by a collection?

Working with sets:

Subsetting and unions:
```
>> SUBSET {"a", "b"}
{{}, {"a"}, {"b"}, {"a", "b"}}
>> UNION {{"a"}, {"b"}, {"b", "c"}
{"a", "b", "c"}
```

Product:
```
>> {"a", "b", "c"} \X (1..2)
{<<"a", 1>>, <<"a", 2>>, <<"b", 1>>, <<"b", 2>>, <<"c", 1>>, <<"c", 2>>}
```
*Note that \X is not associative.*


Generate set of user defined structs:
```
>> [a: {"a", "b"}]
{[a |-> "a"], [a |-> "b"]}

>> [a: {"a", "b"}, b: (1..2)]
{ [a |-> "a", b |-> 1], [a |-> "a", b |-> 2], [a |-> "b", b |-> 1], [a |->
"b", b |-> 2] }
```

Sometimes you want a structure where one key is always a specific value,
but another key is some value in a set. 
In that case you can wrap the value in a one-element set, as in [key1: set, key2: {value}]
