import '../../sass_extract.dart' as sass_extract;
import 'dart:js_util';
import 'package:js/js.dart';

@JS()
@anonymous
class Options {
  external String? get path;
}

dynamic extractVariablesFromString(String content, [Options? options]) {
  return jsify(sass_extract.extractVariablesFromString(content, path: options?.path));
}
