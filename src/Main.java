import java.util.ArrayList;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
        // Зчитування N рядків
        ArrayList<String> lines = readNLines();

        // Виведення зчитаних рядків
        System.out.println("Entered lines: ");
        for (String line : lines) {
            System.out.println(line);
        }
    }

    // Метод для зчитування N рядків
    private static ArrayList<String> readNLines() {
        Scanner scanner = new Scanner(System.in);
        ArrayList<String> lines = new ArrayList<>();
        int maxLines = 100;
        int count = 0;

        System.out.println("Enter the lines (use Ctrl+D to finish): ");

        // Зчитування рядків, поки їх кількість не більше за 100 або EOF
        while (scanner.hasNextLine() && lines.size() < maxLines) {
            String line = scanner.nextLine();
            count++;
            if (line.length() > 255) {
                System.out.println("The " + count + "-th string exceeds 255 characters");
            }
            else {
                lines.add(line);
            }
        }
        return lines;
    }
}
