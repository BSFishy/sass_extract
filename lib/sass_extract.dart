import 'package:sass/sass.dart';
import 'package:sass/src/ast/sass/statement/stylesheet.dart';
import 'package:sass/src/importer/filesystem.dart';
import 'src/visitor.dart';
import 'src/value.dart';

Map<String, Object?> extractVariablesFromString(String source, {String? path}) {
  var stylesheet = Stylesheet.parseScss(source);
  var visitor = EvaluateVisitor();
  var module = visitor.run(FilesystemImporter(path ?? '.'), stylesheet);
  var variables = module.variables;

  Map<String, Object?> output = {};
  for (final key in variables.keys) {
    output[key] = valueToObject(variables[key]);
  }

  return output;
}
