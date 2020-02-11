# Notes about TLA+

## PlusCal

Randomizing input to spec.

Work with unions

```
>> SUBSET {"a", "b"}
{{}, {"a"}, {"b"}, {"a", "b"}}
>> UNION {{"a"}, {"b"}, {"b", "c"}
{"a", "b", "c"}
```
