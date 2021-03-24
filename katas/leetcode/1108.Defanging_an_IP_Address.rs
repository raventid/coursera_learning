impl Solution {
    pub fn defang_i_paddr(address: String) -> String {
        address.chars().map(|c| {
            if c == '.' {
                "[.]".to_owned()
            } else {
                c.to_string()
            }
        }).collect()
    }
}
