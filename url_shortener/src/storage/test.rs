mod storage;

use self::Storage;

struct TestAdapter {}

impl Storage for TestAdapter {
    fn new() -> TestAdapter {
        TestAdapter {}
    }

    fn set(&mut self, data: &str) -> String {
        "hello".to_string()
    }

    fn get(&self, id: &str) -> Option<&String> {
        None
    }
}

[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test() {
      assert!(true, true); 
    }

    #[test]
    fn test_set() {
        adapter = TestAdapter::new();
        assert_eq!("hello", adapter.set());
    }
}
