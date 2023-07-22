import 'exception.dart';

// TODO not clean as its only used to validate pubspec.yaml name
T assertNotNull<T>(T? value) {
  if (value == null) {
    throw ValidationException._('Value cannot be null');
  }

  return value;
}

T assertIsA<T>({
  int? index,
  Object? key,
  String? path,
  required Object? value,
}) {
  if (value is T) return value;

  throw RapidConfigException.invalidType(
    index: index,
    key: key,
    path: path,
    expectedType: T,
    value: value,
  );
}

T assertKeyIsA<T>({
  String? path,
  required Object key,
  required Map<Object?, Object?> map,
}) {
  if (null is! T && !map.containsKey(key)) {
    throw RapidConfigException.missingKey(key: key, path: path);
  }

  return assertIsA<T>(value: map[key], key: key);
}

class RapidConfigException extends RapidException {
  RapidConfigException(super.message);

  RapidConfigException.missingKey({
    Object? key,
    int? index,
    String? path,
  }) : this(
          '${_descriptor(key: key, index: index, path: path)} '
          'is required but missing',
        );

  RapidConfigException.invalidType({
    required Object expectedType,
    Object? key,
    int? index,
    required Object? value,
    String? path,
  }) : this(
          '${_descriptor(key: key, index: index, path: path)} '
          'is expected to be a $expectedType but got $value',
        );

  static String _descriptor({Object? key, String? path, int? index}) {
    if (key != null) {
      if (path == null) return 'The property $key';
      return 'The property $key at $path';
    }
    if (index != null) {
      if (path == null) return 'The index $index';
      return 'The index $index at $path';
    }

    throw UnimplementedError();
  }

  @override
  String toString() => 'pubspec.yaml: $message';
}

class ValidationException extends RapidException {
  ValidationException._(super.message);
}
