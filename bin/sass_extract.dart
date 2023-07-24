import 'package:sass_extract/sass_extract.dart' as sass_extract;
import 'package:sass_extract/src/io.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  var parser = ArgParser();

  parser
    ..addFlag('help', abbr: 'h', help: 'display help')
    ..addOption('output', abbr: 'o', help: 'output path', valueHelp: 'path')
    ..addFlag('quiet', abbr: 'q', help: 'suppress non-critical output');

  var results = parser.parse(arguments);
  if (results['help']) {
    print('Usage: sass_extract [options] <input.scss>');
    print('');
    print('OPTIONS');
    print(parser.usage);
    return;
  }

  if (results.rest.length != 1) {
    print('Expected 1 and only 1 input file');
    exitCode = 1;
    return;
  }

  final quiet = results['quiet'] as bool;

  final inputPath = results.rest.first;
  final outputPath = (results['output'] as String?) ?? setExtension(inputPath, '.json');
  final importPath = dirname(inputPath);

  final contents = readFile(inputPath);

  Map<String, Object?> variables;
  try {
    variables = sass_extract.extractVariablesFromString(contents, path: importPath);
  } catch (error) {
    print(error);

    exitCode = 1;
    return;
  }

  final json = jsonEncode(variables);

  // final outputFile = File(outputPath);
  writeFile(outputPath, '$json\n');

  if (!quiet) {
    print('Wrote to $outputPath');
  }
}
