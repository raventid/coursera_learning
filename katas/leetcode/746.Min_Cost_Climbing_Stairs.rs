impl Solution {
    pub fn min_cost_climbing_stairs(cost: Vec<i32>) -> i32 {
        let mut memo = std::collections::HashMap::new();
        let first = Self::calculate_cost(&cost, 0, &mut memo);
        let second = Self::calculate_cost(&cost, 1, &mut memo);

        if (first > second) {
            second
        } else {
            first
        }
    }

    pub fn calculate_cost(cost: &[i32], shift: usize, memo: &mut std::collections::HashMap<usize, i32>) -> i32 {
        if memo.get(&shift).is_some() { return memo[&shift] }
        let current_step_cost = cost[shift];

        if (shift+1 >= cost.len() - 1) { // edge case for [1, 100] (two elements)
            return current_step_cost
        }

        if (shift+2 == cost.len() - 1) {
            let alternative1 = current_step_cost + cost[shift+1];
            let alternative2 = current_step_cost + cost[shift+2];
            if alternative1 > alternative2 { return alternative2 } else { return alternative1 }
        }

        let one_step_price = Self::calculate_cost(cost, shift + 1, memo);
        let two_step_price = Self::calculate_cost(cost, shift + 2, memo);

        let final_cost = if (one_step_price > two_step_price) {
            current_step_cost + two_step_price
        } else {
            current_step_cost + one_step_price
        };

        memo.insert(shift, final_cost);
        final_cost
    }
}
