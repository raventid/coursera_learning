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


The most interesting note about Monoid is that it's a single object category. In fact the name monoid comes from Greek mono, which means single. Every monoid can be described as a single object category with a set of morphisms that follow appropriate rules of composition.


For example if we take `Set` category we might think that one of our objects is `Set of all natural numbers`. `Set of all natural numbers` is just one object in our category. Monoid relates exactly to this one object, so if we pry open it, we'll see that there is enormous amount of morphisms wich follow `Monoid` rules (left id, right id, associativity).




# Free category

If you just imagine graph with two nodes (`a` and `a'`) and arrow from `a` to `a'` and you will try to build morphism between them and imagine that this is category, than it's called free category (not sure I understand this well enough :) )
