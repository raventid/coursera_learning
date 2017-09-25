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

If you would like to derive typeclass from parent you have to use this pragma, it tells GHC to reuse pragma for wrapped type. It works only for newtype declaration, because only newtype always have just one wrapped type.
{-# GeneralizedNewtypeDeriving #-} 

imports:
qualified to use alias name.

Questions:

In chapter 12 in exercise 6 in either library creation I didn't understand how can we
nicely apply either' function to implement eitherMaybe'.


# Stack

Generate absolutely new project
$ stack new project-name

Build the project:
$ stack build

Look for exe file path:
$ stack exec which file-name
