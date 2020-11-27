import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

public class AirportCoffee {
	public static long distanceBetweenGates;
	public static long speedWithoutCoffee;
	public static long speedWithCoffee;
	public static long c;
	public static long waitBeforeDrink;
	public static long timeToDrink;
	public static int numberOfCarts;
	public static long[] carts;

	public static void main(String[] args) throws Exception {

		// Read in all core parameters
		BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
		StringTokenizer token = new StringTokenizer(stdin.readLine());
		distanceBetweenGates = Long.parseLong(token.nextToken());
		speedWithoutCoffee = Long.parseLong(token.nextToken());
		speedWithCoffee = Long.parseLong(token.nextToken());
		waitBeforeDrink = Long.parseLong(token.nextToken());
		timeToDrink = Long.parseLong(token.nextToken());

		// Adjusting distanceBetweenGates this way we won't be using doubles for times
		// Time in units 1/(speedWithoutCoffee*speedWithCoffee) sec.
		c = speedWithoutCoffee*speedWithCoffee;
		distanceBetweenGates *= c;

		// Get cart locations and adjust them by factor speedWithoutCoffee*speedWithCoffee.
		numberOfCarts = Integer.parseInt(stdin.readLine().trim());
		token = new StringTokenizer(stdin.readLine());
		carts = new long[numberOfCarts+1];
		for (int i=0; i<numberOfCarts; i++) {
			carts[i] = speedWithoutCoffee * speedWithCoffee * Long.parseLong(token.nextToken());
		}
		carts[numberOfCarts] = distanceBetweenGates;

		// Set up DP. Yeah, knapsack like stuff.
		long[] dp = new long[numberOfCarts+1];
		Arrays.fill(dp, -1);
		dp[numberOfCarts] = 0;

		int[] next = new int[numberOfCarts+1];
		Arrays.fill(next, -1);

		int j = numberOfCarts;

		// Fill in DP array backwards
		for (int i = numberOfCarts-1; i >= 0; i--) {

			// Here we would run out of coffee if we took coffee from this cart
			long marker = carts[i] + c*(speedWithoutCoffee*waitBeforeDrink + speedWithCoffee*timeToDrink);

			// This is our last coffee since it lasts till the end of route
			if (marker > distanceBetweenGates) {
				dp[i] = getTimeBetweenTwoCarts(i, numberOfCarts);
				continue;
			}

			// Go back to breaking point
			while (j > i && carts[j] > marker) { j--; }
			if (i == j) { j++; }

			dp[i] = getTimeBetweenTwoCarts(i,j) + dp[j];
			next[i] = j;

			// Try the first cart after our marker
			if (j+1 <= numberOfCarts && getTimeBetweenTwoCarts(i, j+1) + dp[j+1] < dp[i]) {
				dp[i] = getTimeBetweenTwoCarts(i,j+1) + dp[j+1];
				next[i] = j+1;
			}
		}

		List<Integer> res = buildFinalResults(next);

		System.out.println(res.size());

		for (int i = 0; i < res.size(); i++) {
			boolean lastIteration = i == res.size()-1;
			System.out.print(res.get(i));

			if (!lastIteration) {
				System.out.print(" ");
			}
		}
	}

	private static List<Integer> buildFinalResults(int[] dp) {
		ArrayList<Integer> res = new ArrayList<Integer>();

		if (numberOfCarts > 0) {
			res.add(0);

			int i = 0;
			while (dp[i] != -1 && dp[i] != numberOfCarts) {
				res.add(dp[i]);
				i = dp[i];
			}
		}

		return res;
	}

	// Returns the time for going from stop i to j only taking coffee at i.
	public static long getTimeBetweenTwoCarts(int i, int j) {
		long diff = carts[j] - carts[i];
		long full = c*(speedWithoutCoffee*waitBeforeDrink + speedWithCoffee*timeToDrink);

		// Coffee is done
		if (diff >= full) {
			return waitBeforeDrink*c + timeToDrink*c + (diff - full)/speedWithoutCoffee;
		}

		// We get to start timeToDrinking it
		if (diff >= c*speedWithoutCoffee*waitBeforeDrink) {
			return waitBeforeDrink*c + (diff - c*speedWithoutCoffee*waitBeforeDrink)/speedWithCoffee;
		}

		return diff/speedWithoutCoffee;
	}
}
