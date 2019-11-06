# Monoid


In category `Hask` or if we model ideal situtation `Set`, this line of Haskell code is equality of morphisms.
```
mappend = (++)
```

This one is called `extensional` equality, and states the fact that for any two input strings, the outputs of `mappend` and `(++)` are the same. 
Since the *values* of arguments are sometimes *called points* (as in: the value of `𝑓` at point `𝑥`), this is called *point-wise equality*. 
Function equality *without specifying the arguments* is described as *point-free*. 
```
mappend s1 s2 = (++) s1 s2
```
