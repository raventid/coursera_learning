// This shit should be inplace. This one is not inplace.

impl Solution {
    pub fn duplicate_zeros(arr: &mut Vec<i32>) {
        let length = arr.len();
        let mut tmp = Vec::with_capacity(arr.len());

        for i in arr.clone() {
            if tmp.len() >= length { break; }
            tmp.push(i);

            if tmp.len() >= length { break; }
            if i == 0 { tmp.push(0); } // push one more time
        }

        *arr = tmp;
    }
}




// Inplace version
impl Solution {
    pub fn duplicate_zeros(arr: &mut Vec<i32>) {
        let length = arr.len();
        let mut zeroes = arr.iter().fold(
            0,
            |zeroes, x| if *x == 0 { zeroes + 1 } else { zeroes }
        );

        for i in (0..length).rev() {
            Self::shift(arr, length, i, zeroes);
            if (arr[i] == 0) { zeroes -= 1 }
        }
    }

    fn shift(arr: &mut Vec<i32>, length: usize, index: usize, shift: usize) {
        // move element according to the shift
        if (index + shift < length) {
            arr[index+shift] = arr[index];
        }

        // we should not only copy 0 to shifted position, but also duplicate it on -1 position
        if (index - 1 + shift < length && arr[index] == 0) {
            arr[index+shift-1] = arr[index]
        }
    }
}
