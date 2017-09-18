# Notes on Haskell for personal use.
Here I'm making some notes about Haskell quirks I find difficult to remember or just complex stuff I hardly ever use.

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
