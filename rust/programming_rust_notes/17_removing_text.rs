fn main() {
    let mut choco = "chocolate".to_string();

    println!("{}", choco.len());
    // this crap takes an ownership, how does it reallocate the buffer?
    // TODO: Know how? Perhaps it just repositions the symbols in current buffer?
    choco.drain(3..6).collect::<String>();
    println!("{}", choco.len());
}
