fn main() {
    assert_eq!(format!("{description:.<25}{quantity:2} @ {price:5.2}",
                       price=3.25,
                       quantity=3,
                       description="Maple Turmeric Latte"),
               "Maple Turmeric Latte..... 3 @  3.25");
}
