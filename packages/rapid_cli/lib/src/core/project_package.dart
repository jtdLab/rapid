import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import 'project.dart';
import 'project_dir.dart';
import 'project_file.dart';

/// {@template project_package}
/// Base class for a dart package in a Rapid project.
/// {@endtemplate}
abstract class ProjectPackage extends ProjectDir {
  /// {@macro project_package}
  ProjectPackage(
    super.path, {
    required this.project,
  });

  final Project project;

  PubspecFile get pubspecFile => PubspecFile(package: this);
}

/// {@template melos_file}
/// Abstraction of the `pubspec.yaml` file in package of a Rapid project.
/// {@endtemplate}
class PubspecFile extends ProjectFile {
  /// {@macro melos_file}
  PubspecFile({
    required this.package,
  }) : super('${package.path}/pubspec.yaml');

  final ProjectPackage package;

  /// Adds dependency [name] with [version] to the dependencies field
  ///
  /// in the pubspec.yaml of this package.
  ///
  /// If dependency with [name] already exists only the version gets updated to [version].
  ///
  /// If [version] is null it will be blank.
  void addDependency(String name, [String? version]) {
    final yamlEditor = YamlEditor(file.readAsStringSync());

    yamlEditor.update(['dependencies', name], version);

    file.writeAsStringSync(yamlEditor.toString(), flush: true);
  }

  /// Removes dependency [name] from the dependencies field
  ///
  /// in the pubspec.yaml of this package.
  void removeDependency(String name) {
    final yamlEditor = YamlEditor(file.readAsStringSync());
    yamlEditor.remove(['dependencies', name]);

    file.writeAsStringSync(yamlEditor.toString(), flush: true);
  }

  /// Removes dependency wich contains [pattern] in its name from the dependencies field
  ///
  /// in the pubspec.yaml of this package.
  void removeDependencyByPattern(String pattern) {
    final content = file.readAsStringSync();

    final yaml = loadYaml(content);
    final dependencies = yaml['dependencies'];

    final yamlEditor = YamlEditor(content);
    for (final name in dependencies.keys) {
      if (name.contains(pattern)) {
        yamlEditor.remove(['dependencies', name]);
      }
    }

    file.writeAsStringSync(yamlEditor.toString(), flush: true);
  }
}
