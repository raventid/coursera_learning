module MaybeLib where

isJust :: Maybe a -> Bool
isJust (Just _) =  True
isJust (Nothing) = False

isNothing :: Maybe a -> Bool
isNothing = not . isJust

mayybe :: b -> (a -> b) -> Maybe a -> b
mayybe b f Nothing = b
mayybe b f (Just a) = f a

fromMaybe :: a -> Maybe a -> a
fromMaybe fallback Nothing = fallback
fromMaybe fallback (Just a) = a

listToMaybe :: [a] -> Maybe a
listToMaybe (x:xs) = Just x
listToMaybe _ = Nothing

-- Here we cannot write Nothing, we have to write (Nothing) to pattern match on data constant(constructor).
maybeToList :: Maybe a -> [a]
maybeToList (Nothing) = []
maybeToList (Just a) = [a]

catMaybes :: [Maybe a] -> [a]
catMaybes = foldr (\x acc -> if isJust x then (unwrap x):acc else acc) []
  where unwrap (Just x) = x

flipMaybe :: [Maybe a] -> Maybe [a]
flipMaybe xs = if any isNothing xs then Nothing else Just $ catMaybes xs
