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
    pub fn max_depth(root: Option<Rc<RefCell<TreeNode>>>) -> i32 {
        match root {
            None => 0,
            Some(node) => {
                let tree_node = node.borrow();

                let left_depth = Self::max_depth(tree_node.left.clone());
                let right_depth = Self::max_depth(tree_node.right.clone());

                1 + Self::max(left_depth, right_depth)
            }
        }
    }

    fn max(a: i32, b: i32) -> i32 {
        if a > b {
            a
        } else {
            b
        }
    }
}
