import java.util.Scanner;

public class TemperatureBelowZero {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);

        int n = scan.nextInt();
        int temperatureBelowZero = 0;

        for (int i = 0; i < n; i++) {
            int temperature = scan.nextInt();
            if (temperature < 0) temperatureBelowZero++;
        }

        scan.close();

        System.out.println(temperatureBelowZero);
    }
}
