module EitherLib where

lefts' :: [Either a b] -> [a]
lefts' = foldr (\x acc -> if isLeft x then (left x):acc else acc) []
  where isLeft (Left a) = True
        isLeft _ = False
        left (Left a) = a

-- Too much repetition here. Should I move it to foldr somehow?
-- Now I think we can use Maybe to write Right and Left extractors, but it looks like
-- overhead for current context.
rights' :: [Either a b] -> [b]
rights' = foldr (\x acc -> if isRight x then (right x):acc else acc) []
  where isRight (Right a) = True
        isRight _ = False
        right (Right a) = a


partitionEithers' :: [Either a b] -> ([a], [b])
partitionEithers' xs = (lefts' xs, rights' xs)

eitherMaybe' :: (b -> c) -> Either a b -> Maybe c
eitherMaybe' f (Left a) = Nothing
eitherMaybe' f (Right a) = Just $ f a

either' :: (a -> c) -> (b -> c) -> Either a b -> c
either' f _ (Left a) = f a
either' _ f (Right b) = f b

-- Not sure, I understand the idea correctly.
eitherMaybe'' :: (b -> c) -> Either a b -> Maybe c
eitherMaybe'' _ (Right a) = Nothing
eitherMaybe'' f e@(Left b) = Just $ either' undefined f e
