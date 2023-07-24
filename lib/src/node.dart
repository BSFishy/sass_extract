import 'node/exports.dart';
import 'node/extract.dart';
import 'node/utils.dart';

/// The entrypoint for the Node.js module.
///
/// This sets up exports that can be called from JS.
void main() {
  exports.extractVariablesFromString = allowInteropNamed('sass_extract.extractVariablesFromString', extractVariablesFromString);
}
