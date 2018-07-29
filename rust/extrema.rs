struct Extrema<'elt> {
  greatest: &'elt i32,
  least: &'elt i32
}

// we can avoid writing this lifetime shit, it's redundunt here
fn find_extrema<'s>(slice: &'s [i32]) -> Extrema<'s> {
  let mut greatest = &slice[0];
  let mut least = &slice[0];

  for i in 1..slice.len() {
    if slice[i] < *least { least = &slice[i]; }
    if slice[i] > *greatest { greatest = &slice[i]; }
  }

  Extrema { greatest: greatest, least: least }
}

let vec = vec![1,2,3,43,31,1,5,12,4,51,52,25,54,43,3,12,3,21,3,21,32,1321,3,2,3,2,1,32,1,3,5,32546,2,6,314,34132,4,321];
let e = find_extrema(&vec[..]);
println!("Greatest is {:?}", e.greatest);
println!("Least is {:?}", e.least);

