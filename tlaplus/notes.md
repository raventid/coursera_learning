# Notes about TLA+

## PlusCal

Randomizing input to spec.

It's trivial to randomize simple variable: _Instead of_ `x = 1`, put `x \in {1,2,3}`

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
