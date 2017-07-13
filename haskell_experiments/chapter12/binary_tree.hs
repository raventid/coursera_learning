module BinaryTree where

data BinaryTree a =
  Leaf
  | Node (BinaryTree a) a (BinaryTree a)
  deriving (Eq, Ord, Show)

unfold :: (a -> Maybe (a,b,a)) -> a -> BinaryTree b
unfold f b = case f b of
  Just (a,b,c) -> Node (unfold f a) b (unfold f c)
  Nothing -> Leaf

treeBuild :: Integer -> BinaryTree Integer
treeBuild = unfold (\i -> if i == 0 then Nothing else Just(i-1, i, i-1))
