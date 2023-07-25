@TestOn('vm')

import 'package:test/test.dart';
import 'package:sass_extract/sass_extract.dart';

void main() {
  test('extracts variable', () {
    expect(extractVariablesFromString('\$test: #000;'), equals({
      'test': '#000',
    }));
  });

  test('extracts multiple variables', () {
    expect(extractVariablesFromString('\$test: #000; \$test2: #fff;'), equals({
      'test': '#000',
      'test2': '#fff',
    }));
  });

  group('extracts variable types', () {
    void testType<T>(String input, T output) {
      expect(extractVariablesFromString('\$value: $input'), equals({
        'value': output
      }));
    }

    test('color', () {
      testType('#000', '#000');
      testType('#FFF', '#FFF');
      testType('black', 'black');
      testType('white', 'white');
      testType('rgb(0, 0, 0, 1)', 'rgb(0, 0, 0)');
    });

    test('string', () {
      void testString(String input) {
        testType("'$input'", input);
      }

      testString('');
      testString('Hello world!');
    });

    test('number', () {
      void testNumber(num input) {
        testType(input.toString(), input);
      }

      testNumber(0);
      testNumber(1);
      testNumber(-1);
      testNumber(1.5);
      testNumber(-1.5);
    });

    test('boolean', () {
      testType('true', true);
      testType('false', false);
    });

    test('arrays', () {
      void testArray(List<String> input) {
        testType('(${input.join(', ')})', input);
      }

      testArray([]);
      testArray(['a', 'b']);
      testArray(['a', 'b', 'c']);
    });

    test('maps', () {
      void testMap(Map<String, String> input) {
        var list = [];
        for (final entry in input.entries) {
          list.add("'${entry.key}': '${entry.value}'");
        }

        testType('(${list.join(', ')})', input);
      }

      testMap({'key': 'value'});
      testMap({'aKey': 'aValue', 'bKey': 'bValue', 'cKey': 'cValue'});
    });
  });
}
