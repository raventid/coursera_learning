module BinaryTreeHomework where

data BinaryTree a =
  Leaf
  | Node (BinaryTree a) a (BinaryTree a)
  deriving (Eq, Ord, Show)

mapTree :: (a -> b) -> BinaryTree a -> BinaryTree b
mapTree _ Leaf = Leaf
mapTree f (Node left a right) = Node (mapTree f left) (f a) (mapTree f right)

-- Code is simple and straightforward, but algorithm is deadly bad.
-- Constant concatination instead of head growing.
preorder :: BinaryTree a -> [a]
preorder (Node Leaf a Leaf) = [a]
preorder (Node left a right) = [a] ++ preorder left ++ preorder right

inorder :: BinaryTree a -> [a]
inorder (Node Leaf a Leaf) = [a]
inorder (Node left a right) = inorder left ++ [a] ++ inorder right

postorder :: BinaryTree a -> [a]
postorder (Node Leaf a Leaf) = [a]
postorder (Node left a right) = postorder left ++ postorder right ++ [a]

foldTree :: (a -> b -> b) -> b -> BinaryTree a -> b
foldTree f z (Node Leaf a Leaf) = f a z
foldTree f z (Node left a Leaf) = foldTree f (f a z) left
foldTree f z (Node Leaf a right) = foldTree f (f a z) right
foldTree f z (Node left a right) = foldTree f (f a (foldTree f z right)) left

testTree :: BinaryTree Integer
testTree = Node (Node Leaf 1 Leaf) 2 (Node Leaf 3 Leaf)
anotherTestTree = Node (Node (Node Leaf 1 Leaf) 1 Leaf) 2 (Node Leaf 3 Leaf)

testPreorder :: IO ()
testPreorder =
  if preorder testTree == [2, 1, 3]
  then putStrLn "Preorder fine!"
  else putStrLn "Bad news bears."

testInorder :: IO ()
testInorder =
  if inorder testTree == [1, 2, 3]
  then putStrLn "Inorder fine!"
  else putStrLn "Bad news bears."

testPostorder :: IO ()
testPostorder =
  if postorder testTree == [1, 3, 2]
  then putStrLn "Postorder fine!"
  else putStrLn "postorder failed check"

testFoldTree :: IO ()
testFoldTree =
  if foldTree (+) 10 testTree == 16
  then putStrLn "Folding works fine!"
  else putStrLn "folding failed check"

testAnotherFoldTree :: IO ()
testAnotherFoldTree =
  if foldTree (+) 10 anotherTestTree == 17
  then putStrLn "Folding works fine!(another)"
  else putStrLn "folding failed check(another)"

main :: IO ()
main = do
  testPreorder
  testInorder
  testPostorder
  testFoldTree
  testAnotherFoldTree
