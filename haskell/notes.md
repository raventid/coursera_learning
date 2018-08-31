# Notes on Haskell for personal use.


Here I'm making some notes about Haskell quirks I find difficult to remember or just complex stuff I hardly ever use.



Parametric polymorphism - parameters wich are fully polymorphic (a -> a)

Constrained(ad-hoc) polymorphism - parameters constrained by typeclasses ((Num a) => a -> a)


To avoid monomorphising types we can include this extension:
{-# LANGUAGE NoMonomorphismRestriction #-}

It works like that. If you print `example = 1` then without this extension you'll get
Int instead of Num a, wich I would personally prefer (I enjoy polymorphism :D )


`Partial` function: 

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

imports:
qualified to use alias name.

Functor: <$> == fmap
Applicative: <*> == app(just a name, you can't call it like this)

# Stack

Generate absolutely new project
$ stack new project-name

Build the project:
$ stack build

Look for exe file path:
$ stack exec which file-name

Do not load implicit prelude in my session
$ stack ghci --ghci-options -XNoImplicitPrelude


# GHCI
`:r` - reload all modules without recompiling project

`:set +s`

Very simple timer to measure performance of function built in GHCI.


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