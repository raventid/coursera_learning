// Cannot run test for this file :(

fn summator() -> i32 {
    2
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_summator() {
        assert_eq!(summator(), 2);
    }
}
