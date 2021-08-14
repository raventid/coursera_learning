// Fibbonacci with Binet's formula. Works only for small numbers. Breaks around 100.
// https://stackoverflow.com/questions/9645193/calculating-fibonacci-number-accurately-in-c
fn main() {
    (0..100).for_each(|number: u32| {
        let value = binet(number as f64);

        println!("For {} Value is {}", number, value);
    })
}

fn binet(number: f64) -> u64 {
    let phi : f64 = (1_f64 + 5_f64.sqrt()) * 0.5;
    let fib = (phi.powf(number) - (1_f64 - phi).powf(number)) / 5_f64.sqrt();
    fib as u64
}