module ParametrizedTypes where

data Triple a = Triple a a a deriving Show

first :: Triple a -> a
first (Triple x _ _) = x

second :: Triple a -> a
second (Triple _ x _) = x

third :: Triple a -> a
third (Triple _ _ x) = x

transform :: (a -> a) -> Triple a -> Triple a
transform f (Triple x y z) = Triple (f x) (f y) (f z)

toList :: Triple a -> [a]
toList (Triple x y z) = [x, y, z]


type Point3D = Triple Double

aPoint :: Point3D
aPoint = Triple 0.1 53.2 12.3

cool_stuff_you_can_do_with_transform = transform (* 3) aPoint
