import 'package:rapid_cli/src/core/file.dart';

import 'yaml_file_impl.dart';

/// Thrown when [YamlFile.removeValue] is called with [path] that does not reference a value.
class InvalidPath implements Exception {}

/// {@template yaml_file}
/// Abstraction of a yaml file.
/// {@endtemplate}
abstract class YamlFile implements File {
  /// {@macro yaml_file}
  factory YamlFile({
    String path = '.',
    required String name,
  }) =>
      YamlFileImpl(path: path, name: name);

  /// Reads the value at [path].
  ///
  /// Path must have length 1.
  T readValue<T extends Object?>(Iterable<Object?> path);

  /// Removes the value at [path].
  void removeValue(Iterable<Object?> path);

  /// Sets [value] at [path].
  ///
  /// If [value] is `null` the output differs depending on [blankIfValueNull].
  ///
  /// a) [blankIfValueNull] = false
  /// ```yaml
  /// my_value: null
  /// ```
  /// b) [blankIfValueNull] = true
  /// ```yaml
  /// my_value:
  /// ```
  void setValue<T extends Object?>(
    Iterable<Object?> path,
    T? value, {
    bool blankIfValueNull = false,
  });
}
