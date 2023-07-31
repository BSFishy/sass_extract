import 'package:path/path.dart' as p;
import 'package:sass/sass.dart';
import 'package:sass/src/ast/sass/statement/stylesheet.dart';
import 'package:sass/src/async_import_cache.dart';
import 'package:sass/src/import_cache.dart';
import 'src/io.dart';
import 'src/async_visitor.dart';
import 'src/visitor.dart';
import 'src/value.dart';

Map<String, Object?> extractVariablesFromString(String source, {String? path, Object? url, Syntax? syntax}) {
  final stylesheet = Stylesheet.parse(source, syntax ?? Syntax.scss, url: url);
  final importer = FilesystemImporter(path ?? '.');

  final importCache = ImportCache(importers: [importer]);
  final visitor = EvaluateVisitor(importCache: importCache);
  final module = visitor.run(importer, stylesheet);
  final variables = module.variables;

  Map<String, Object?> output = {};
  for (final key in variables.keys) {
    output[key] = valueToObject(variables[key]);
  }

  return output;
}

Map<String, Object?> extractVariablesFromFile(String url, {String? path, Syntax? syntax}) {
  final source = readFile(url);

  return extractVariablesFromString(source, path: path ?? p.dirname(source), url: url, syntax: syntax);
}

Future<Map<String, Object?>> extractVariablesFromStringAsync(String source, {String? path, Object? url, Syntax? syntax}) async {
  final stylesheet = Stylesheet.parse(source, syntax ?? Syntax.scss, url: url);
  final importer = FilesystemImporter(path ?? '.');

  final importCache = AsyncImportCache(importers: [importer]);
  final visitor = AsyncEvaluateVisitor(importCache: importCache);
  final module = await visitor.run(importer, stylesheet);
  final variables = module.variables;

  Map<String, Object?> output = {};
  for (final key in variables.keys) {
    output[key] = valueToObject(variables[key]);
  }

  return output;
}

Future<Map<String, Object?>> extractVariablesFromFileAsync(String url, {String? path, Syntax? syntax}) async {
  final source = readFile(url);

  return await extractVariablesFromStringAsync(source, path: path ?? p.dirname(source), url: url, syntax: syntax);
}
