// Definition for a binary tree node.
// #[derive(Debug, PartialEq, Eq)]
// pub struct TreeNode {
//   pub val: i32,
//   pub left: Option<Rc<RefCell<TreeNode>>>,
//   pub right: Option<Rc<RefCell<TreeNode>>>,
// }
//
// impl TreeNode {
//   #[inline]
//   pub fn new(val: i32) -> Self {
//     TreeNode {
//       val,
//       left: None,
//       right: None
//     }
//   }
// }
use std::rc::Rc;
use std::cell::RefCell;
impl Solution {
    pub fn range_sum_bst(root: Option<Rc<RefCell<TreeNode>>>, low: i32, high: i32) -> i32 {
        match root {
            Some(tree_node) => {
                let tree_node = tree_node.borrow();
                if tree_node.val >= low && tree_node.val <= high {
                    tree_node.val + Solution::range_sum_bst(tree_node.left.clone(), low, high) + Solution::range_sum_bst(tree_node.right.clone(), low, high)
                } else {
                    Solution::range_sum_bst(tree_node.left.clone(), low, high) + Solution::range_sum_bst(tree_node.right.clone(), low, high)
                }
            }
            None => {
                0
            }
        }
    }
}
