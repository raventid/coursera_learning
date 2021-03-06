# Notes on Haskell for personal use.


Here I'm making some notes about Haskell quirks I find difficult to remember or just complex stuff I hardly ever use.

Parametric polymorphism - parameters wich are fully polymorphic (a -> a)

Constrained (ad-hoc, bounded) polymorphism - parameters constrained by typeclasses ((Num a) => a -> a)


Great and ugly - https://wiki.haskell.org/Monomorphism_restriction. Sometimes GHC infer not the most general, but most concrete type. It has some reasons, related to performance in some rare circumstances. A lot of people think that this restriction should be removed from language. 
To avoid monomorphising types we can include this extension:
{-# language nomonomorphismrestriction #-}

It works like that. If you print `example = 1` then without this extension you'll get
Int instead of Num a, wich I would personally prefer (I enjoy polymorphism :D )


`Partial` function: 

A partial function is one that doesn’t handle all the possible cases, so there are possible scenarios in which we haven’t defined any way for the code to evaluate. I.e. -->

Prelude> read "1234567" :: Integer
1234567
Prelude> read "BLAH" :: Integer
*** Exception: Prelude.read: no parse

`read` is a `partial` function because it does return a proper value for each possible input (and compiler cannot catch this, so it's a runtime error)

- Cardinality of datatype is the number of possible values it defines

- Different data declarations:

  newtype - like type synonym, but can have typeclasses overrided for it.
  type - just a synonym for some type, cannot override typeclasses.
  data - new data declaration, can have all of the features, but requires addtional memory.

To construct mixed combos in typeclasses I used this:
{-# LANGUAGE FlexibleInstances #-}

If you would like to derive typeclass from parent you have to use this pragma, it tells GHC to reuse pragma for wrapped type. It works only for newtype declaration, because only newtype always have just one wrapped type. (Like you can write derive (YourClass), instead of implementing it by hand for every newtype you create) 
{-# GeneralizedNewtypeDeriving #-} 

#### Bottom note:
`⊥` or bottom is a term used in Haskell to refer to computations that do not successfully result in a value. The two main varieties of bottom are computations that failed with an error or those that failed to terminate i.e.
```haskell
Prelude> x = x in x
*** Exception: <<loop>>
```
Here GHCi detected that let x = x in x was never going to return and short-circuited the never-ending computation.

Another one is throughing the error
```haskell
f :: Bool -> Int
f True = error "blah" 
f False = 0
```

```
Prelude> f False
0
Prelude> f True
*** Exception: blah
```

And one more is partial function (we have no mathcer for `True` here)
```haskell
f :: Bool -> Int 
f False = 0
```

#### Type-level and runtime level spaces
```haskell
data Trivial = Trivial'
```

Here the type constructor `Trivial` is like a constant value but at the type level. It takes no arguments and is thus `nullary`. The Haskell Report calls these `type constants` to distinguish them from type constructors that take arguments.

The data constructor `Trivial'` is also like a constant value, but it exists in `value`, `term`, or `runtime` space. These are not three different things, but three different words for the same space that types serve to describe.

In fact `constant` might be used for data constructors too. `Trivial'` is constant, because it uses.

Function type is exponential: Given: `a -> b`, the function type b^a.

#### Lifted and unlifted types
To be precise, kind `*` is the kind of all standard lifted types, while types that have the kind `#` are unlifted. A lifted type, which includes any datatype you could define yourself, is any that can be inhabited by bottom. Lifted types are represented by a pointer and include most of the datatypes we’ve seen and most that you’re likely to encounter and use. Unlifted types are any type which cannot be inhabited by bottom. Types of kind `#` are often native machine types and raw pointers. *Newtypes are a special case in that they are kind `*`, but are unlifted because their representation is identical to that of the type they contain*, so the newtype itself is not creating any new pointer beyond that of the type it contains. That fact means that the newtype itself cannot be inhabited by bottom, only the thing it contains can be, so newtypes are unlifted. The default kind of concrete, fully-applied datatypes in GHC is kind `*`.

This text is a bit out of date, due to TypeInType in modern Haskell versions. I love progress!

#### Morphisms
If folds, or *catamorphisms*, let us break data structures down then unfolds let us build them up. There are, as with folds, a few different ways to unfold a data structure. Unfolding is called *anamorphism*.

#### Imports
imports:
qualified to use alias name.


#### Monoid, Functor, Applicative, Monad
##### Semigroup.
Semigroup is the same as Monoid, except it does not provide identity.

```haskell
class Semigroup a where
(<>) :: a -> a -> a
```

##### Monoid laws.

- left identity
```haskell
mappend mempty x = x 
```

- right identity
```haskell
mappend x mempty = x
```

- associativity
```haskell
mappend x (mappend y z) = mappend (mappend x y) z
```

The most obvious way to see that a Monoid's `algebra` is `stronger` than a Semigroup is to observe that it has a strict superset of the operations and laws that Semigroup provides. Anything which is a Monoid is by definition also a Semigroup.

##### Functor

Identity law
```haskell
fmap id = id
```

Composition law
```haskell
fmap (f . g) = fmap f . fmap g
```

Functor: `<$> == fmap`

##### Applicative
`<*> == app` (`ap` is just a name, you can't call it like this, also called `apply`, `tie fighter`)

`fmap f x = pure f <*> x` - this is kinda law of applicative.

Identity law:
`pure id <*> v = v`, where v is a functorial structure
Like in: `(pure id <*> [1..5]) == ([1..5])` 

Composition law:
`pure (.) <*> u <*> v <*> w = u <*> (v <*> w)`, where v is a functorial structure
Like in: `(pure (.) <*> Just (+1) <*> Just (+2) <*> Just 1) == (Just (+1) <*> (Just (+2) <*> Just 1))`

We can also consider a homomorphism here, it is a structure-preserving map between two algebraic structures. The effect of applying a function that is embedded in some structure to a value that is embedded in some structure should be the same as applying a function to a value without affecting any outside structure:
`pure f <*> pure x = pure (f x)`
That’s the statement of the law. Here’s how it looks in practice: `pure (+1) <*> pure 1`
`pure ((+1) 1)`


##### Monad


`Commutative` means: ???

We do not have a proof this is correct, but we have evidence,
```haskell
(+) 76 67 == (flip (+)) 76 67
```
With these values it's equal to 143.

We have a proff it's wrong because we have one contrexample, which shows it's wrong
```haskell
(++) "Hello " "world!" /= (flip (++)) "Hello " "world!"
```
first one is `"Hello world!"` and second one is `"world!Hello "`.



# Terms
Eta-reduction of function - rewriting the function without its arguments. Pretty simple.

# Orphan instances
1. You defined the type but not the type class? Put the instance in the same module as the type so that the type cannot be imported without its instances.
2. You defined the type class but not the type? Put the instance in the same module as the type class definition so that the type class cannot be imported without its instances.
3. Neither the type nor the type class are yours? Define your own newtype wrapping the original type and now you’ve got a type that “belongs” to you for which you can rightly define type class instances. There are means of making this less annoying which we’ll discuss later.

# Stack

## Some stack commands

Generate absolutely new project
`$ stack new project-name`

Build the project:
`$ stack build`

Exec project:
`$ stack exec -- project_name`

Look for exe file path:
`$ stack exec which file-name`

Do not load implicit prelude in my session
`$ stack ghci --ghci-options -XNoImplicitPrelude`

## My stack setup for Spacemacs
I add this to `dotspacemacs/user-confi ()`:

```
(setq
    ghc-ghc-options '("-fno-warn-missing-signatures")
    haskell-compile-cabal-build-command "cd %s && stack build"
    haskell-process-type 'stack-ghci
    haskell-interactive-popup-errors nil
    haskell-process-args-stack-ghci '("--ghc-options=-ferror-spans" "--with-ghc=ghci")
    haskell-process-path-ghci "stack")
  )
```

But I definitely should read more about options I can tweak in HaskellMode.

```
stack install hoogle
stack exec -- hoogle generate
```

Spacemacs will catch everything and work with those settigns out of the box. So, that enough.
`SPC m h f` is your best friend since the moment you install this.


# GHCI
`:l` - loads file into repl

`:t` (`:type`) - information about types, like `:t 'a'` --> `'a' :: Char`

`:i` (`:info`) - information about element, like `:i map` --> `map :: (a -> b) -> [a] -> [b] 	-- Defined in ‘GHC.Base’
`

`:r` - reload all modules without recompiling project

`:set +s` - very simple timer to measure performance of function built in GHCi. After execturion of function it shows how much time did it take.

`:set prompt "mighty raventid λ>"` - set custom prompt (there is a bug with colors haskell-mode I guess, at least my emacs-26 does not support proper colors)

`:sprint` - print what has been evaled so far.

```
-- Before evaling lazy collection
Prelude> blah = enumFromTo 'a' 'z'
Prelude> :sprint blah
blah = _


-- After taking one element from such collection
Prelude> take 1 blah
"a"
Prelude> :sprint blah
blah = 'a' : _


-- That the individual characters were shown as evaluated and not exclusively the spine 
-- after getting the length of blah is one of the unfortunate aforementioned quirks
-- of how GHCi evaluates code.
Prelude> length blah
26
Prelude> :sprint blah
blah = "abcdefghijklmnopqrstuvwxyz"
```

`:set -Wall` - set compiler to show all warnings. Why it's not enabled by default?!


**** Note on sprint
We can use a special command in GHCi called sprint to print vari- ables and see what has been evaluated already, with the underscore representing expressions that haven’t been evaluated yet.
A warning: We always encourage you to experiment and explore for yourself after seeing the examples in this book, but :sprint has some behavioral quirks that can be a bit frustrating.
GHC Haskell has some opportunistic optimizations which intro- duce strictness to make code faster when it won’t change how your code evaluates. Additionally polymorphism means values like Num a => a are really waiting for a sort of argument which will make it concrete (this will be covered in more detail in a later chapter). To avoid this, you have to assign a more concrete type such as Int or Double, otherwise it stays unevaluated, _, in :sprint’s output. If you can keep these caveats to :sprint’s behavior in mind, it can be useful.

# Questions I have
- Not sure I completely understand the way spine works in terms of strictness and nonstrictness. To note it's pages 358-359 of Programming Haskell. So I'm waiting for chapter on strictness and nonstrictness to make it clear.

- Chapter 12: anamorphisms. How x : iterate f (f x) works? How it adds `[]`, to a tail of a list. 

in chapter 12 in exercise 6 in either library creation i didn't understand how can we
nicely apply either' function to implement eithermaybe'.

After some thinking I have an answer. This is the same as in Racket. You don't have 
to add `[]` to the end of the *original* infinite list, you are moving 
through the spines and build a *new* list, so what you get are values one by one, 
you just collect them into the *new* list with take.

Checked how take work and yes, internally it does that `unsafeTake 1   (x: _) = [x]`, now I understand this completely, great.

Revisited after year or so. It's not very comprehensible explanation. TODO: should rewrite it to make it clear.

- Applicative question:

-- Examples of what I'm talking about could be found in chapters 17 and chapters 18.

In Haskell std we return `First a` if we have `First` anywhere, which is correct in
my opinion. But in previous exervices I used Monoid to merge the same heads, which is wrong?
But my checkers spec passed, so looks like it worked correclty in both ways...

- cycleSucc question, Kurt, q13.3
What's going on when i call cycleSucc with 12 (which is `Num a`) and not Int?
I don't understand GHCI outup.
  ```
  λ> cycleSucc (12 :: Int)
  13
  λ> cycleSucc 12
  cycleSucc 12 :: (Num a, Ord a, Enum a, Bounded a) => a
  ```

# Compiler errors

If you put extension definition inside the module definition like this:

```
module Main where
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TemplateHaskell #-}
```

You will see no error from GHC, but later you will pay for this with the error

```
Main.hs:53:1: error:
    Parse error: module header, import declaration
    or top-level declaration expected.
   |
53 | makeLenses ''Inventory
   | ^^^^^^^^^^^^^^^^^^^^^^
Failed, no modules loaded.
```

Yeah, just move extension import higher, above module definition and you'll be fine.


If you will write the code like this one:
```
instance Enum Odd where 
 toEnum n = Odd n
 fromEnum (Odd n) = n
 enumFromThen start(Odd x) then'@(Odd y) = ...
```

you want see normal error like (Oh, you might've forgot `@` sign after start, I am not sure I understand what your programm should do)
what you get is:

```
3.3generators.hs:(10,3)-(15,33): error: …
    • Couldn't match expected type ‘[Odd]’
                  with actual type ‘Odd -> [Odd]’
    • The equation(s) for ‘enumFromThen’ have three arguments,
      but its type ‘Odd -> Odd -> [Odd]’ has only two
      In the instance declaration for ‘Enum Odd’
   |
Compilation failed.
```

As far as I understand you get this because haskell reads this as `start`, `(Odd x)`, `then'@(Odd y)` which is not how I read it.
