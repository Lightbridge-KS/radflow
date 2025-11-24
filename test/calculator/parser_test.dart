import 'package:flutter_test/flutter_test.dart';
import 'package:radflow/services/calculator/shared/_parser.dart';

void main() {
  group('parseStrToNumOrList', () {
    group('Single numeric value', () {
      test('parses integer string to double', () {
        expect(parseStrToNumOrList("42"), equals(42.0));
      });

      test('parses decimal string to double', () {
        expect(parseStrToNumOrList("42.5"), equals(42.5));
      });

      test('parses negative number to double', () {
        expect(parseStrToNumOrList("-10.5"), equals(-10.5));
      });

      test('parses zero to double', () {
        expect(parseStrToNumOrList("0"), equals(0.0));
      });

      test('parses string with leading/trailing whitespace', () {
        expect(parseStrToNumOrList("  42.5  "), equals(42.5));
      });
    });

    group('Multiple numeric values', () {
      test('parses comma-separated values to List<double>', () {
        expect(
          parseStrToNumOrList("1.1, 2.2, 3.3"),
          equals([1.1, 2.2, 3.3]),
        );
      });

      test('parses space-separated values to List<double>', () {
        expect(
          parseStrToNumOrList("1 2 3"),
          equals([1.0, 2.0, 3.0]),
        );
      });

      test('parses values with mixed comma and space separators', () {
        expect(
          parseStrToNumOrList("1.5, 2.5 3.5"),
          equals([1.5, 2.5, 3.5]),
        );
      });

      test('parses values with multiple spaces', () {
        expect(
          parseStrToNumOrList("1   2   3"),
          equals([1.0, 2.0, 3.0]),
        );
      });

      test('parses values with leading/trailing whitespace', () {
        expect(
          parseStrToNumOrList("  1.1, 2.2, 3.3  "),
          equals([1.1, 2.2, 3.3]),
        );
      });

      test('parses negative numbers in list', () {
        expect(
          parseStrToNumOrList("-1.5, 2.5, -3.5"),
          equals([-1.5, 2.5, -3.5]),
        );
      });

      test('parses list with two values', () {
        expect(
          parseStrToNumOrList("10.5, 20.3"),
          equals([10.5, 20.3]),
        );
      });
    });

    group('Invalid input', () {
      test('returns empty string for invalid text', () {
        expect(parseStrToNumOrList("invalid"), equals(""));
      });

      test('returns empty string for empty string', () {
        expect(parseStrToNumOrList(""), equals(""));
      });

      test('returns empty string for whitespace only', () {
        expect(parseStrToNumOrList("   "), equals(""));
      });

      test('returns empty string for mixed valid and invalid values', () {
        expect(parseStrToNumOrList("1.5, invalid, 2.5"), equals(""));
      });

      test('returns empty string for text with numbers', () {
        expect(parseStrToNumOrList("abc123"), equals(""));
      });

      test('returns empty string for special characters', () {
        expect(parseStrToNumOrList(r"@#$%"), equals(""));
      });
    });

    group('Edge cases', () {
      test('parses very large number', () {
        expect(parseStrToNumOrList("999999999.99"), equals(999999999.99));
      });

      test('parses very small decimal', () {
        expect(parseStrToNumOrList("0.0001"), equals(0.0001));
      });

      test('parses scientific notation', () {
        expect(parseStrToNumOrList("1e5"), equals(100000.0));
      });

      test('parses list with scientific notation', () {
        expect(
          parseStrToNumOrList("1e2, 2e3"),
          equals([100.0, 2000.0]),
        );
      });

      test('handles comma at the end', () {
        expect(
          parseStrToNumOrList("1, 2,"),
          equals([1.0, 2.0]),
        );
      });

      test('handles multiple commas between values', () {
        expect(
          parseStrToNumOrList("1,, 2"),
          equals([1.0, 2.0]),
        );
      });
    });
  });
}
