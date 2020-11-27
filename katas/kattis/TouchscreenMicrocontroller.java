import java.util.Scanner;

public class TouchscreenMicrocontroller {
    public static void main(String [] args) {
        Scanner scan = new Scanner(System.in);

        int numberOfTests = scan.nextInt();
        for (int i = 0; i < numberOfTests; i++) {
            int numberOfRows = scan.nextInt();
            int numberOfColumns = scan.nextInt();
            int [][] screen = new int[numberOfRows][numberOfColumns];

            scan.nextLine();
            for (int row = 0; row < numberOfRows; row++) {
                String rowString = scan.nextLine();
                char[] arrayOfZeroesAndOnes = rowString.toCharArray();
                for (int column = 0; column < arrayOfZeroesAndOnes.length; column++) {
                   screen[row][column] = arrayOfZeroesAndOnes[column] - '0';
                }
            }

            try {
                char[][] result = runTest(screen, numberOfRows, numberOfColumns);

                for (char[] row : result) {
                    for (char c : row) {
                        System.out.print(c);
                    }

                    System.out.println("");
                }
            }
            catch(Exception e) {
                System.out.println("impossible");
            }

            System.out.println("----------");
        }
    }

    private static char[][] runTest(int[][] screen, int numberOfRows, int numberOfColumns) {
        char [][] result = new char[numberOfRows][numberOfColumns];
       
        for (int row = 0; row < numberOfRows; row++) {
            for (int column = 0; column < numberOfColumns; column++) {
                int currElem = screen[row][column];

                boolean otherOneOnRow = isOtherElementOnRowEqualsToOne(screen, numberOfColumns, row, column);
                boolean otherOneOnColumn = isOtherElementOnColumnEqualsToOne(screen, numberOfRows, row, column);

                if (currElem == 1) {
                    if (otherOneOnRow && otherOneOnColumn) {
                        result[row][column] = 'I';
                    } else {
                        result[row][column] = 'P';
                    }
                } else {
                    if (otherOneOnRow && otherOneOnColumn) {
                        throw new IllegalArgumentException();
                    } else {
                        result[row][column] = 'N';
                    }
                }
            }
        }

        return result;
    }

    private static boolean isOtherElementOnRowEqualsToOne(int[][] screen, int numberOfColumns, int targetRow, int targetColumn) {
        for (int column = 0; column < numberOfColumns; column++) {
            boolean sameElement = targetColumn == column;
            int elem = screen[targetRow][column];

            if (!sameElement && elem == 1) { return true; }
        }

        return false;
    }

    private static boolean isOtherElementOnColumnEqualsToOne(int[][] screen, int numberOfRows, int targetRow, int targetColumn) {
        for (int row = 0; row < numberOfRows; row++) {
            boolean sameElement = targetRow == row;
            int elem = screen[row][targetColumn];

            if (!sameElement && elem == 1) { return true; }
        }

        return false;
    }
}



// 3
// 4 3
// 110
// 000
// 110
// 000
// 2 3
// 101
// 000
// 2 2
// 10
// 01
