impl Solution {
    pub fn running_sum(nums: Vec<i32>) -> Vec<i32> {
        nums.iter().fold((0, vec![]), |(sum, mut vec), i| (sum + i, { vec.push(sum + i); vec }) ).1
    }
}
