import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'directory.dart';
import 'yaml_file.dart';

/// {@template dart_package}
/// Abstraction of a dart package.
/// {@endtemplate}
class DartPackage extends Directory {
  /// {@macro dart_package}
  DartPackage({
    super.path,
    PubspecFile? pubspecFile,
  }) : _pubspecFile = pubspecFile;

  final PubspecFile? _pubspecFile;

  /// The pubspec file of the dart package.
  late final PubspecFile pubspecFile = _pubspecFile ?? PubspecFile(path: path);

  /// The name of the dart package.
  String packageName() => pubspecFile.readName();
}

/// Thrown when [PubspecFile.readName] fails to read the `name` property.
class ReadNameFailure implements Exception {}

/// {@template pubspec_file}
/// Abstraction of the pubspec file of a dart package.
/// {@endtemplate}
class PubspecFile extends YamlFile {
  /// {@macro pubspec_file}
  PubspecFile({super.path}) : super(name: 'pubspec');

  /// The `name` property of the pubspec file.
  String readName() {
    try {
      return readValue(['name']);
    } catch (_) {
      throw ReadNameFailure();
    }
  }

  /// Removes dependency with [name] from the pubspec file.
  void removeDependency(String name) => removeValue(['dependencies', name]);

  /// Removes dependencies that match [pattern] from the pubspec file.
  void removeDependencyByPattern(String pattern) {
    final dependencies = readValue(['dependencies']);

    for (final dependency in (dependencies as YamlMap)
        .entries
        .map((e) => (e.key as String).split(':').first.trim())
        .where((e) => e.contains(pattern))) {
      removeDependency(dependency);
    }
  }

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
  void setDependency(String name, {String? version}) =>
      setValue(['dependencies', name], version, blankIfValueNull: true);

  @protected
  @override
  T readValue<T extends Object?>(Iterable<Object?> path);

  @protected
  @override
  void removeValue(Iterable<Object?> path);

  @protected
  @override
  void setValue<T extends Object?>(
    Iterable<Object?> path,
    T? value, {
    bool blankIfValueNull = false,
  });
}
