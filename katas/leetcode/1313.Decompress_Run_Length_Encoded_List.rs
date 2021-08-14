impl Solution {
    pub fn decompress_rl_elist(nums: Vec<i32>) -> Vec<i32> {
        let mut result = Vec::new();

        nums.chunks(2).for_each(|chunk| {
            (0..chunk[0]).for_each(|_| {
                result.push(chunk[1])
            })
        });

        result
    }
}

// TODO: memory could be better
