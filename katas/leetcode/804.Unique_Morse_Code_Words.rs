impl Solution {
    const ALPHABET: [&'static str; 26] = [".-","-...","-.-.","-..",".","..-.","--.","....","..",".---","-.-",".-..","--","-.","---",".--.","--.-",".-.","...","-","..-","...-",".--","-..-","-.--","--.."];

    pub fn unique_morse_representations(words: Vec<String>) -> i32 {
        use std::collections::HashSet;
        let mut unique_codes = HashSet::new();

        for word in words {
            let encoded_word : String = word.chars().map(|c| Solution::ALPHABET[c as usize - 97]).collect();
            unique_codes.insert(encoded_word);
        }

        unique_codes.iter().count() as i32
    }
}
