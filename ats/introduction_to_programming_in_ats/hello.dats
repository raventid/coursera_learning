// Compile with `patscc -o hw hello.dats`
// Run with `./hw`
// To remove all ATS2 `tmp` files `rm -fv *_[sd]ats.[co]`

// If you forget:

// SPC-c-C and puts `patscc -o hw hello.dats && ./hw` to setup compilation
// SPC-c-r to recompile

//
val _ = print ("Hello, world!\n")
//
// You cannot use `_` variable in your code
// val _ = print (_)
//
implement main0 () = () // a dummy for [main]
//