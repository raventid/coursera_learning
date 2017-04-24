mod storage;
trait Storage {
    fn set(&mut self, data: &str) -> String;
    fn get(&self, id: &str) -> Option<&String>;
}
