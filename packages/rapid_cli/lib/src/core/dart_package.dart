import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/yaml_file.dart';

import 'directory.dart';

/// {@template dart_package}
/// Abstraction of a dart package.
/// {@endtemplate}
abstract class DartPackage implements Directory {
  /// {@macro dart_package}
  factory DartPackage({
    String path = '.',
  }) =>
      DartPackageImpl(path: path);

  @visibleForTesting
  PubspecFile? pubspecFileOverrides;

  /// The pubspec file of the dart package.
  PubspecFile get pubspecFile;

  /// The name of the dart package.
  String packageName();
}

/// Thrown when [PubspecFile.readName] fails to read the `name` property.
class ReadNameFailure implements Exception {}

/// {@template pubspec_file}
/// Abstraction of the pubspec file of a dart package.
/// {@endtemplate}
abstract class PubspecFile implements YamlFile {
  /// {@macro pubspec_file}
  factory PubspecFile({
    String path = '.',
  }) =>
      PubspecFileImpl(path: path);

  /// The `name` property of the pubspec file.
  String readName();

  /// Removes dependency with [name] from the pubspec file.
  void removeDependency(String name);

  /// Removes dependencies that match [pattern] from the pubspec file.
  void removeDependencyByPattern(String pattern);

  /// Adds dependency with [name] and an optional [version] to the pubspec file.
  ///
  /// If dependency with [name] already exists its version is set to [version].
  ///
  /// If [version] is null it results in an empty version:
  ///
  /// ```yaml
  /// dependencies:
  ///   my_dependency:
  /// ```
  void setDependency(String name, {String? version});
}
