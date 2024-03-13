import java.util.ArrayList;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
        // Зчитування підрядка
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter the substring to be found: ");
        String findingSubstring = scanner.nextLine();

        // Перевірка, чи введено підрядок
        if (!findingSubstring.isEmpty()) {
            // Зчитування N рядків
            ArrayList<String> lines = readNLines();

            // Пошук входжень підрядка та виведення результатів
            int[][] result = findingSubstring(lines, findingSubstring);
            //System.out.println("Substring occurrences: ");
            for (int i = 0; i < result.length; i++) {
                System.out.println(result[i][0] + " occurrences in line " + result[i][1]);
            }
        } else {
            System.out.println("An empty substring was entered");
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

    // Метод для пошуку входжень підрядка у кожному рядку
    private static int[][] findingSubstring(ArrayList<String> lines, String substring) {
        int[][] result = new int[lines.size()][2];

        for (int i = 0; i < lines.size(); i++) {
            String line = lines.get(i);
            int count = countSubstring(line, substring);
            result[i][0] = count;
            result[i][1] = i;
        }
        return result;
    }

    // Метод, що рахує входження підрядка
    private static int countSubstring(String line, String substring) {
        int count = 0;
        int lengthOfSubstring = substring.length();
        int lengthOfLine = line.length();

        // Проходимося по рядку
        for (int i = 0; i <= lengthOfLine - lengthOfSubstring; i++) {
            // Витягуємо підрядок довжиною підрядка для порівняння
            String sub = line.substring(i, i + lengthOfSubstring);

            // Порівнюємо підрядок з шуканим підрядком
            if (sub.equals(substring)) {
                count++;
                i += lengthOfSubstring - 1;
            }
        }
        return count;
    }

}
