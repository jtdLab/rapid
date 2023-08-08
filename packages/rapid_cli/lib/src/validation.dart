import 'exception.dart';

/// Asserts that the provided [value] is of type [T].
///
/// The [index], [key] and [path] parameters, if provided,
/// give additional context about the location of the [value].
///
/// Throws [RapidConfigException] if [key] is not of type [T].
T assertIsA<T>({
  required Object? value,
  int? index,
  Object? key,
  String? path,
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

/// Asserts that the value associated with the provided [key] in the given [map]
/// is of type [T].
///
/// The [path] parameter, if provided,
/// gives additional context about the location of the [key].
///
/// Throws [RapidConfigException] if [key] is not of type [T] or missing.
T assertKeyIsA<T>({
  required Object key,
  required Map<Object?, Object?> map,
  String? path,
}) {
  if (null is! T && !map.containsKey(key)) {
    throw RapidConfigException.missingKey(key: key, path: path);
  }

  return assertIsA<T>(value: map[key], key: key);
}

/// {@template rapid_config_exception}
/// An exception for handling project configuration related errors.
/// {@endtemplate}
class RapidConfigException extends RapidException {
  /// {@macro rapid_config_exception}
  RapidConfigException(super.message);

  /// Create a [RapidConfigException] indicating [key] is missing.
  RapidConfigException.missingKey({
    Object? key,
    int? index,
    String? path,
  }) : this(
          '${_descriptor(key: key, index: index, path: path)} '
          'is required but missing',
        );

  /// Create a [RapidConfigException] indicating [value] did not
  /// match [expectedType].
  RapidConfigException.invalidType({
    required Object expectedType,
    required Object? value,
    Object? key,
    int? index,
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
