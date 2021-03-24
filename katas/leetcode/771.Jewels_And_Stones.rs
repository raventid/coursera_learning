impl Solution {
    pub fn num_jewels_in_stones(jewels: String, stones: String) -> i32 {
        let mut counter = 0;

        for stone in stones.chars() {
            if jewels.contains(stone) {
                counter += 1;
            }
        }

        return counter;
    }
}
