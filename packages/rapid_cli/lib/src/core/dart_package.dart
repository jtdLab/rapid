import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';

import 'yaml_file.dart';

/// {@template dart_package}
/// Abstraction of a dart package.
/// {@endtemplate}
class DartPackage {
  /// {@macro dart_package}
  DartPackage({String path = '.'}) : _directory = Directory(p.normalize(path));

  /// The underlying directory.
  final Directory _directory;

  void delete() => _directory.deleteSync();

  bool exists() => _directory.existsSync();

  String get path => _directory.path;

  /// The pubspec file of this dart package.
  late final PubspecFile pubspecFile = PubspecFile(path: path);
}

/// {@template pubspec_file}
/// Abstraction of the pubspec file of a dart package.
/// {@endtemplate}
class PubspecFile {
  /// {@macro pubspec_file}
  PubspecFile({String path = '.'})
      : _file = YamlFile(path: path, name: 'pubspec');

  /// The underlying yaml file.
  final YamlFile _file;

  String get path => _file.path;

  /// Removes dependency with [name].
  void removeDependency(String name) =>
      _file.removeValue(['dependencies', name]);

  /// Removes dependencies that match [pattern].
  void removeDependencyByPattern(String patttern) {
    // TODO impl
    throw UnimplementedError();
  }

  /// Adds dependency with [name] and an optional [version].
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
      _file.setValue(['dependencies', name], version, blankIfValueNull: true);
}
