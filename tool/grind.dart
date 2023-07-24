import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:charcode/charcode.dart';
import 'package:source_span/source_span.dart';
import 'package:cli_pkg/cli_pkg.dart' as pkg;
import 'package:grinder/grinder.dart';

void main(args) {
  pkg.humanName.value = 'sass_extract';
  pkg.executables.value = {'sass_extract': 'bin/sass_extract.dart'};
  pkg.jsRequires.value = [
    pkg.JSRequire('fs', target: pkg.JSRequireTarget.node),
  ];
  pkg.jsModuleMainLibrary.value = "lib/src/node.dart";
  pkg.npmPackageJson.fn = () =>
      json.decode(File("package/package.json").readAsStringSync())
          as Map<String, dynamic>;
  pkg.npmReadme.fn = () => _readAndResolveMarkdown("package/README.npm.md");
  pkg.jsEsmExports.value = {
    'extractVariablesFromString',
  };
  pkg.npmAdditionalFiles.fn = _fetchJSTypes;

  pkg.addNpmTasks();
  pkg.addGithubTasks();
  pkg.addStandaloneTasks();

  grind(args);
}

@DefaultTask()
build() {
  Pub.build();
}

@Task()
clean() => defaultClean();

final _readAndResolveRegExp = RegExp(
    r"^<!-- +#include +([^\s]+) +"
    '"([^"\n]+)"'
    r" +-->$",
    multiLine: true);

/// Reads a Markdown file from [path] and resolves include directives.
///
/// Include directives have the syntax `"<!-- #include" PATH HEADER "-->"`,
/// which must appear on its own line. PATH is a relative file: URL to another
/// Markdown file, and HEADER is the name of a header in that file whose
/// contents should be included as-is.
String _readAndResolveMarkdown(String path) => File(path)
    .readAsStringSync()
    .replaceAllMapped(_readAndResolveRegExp, (match) {
  late String included;
  try {
    included = File(p.join(p.dirname(path), p.fromUri(match[1])))
        .readAsStringSync();
  } catch (error) {
    _matchError(match, error.toString(), url: p.toUri(path));
  }

  late Match headerMatch;
  try {
    headerMatch = "# ${match[2]}".allMatches(included).first;
  } on StateError {
    _matchError(match, "Could not find header.", url: p.toUri(path));
  }

  var headerLevel = 0;
  var index = headerMatch.start;
  while (index >= 0 && included.codeUnitAt(index) == $hash) {
    headerLevel++;
    index--;
  }

  // The section goes until the next header of the same level, or the end
  // of the document.
  var sectionEnd = included.indexOf("#" * headerLevel, headerMatch.end);
  if (sectionEnd == -1) sectionEnd = included.length;

  return included.substring(headerMatch.end, sectionEnd).trim();
});

/// Throws a nice [SourceSpanException] associated with [match].
void _matchError(Match match, String message, {Object? url}) {
  var file = SourceFile.fromString(match.input, url: url);
  throw SourceSpanException(message, file.span(match.start, match.end));
}

Map<String, String> _fetchJSTypes() {
  final files = {
    'index.d.ts': 'package/index.d.ts'
  };

  return {
    for (final entry in files.entries)
      entry.key: File(entry.value).readAsStringSync()
  };
}
