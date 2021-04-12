impl Solution {
    pub fn subtract_product_and_sum(n: i32) -> i32 {
        let mut number = n;
        let mut sum = 0;
        let mut product = 1;

        while (number != 0) {
            let rem = number % 10;
            number = number/10;
            sum += rem;
            product *= rem;
        }

        product - sum
    }
}
