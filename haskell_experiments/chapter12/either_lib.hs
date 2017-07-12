module EitherLib where

-- Well... I'm using undefined for real. This is the worst thing I've ever done in Haskell ;)
lefts' :: [Either a b] -> [a]
lefts' = foldr (\x acc -> if isLeft x then (left x):acc else acc) []
  where isLeft (Left a) = True
        isLeft _ = False
        left (Left a) = a
        left _ = undefined

-- Too much repetition here. Should I move it to foldr somehow?
rights' :: [Either a b] -> [b]
rights' = foldr (\x acc -> if isRight x then (right x):acc else acc) []
  where isRight (Right a) = True
        isRight _ = False
        right (Right a) = a
        right _ = undefined

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
