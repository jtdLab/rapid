import 'package:rapid_cli/src/core/yaml_file.dart';

/// Thrown when [MelosFile.name] fails to read the name property.
class ReadNameFailure implements Exception {}

/// {@template melos_file}
/// Abstraction of the melos file of a Rapid project.
/// {@endtemplate}
class MelosFile {
  /// {@macro melos_file}
  MelosFile() : _file = YamlFile(name: 'melos');

  /// The underlying yaml file.
  final YamlFile _file;

  String get path => _file.path;

  bool exists() => _file.exists();

  /// The name of the project.
  String name() {
    try {
      return _file.readValue(['name']);
    } catch (_) {
      throw ReadNameFailure();
    }
  }
}
