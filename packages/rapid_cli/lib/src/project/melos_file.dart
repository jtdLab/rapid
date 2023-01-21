import 'package:rapid_cli/src/core/yaml_file.dart';

import 'project.dart';

/// Thrown when [MelosFile.name] fails to read the `name` property.
class ReadNameFailure implements Exception {}

/// {@template melos_file}
/// Abstraction of the melos file of a Rapid project.
///
/// Location: `melos.yaml`
/// {@endtemplate}
class MelosFile extends ProjectEntity {
  /// {@macro melos_file}
  MelosFile({
    required Project project,
  }) : _yamlFile = YamlFile(path: project.path, name: 'melos');

  final YamlFile _yamlFile;

  @override
  String get path => _yamlFile.path;

  @override
  bool exists() => _yamlFile.exists();

  String name() {
    try {
      return _yamlFile.readValue(['name']);
    } catch (_) {
      throw ReadNameFailure();
    }
  }
}
