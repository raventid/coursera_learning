// https://github.com/bluss/indexmap (the alternative implementation might be something like this one)

use std::collections::HashMap;

struct RandomizedSet {
    hashmap: HashMap<i32, usize>,
    vector: Vec<i32>
}


/**
 * `&self` means the method takes an immutable reference.
 * If you need a mutable reference, change it to `&mut self` instead.
 */
impl RandomizedSet {

    /** Initialize your data structure here. */
    fn new() -> Self {
        RandomizedSet {
            hashmap: HashMap::new(),
            vector: Vec::new(),
        }
    }

    /** Inserts a value to the set. Returns true if the set did not already contain the specified element. */
    fn insert(&mut self, val: i32) -> bool {
        if !self.hashmap.contains_key(&val) {
            self.vector.push(val);
            let index = self.vector.len() - 1;

            self.hashmap.insert(val, index);

            true
        } else {
            false
        }
    }

    /** Removes a value from the set. Returns true if the set contained the specified element. */
    fn remove(&mut self, val: i32) -> bool {
        if self.hashmap.contains_key(&val) {
            let element_to_remove_vector_index : usize = *self.hashmap.get(&val).unwrap();
            let last_element_we_should_save : i32 = *self.vector.last().unwrap();

            self.hashmap.insert(last_element_we_should_save, element_to_remove_vector_index);
            self.vector[element_to_remove_vector_index] = last_element_we_should_save;

            self.hashmap.remove(&val);
            self.vector.pop();
            true
        } else {
            false
        }
    }

    /** Get a random element from the set. */
    fn get_random(&self) -> i32 {
        use rand::Rng;

        let index = rand::thread_rng().gen_range(0, (self.vector.len()));

        self.vector[index]
    }
}

/**
 * Your RandomizedSet object will be instantiated and called as such:
 * let obj = RandomizedSet::new();
 * let ret_1: bool = obj.insert(val);
 * let ret_2: bool = obj.remove(val);
 * let ret_3: i32 = obj.get_random();
 */
