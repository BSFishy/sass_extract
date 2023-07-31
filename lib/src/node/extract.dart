import '../../sass_extract.dart' as sass_extract;
import 'package:node_interop/js.dart';
import 'package:node_interop/util.dart' hide futureToPromise;
import 'package:js/js.dart';
import 'package:sass/sass.dart';
import 'utils.dart';

@JS()
@anonymous
class StringOptions {
  external String? get path;
  external String? get url;
  external String? get syntax;
}

dynamic extractVariablesFromString(String content, [StringOptions? options]) {
  Syntax syntax = switch (options?.syntax) {
    'sass' => Syntax.sass,
    'css' => Syntax.css,
    _ => Syntax.scss,
  };

  return jsify(sass_extract.extractVariablesFromString(content, path: options?.path, url: options?.url, syntax: syntax));
}

Promise extractVariablesFromStringAsync(String content, [StringOptions? options]) {
  Syntax syntax = switch (options?.syntax) {
    'sass' => Syntax.sass,
    'css' => Syntax.css,
    _ => Syntax.scss,
  };

  return futureToPromise(() async {
    return jsify(await sass_extract.extractVariablesFromStringAsync(content, path: options?.path, url: options?.url, syntax: syntax));
  }());
}

@JS()
@anonymous
class FileOptions {
  external String? get path;
  external String? get syntax;
}

dynamic extractVariablesFromFile(String url, [FileOptions? options]) {
  Syntax syntax = switch (options?.syntax) {
    'sass' => Syntax.sass,
    'css' => Syntax.css,
    _ => Syntax.scss,
  };

  return jsify(sass_extract.extractVariablesFromFile(url, path: options?.path, syntax: syntax));
}

Promise extractVariablesFromFileAsync(String url, [FileOptions? options]) {
  Syntax syntax = switch (options?.syntax) {
    'sass' => Syntax.sass,
    'css' => Syntax.css,
    _ => Syntax.scss,
  };

  return futureToPromise(() async {
    return jsify(await sass_extract.extractVariablesFromFileAsync(url, path: options?.path, syntax: syntax));
  }());
}
