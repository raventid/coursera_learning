use std::rc::Rc;

fn main() {
    let s: Rc<String> = Rc::new("shiratake".to_string());
    let t: Rc<String> = s.clone();
    let u: Rc<String> = s.clone();

    // In this configuration strong ref count has 3
}
