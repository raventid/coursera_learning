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
