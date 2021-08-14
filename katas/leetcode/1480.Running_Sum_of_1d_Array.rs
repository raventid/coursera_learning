impl Solution {
    pub fn running_sum(nums: Vec<i32>) -> Vec<i32> {
        nums.iter().fold((0, vec![]), |(sum, mut vec), i| (sum + i, { vec.push(sum + i); vec }) ).1
    }
}

impl Solution {
    pub fn running_sum(nums: Vec<i32>) -> Vec<i32> {
        nums.into_iter().fold(Vec::new(), |mut running_sum, elem| {
            match running_sum.last() {
                Some(last) => { running_sum.push(last + elem); running_sum },
                None => { running_sum.push(elem); running_sum }
            }
        })
    }
}
