import 'package:yaml/yaml.dart';

import 'project_file.dart';

/// Thrown when melos.yaml has no name property.
class MelosNameNotFound implements Exception {}

/// {@template melos_file}
/// Abstraction of the `melos.yaml` file in a Rapid project.
/// {@endtemplate}
class MelosFile extends ProjectFile {
  /// {@macro melos_file}
  MelosFile() : super('melos.yaml');

  /// Gets the name of this.
  String get name {
    try {
      final melosYaml = loadYaml(file.readAsStringSync());
      return melosYaml['name'];
    } catch (_) {
      throw MelosNameNotFound();
    }
  }
}
