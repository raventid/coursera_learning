module WriteEq where

data ThreeIntegers =
  My Integer Integer Integer

-- Why should I use this My word here, just to avoid parse error
instance Eq ThreeIntegers where
  (==) (My i1 i2 i3)
       (My i1' i2' i3') =
    i1 == i1' && i2 == i2' && i3 == i3'


data TisAnInteger =
  TisAn Integer

instance Eq TisAnInteger where
  (==) (TisAn integer)
       (TisAn integer') =
    integer == integer'

data TwoIntegers =
  Two Integer Integer

instance Eq TwoIntegers where
  (==) (Two i1 i2)
       (Two i1' i2') =
    i1 == i1' && i2 == i2'
  (==) _ _ = False

data StringOrInt =
  TisAnInt Int
 | TisAString String

instance Eq StringOrInt where
  (==) (TisAnInt i) (TisAnInt i') =
    i == i'
  (==) (TisAString s) (TisAString s') =
    s == s'
  (==) _ _ = False

data Pair a =
  Pair a a

instance Eq a => Eq (Pair a) where
  (==) (Pair a a') (Pair b b') =
    a == b && a' == b'

data Tuple a b =
  Tuple a b

instance (Eq a, Eq b) => Eq (Tuple a b) where
 (==) (Tuple a b) (Tuple a' b') =
   a == a' && b == b'

data Which a =
  ThisOne a
 | ThatOne a

instance Eq a => Eq (Which a) where
 (==)(ThisOne a)
     (ThisOne a') =
   a == a'

 (==)(ThatOne a)
     (ThatOne a') =
   a == a'

 (==) _ _ = False

data EitherOr a b =
  Hello a
 | Goodbye b

instance (Eq a, Eq b) => Eq (EitherOr a b) where
  (==)(Hello a)(Hello a') =
    a == a'
  (==)(Goodbye b)(Goodbye b') =
    b == b' -- Unfortunatly we cannot compare a and b types, they might be different
  (==) _ _ = False

















