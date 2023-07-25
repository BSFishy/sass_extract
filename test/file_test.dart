@TestOn('vm')

import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:sass_extract/sass_extract.dart';

void main() {
  test('includes files', () async {
    await d.file('test.scss', '\$value: #fff;').create();

    expect(extractVariablesFromString("@import 'test';", path: d.path('.')), equals({ 'value': '#fff' }));
  });
}
