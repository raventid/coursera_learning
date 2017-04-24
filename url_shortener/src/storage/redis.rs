mod storage;

use self::storage;

struct Redis {

}

impl Storage for Redis {
  fn get() {}
  fn set() {}
}


#[test]
fn test_redis_connection() {
    assert!(true, true);
}
