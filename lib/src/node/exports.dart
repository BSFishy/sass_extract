import 'package:js/js.dart';

@JS()
class Exports {
  external set extractVariablesFromString(Function function);
  external set extractVariablesFromFile(Function function);
  external set extractVariablesFromStringAsync(Function function);
  external set extractVariablesFromFileAsync(Function function);
}

@JS()
external Exports get exports;
