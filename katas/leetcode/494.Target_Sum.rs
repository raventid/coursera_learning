impl Solution {
    pub fn find_target_sum_ways(nums: Vec<i32>, target: i32) -> i32 {
        Self::recur(&nums, 0, nums.len()-1, target)
    }

    fn recur(nums: &[i32], index: usize, last_elem: usize, target: i32) -> i32 {
        if index == last_elem {
            let positive = target + nums[index] == 0;
            let negative = target - nums[index] == 0;
            if positive && negative {
                return 2
            } else if positive || negative {
                return 1
            } else {
                return 0
            }
        }

        let last = nums[index];

        let positive = Self::recur(&nums, index + 1, last_elem, target+last);
        let negative = Self::recur(&nums, index + 1, last_elem, target+(-1 * last));

        positive + negative
    }
}

// TODO: Solution is not optimal we never cache the results.

// If you will move from back to first elem think about [0, 1] case.
// -0+1 //this one work
// -0-1
// +0+1 //this one works too, and you might loose one of them if you substract 1 first
// +0-1

// If you will move from start to an end this about [1,0]
// -1+0
// -1-0
// +1+0 // this one works
// +1-0 // this one two
// if you write target + nums[index] == 0 || target - nums[index] == 0 you might
// loose one of it
