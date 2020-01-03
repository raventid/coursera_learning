module Tree45 where

data Tree a = Leaf a | Node (Tree a) (Tree a)

height :: Tree a -> Int
height (Leaf _) = 0
height (Node (Leaf _) (Leaf _)) = 1
height (Node (Leaf _) subTree) = 1 + height subTree
height (Node subTree (Leaf _)) = 1 + height subTree
height (Node subTree1 subTree2) = max (1 + height subTree1) (1 + height subTree2)

size :: Tree a -> Int
size (Leaf _) = 1
size (Node (Leaf _) (Leaf _)) = 3
size (Node (Leaf _) subTree) = 2 + size subTree
size (Node subTree (Leaf _)) = 2 + size subTree
size (Node subTree1 subTree2) = 1 + size subTree1 + size subTree2
