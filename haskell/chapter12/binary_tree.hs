module BinaryTree where

data BinaryTree a =
  Leaf
  | Node (BinaryTree a) a (BinaryTree a)
  deriving (Eq, Ord, Show)

unfold :: (a -> Maybe (a,b,a)) -> a -> BinaryTree b
unfold f b = case f b of
  Just (a,b,c) -> Node (unfold f a) b (unfold f c)
  Nothing -> Leaf

-- TODO: it would be very nice to add funny pretty printing like
--          0
--     /          \
--    1            1
--   /  \        /  \
--  2    2      2    2
-- / \  / \    / \   / \
-- 3 3 3   3   3  3  3  3
-- But it seems to be a bit harder for deep trees. I'm not sure I know how to visualize deep tree this way :(
treeBuild :: Integer -> BinaryTree Integer
treeBuild = unfold (\i -> if i == 0 then Nothing else Just(i-1, i, i-1))
