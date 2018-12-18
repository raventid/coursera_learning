# Notes on Haskell for personal use.


Here I'm making some notes about Haskell quirks I find difficult to remember or just complex stuff I hardly ever use.

Parametric polymorphism - parameters wich are fully polymorphic (a -> a)

Constrained (ad-hoc, bounded) polymorphism - parameters constrained by typeclasses ((Num a) => a -> a)

To avoid monomorphising types we can include this extension:
{-# LANGUAGE NoMonomorphismRestriction #-}

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

#### Imports
imports:
qualified to use alias name.


#### Monoid, Functor, Applicative, Monad
Functor: <$> == fmap
Applicative: <*> == app(just a name, you can't call it like this)

# Stack

## Some stack commands

Generate absolutely new project
$ stack new project-name

Build the project:
$ stack build

Look for exe file path:
$ stack exec which file-name

Do not load implicit prelude in my session
$ stack ghci --ghci-options -XNoImplicitPrelude

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


# GHCI
`:l` - loads file into repl

`:t` (`:type`) - information about types, like `:t 'a'` --> `'a' :: Char`

`:i` (`:info`) - information about element, like `:i map` --> `map :: (a -> b) -> [a] -> [b] 	-- Defined in ‘GHC.Base’
`

`:r` - reload all modules without recompiling project

`:set +s` - very simple timer to measure performance of function built in GHCi. After execturion of function it shows how much time did it take.

`:set prompt "mighty raventid λ>"` - set custom prompt (there is a bug with colors haskell-mode I guess, at least my emacs-26 does not support proper colors)

`:set -Wall` - set compiler to show all warnings. Why it's not enabled by default?!

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
