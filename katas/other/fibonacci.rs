// Fibbonacci with Binet's formula
// bad take, it does not work
fn main() {
    (0..100).for_each(|number: u32| {
        let value = binet(number);

        println!("For {} Value is {}", number, value);
    })
}

fn binet(number: u32) -> i32 {
    let sr_5 = (5 as f32).sqrt() + 1.;
    let result = (1. + sr_5 / 2.).powf(number as f32) / sr_5;
    result as i32
}
