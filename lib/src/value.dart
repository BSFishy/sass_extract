import 'package:sass/sass.dart';
import 'package:sass/src/visitor/interface/value.dart';

Object? valueToObject(Value? value) {
  return value?.accept(ObjectValueVisitor());
}

class ObjectValueVisitor implements ValueVisitor<Object?> {
  @override
  Object? visitBoolean(SassBoolean value) {
    return value.value;
  }

  @override
  Object? visitCalculation(SassCalculation value) {
    return value.toString();
  }

  @override
  Object? visitColor(SassColor value) {
    return value.toString();
  }

  @override
  Object? visitFunction(SassFunction value) {
    // TODO: implement visitFunction
    throw UnimplementedError();
  }

  @override
  Object? visitList(SassList value) {
    var list = [];
    for (final item in value.asList) {
      list.add(valueToObject(item));
    }

    return list;
  }

  @override
  Object? visitMap(SassMap value) {
    var result = {};
    final contents = value.contents;
    for (final key in contents.keys) {
      result[valueToObject(key)] = valueToObject(contents[key]);
    }

    return result;
  }

  @override
  Object? visitNull() {
    return null;
  }

  @override
  Object? visitNumber(SassNumber value) {
    if (value.hasUnits) {
      return value.toString();
    }

    return value.value;
  }

  @override
  Object? visitString(SassString value) {
    return value.text;
  }
}
