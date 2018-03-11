fn latin1_to_char(latin1: u8) -> char {
    latin1 as char
}

#[allow(dead_code)]
fn char_to_latin1(c: char) -> Option<u8> {
    if c as u32 <= 0xff {
        Some(c as u8)
    } else {
        None
    }
}

fn main() {
    let some_utf8 = latin1_to_char(74);
    println!("{}", some_utf8);

    // Latin one can contain 255 charaters
    println!("{}", u8::max_value());
}
