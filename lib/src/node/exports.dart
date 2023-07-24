import 'package:js/js.dart';

@JS()
class Exports {
  external set extractVariablesFromString(Function function);
}

@JS()
external Exports get exports;