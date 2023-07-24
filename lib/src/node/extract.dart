import '../../sass_extract.dart' as sass_extract;
import 'dart:js_util';

dynamic extractVariablesFromString(String content, {String? path}) {
  return jsify(sass_extract.extractVariablesFromString(content, path: path));
}
