impl Solution {
    pub fn reverse(x: i32) -> i32 {
        match x {
            -9..=9 => x,
            _ => {
                let mut divider = 10;
                let mut number = x;
                let mut reversed_number = 0;
                let mut numbers = Vec::with_capacity(10); // for i32

                while number != 0 {
                    numbers.push(number % 10);
                    number = number / 10;
                }

                if numbers.len() == 10 {
                    if (x < 0) {
                        if (!Self::no_negative_overflow_check(&numbers)) {
                            return 0;
                        }
                    } else {
                        if (!Self::no_positive_overflow_check(&numbers)) {
                            return 0;
                        }
                    }
                }

                reversed_number = *numbers.first().expect("should have at least one number");
                numbers.into_iter().skip(1).for_each(|number| {
                   reversed_number = reversed_number * 10 + number;
                });

                reversed_number
            }
        }
    }

    fn no_positive_overflow_check(numbers: &[i32]) -> bool {
        let max_int32 = [2,1,4,7,4,8,3,6,4,7];
        for i in 0..10 {
            let local_max = max_int32[i];
            let current_val = numbers[i];

            if current_val < local_max {
                return true
            }

            if current_val > local_max {
                return false
            }
        }

        true
    }

    fn no_negative_overflow_check(numbers: &[i32]) -> bool {
        let min_int32 = [-2,-1,-4,-7,-4,-8,-3,-6,-4,-8];
        for i in 0..10 {
            let local_min = min_int32[i];
            let current_val = numbers[i];

            if current_val > local_min {
                return true
            }

            if current_val < local_min {
                return false
            }
        }

        true
    }
}
