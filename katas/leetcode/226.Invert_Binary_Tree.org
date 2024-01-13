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
    pub fn invert_tree(root: Option<Rc<RefCell<TreeNode>>>) -> Option<Rc<RefCell<TreeNode>>> {
        if (root.is_none()) { return None; } // if root is empty ([])

        let unwrapped = root.unwrap();
        let node = unwrapped.borrow();

        Some(Rc::new(RefCell::new(TreeNode {
            val: node.val,
            left: node.right.as_ref().and_then(|right_root| Self::invert_tree(Some(right_root.clone()))),
            right: node.left.as_ref().and_then(|left_root| Self::invert_tree(Some(left_root.clone())))
        })))
    }
}
