Notes on Haskell for personal use.
Here I'm making some notes about Haskell quirks I find difficult to remember or just complex stuff I hardly ever use.

- Cardinality of datatype is the number of possible values it defines

- Different data declarations:

  newtype - like type synonym, but can have typeclasses overrided for it.
  type - just a synonym for some type, cannot override typeclasses.
  data - new data declaration, can have all of the features, but requires addtional memory.
