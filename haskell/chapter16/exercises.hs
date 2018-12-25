{-# LANGUAGE FlexibleInstances #-}
module Exercises where

data Sum b a=
    First a
  | Second b

instance Functor (Sum e) where
  fmap f (First a) = First (f a)
  fmap f (Second b) = Second b


data Company a c b =
    DeepBlue a c
  | Something b


instance Functor (Company e e') where
  fmap f (Something b) = Something (f b)
  fmap _ (DeepBlue a c) = DeepBlue a c


data More b a =
    L a b a
  | R b a b
  deriving (Eq, Show)


instance Functor (More a) where
  fmap f (L a b a') = L (f a) b (f a')
  fmap f (R b a b')= R b (f a) b'

-- 1.
data Quant a b =
    Finance
  | Desk a
  | Bloor b

instance Functor(Quant a) where
  fmap f (Bloor b) = Bloor (f b)
  fmap f (Desk a) = Desk a
  fmap f Finance = Finance

-- 2.
data K a b = K a

instance Functor(K a) where
  fmap f (K a) = K a

-- 3.
newtype Flip f a b =
  Flip (f b a)
  deriving (Eq, Show)

newtype K' a b =
  K' a

-- should remind you of an
-- instance you've written before
instance Functor (Flip K' a) where
  fmap f (Flip (K' a)) = Flip (K' (f a))

-- 4.
data EvilGoateeConst a b =
  GoatyConst b


instance Functor(EvilGoateeConst a) where
  fmap f (GoatyConst b) = GoatyConst (f b)

-- You thought you'd escaped the goats
-- by now didn't you? Nope.

-- 5.
data LiftItOut f a =
  LiftItOut (f a)

instance Functor a => Functor(LiftItOut a) where
  fmap f (LiftItOut composedType) = LiftItOut (fmap f composedType)

-- 6.
data Parappa f g a =
  DaWrappa (f a) (g a)

instance (Functor f, Functor g) => Functor(Parappa f g) where
  fmap f (DaWrappa composedF composedG) = DaWrappa (fmap f composedF) (fmap f composedG)

-- 7.
data IgnoreOne f g a b =
  IgnoringSomething (f a) (g b)

instance (Functor g) => Functor(IgnoreOne f g a) where
  fmap f (IgnoringSomething compF compG) = IgnoringSomething (compF) (fmap f compG)

-- 8.
data Notorious g o a t =
  Notorious (g o) (g a) (g t)

instance (Functor g) => Functor(Notorious g o a) where
  fmap f (Notorious o a t) = Notorious o a (fmap f t)

-- 9.
data List a =
    Nil
  | Cons a (List a)

instance Functor(List) where
  fmap f Nil = Nil
  fmap f (Cons a tail) = Cons (f a) (fmap f tail)

-- 10.
data GoatLord a =
    NoGoat
  | OneGoat a
  | MoreGoats (GoatLord a)
              (GoatLord a)
              (GoatLord a)
-- A VERITABLE HYDRA OF GOATS (lol)

instance Functor(GoatLord) where
  fmap f NoGoat = NoGoat
  fmap f (OneGoat a) = OneGoat (f a)
  fmap f (MoreGoats first second third) = MoreGoats (fmap f first) (fmap f second) (fmap f third)


-- 11.
data TalkToMe a = Halt
                | Print String a
                | Read (String -> a)

instance Functor(TalkToMe) where
  fmap f Halt = Halt
  fmap f (Print s a) = Print s (f a)
  fmap f (Read sa) = Read (f . sa)
