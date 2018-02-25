fn dont_drop_my_label() {

    struct Label { number: u32 }

    fn print(l: Label) { println!("STAMP: {}", l.number); }
    let l = Label { number : 3 };
    print(l); // this thing will take ownership and destroy my label
    println!("My label number is: {}", l.number); // so this line can do nothing - l is destoyed :(

    // solution is to implement Copy for struct Label.
    // compiler will help you with this.
    // #[derive(Copy, Clone)]
}

fn main() {
    struct Person {
        name: Option<String>,
        birth: i32,
    }

    let mut composers = Vec::new();

    composers.push(Person {
        name: Some("Palestrina".to_string()),
        birth: 1525,
    });

    // This two lines are equivalent
    let first_name = composers[0].name.take();
    // replace doc - https://doc.rust-lang.org/std/mem/fn.replace.html
    // let first_name = std::mem::replace(&mut composers[0].name, None);

    assert_eq!(first_name, Some("Palestrina".to_string()));
    assert_eq!(composers[0].name, None);
}
