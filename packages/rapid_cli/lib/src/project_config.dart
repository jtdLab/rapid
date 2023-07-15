import 'dart:io';

import 'package:ansi_styles/ansi_styles.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/utils.dart';
import 'package:yaml/yaml.dart';

import 'exception.dart';
import 'validation.dart';

@immutable
class RapidProjectConfig {
  RapidProjectConfig({
    required this.path,
    required this.name,
  }) {
    _validate();
  }

  factory RapidProjectConfig.fromYaml(
    Map<Object?, Object?> yaml, {
    required String path,
  }) {
    final rapidMap = assertKeyIsA<Map<Object?, Object?>>(
      key: 'rapid',
      map: yaml,
    );

    final name = assertKeyIsA<String>(
      key: 'name',
      map: rapidMap,
      path: 'rapid',
    );
    // TODO share ?
    final isValidDartPackageNameRegExp =
        RegExp(r'^[a-z][a-z\d_-]*$', caseSensitive: false);
    if (!isValidDartPackageNameRegExp.hasMatch(name)) {
      throw RapidConfigException(
        'The name $name is not a valid dart package name',
      );
    }

    return RapidProjectConfig(
      path: path,
      name: name,
    );
  }

  // TODO rm?
  RapidProjectConfig.empty()
      : this(
          name: '______rapid______',
          path: Directory.current.path,
        );

  /// Loads the [RapidProjectConfig] for the project at [projectRoot].
  static Future<RapidProjectConfig> fromProjectRoot(
    Directory projectRoot,
  ) async {
    final pubspecYamlFile = File(p.join(projectRoot.path, 'pubspec.yaml'));
    if (!pubspecYamlFile.existsSync()) {
      throw UnresolvedProject(
        multiLine([
          'Found no pubspec.yaml file in "${projectRoot.path}".',
          '',
          'You must have a ${AnsiStyles.bold('pubspec.yaml')} file in the root '
              'of your project.',
          '',
          // TODO: add link
          'For more information, see: '
              'TODO',
        ]),
      );
    }

    Object? rapidYamlContents;
    try {
      rapidYamlContents = loadYamlNode(
        await pubspecYamlFile.readAsString(),
        sourceUrl: pubspecYamlFile.uri,
      ).toPlainObject();
    } on YamlException catch (error) {
      throw RapidConfigException('Failed to parse pubspec.yaml:\n$error');
    }

    if (rapidYamlContents is! Map<Object?, Object?>) {
      throw RapidConfigException('pubspec.yaml must contain a YAML map.');
    }

    return RapidProjectConfig.fromYaml(
      rapidYamlContents,
      path: projectRoot.path,
    )..validatePhysicalProject();
  }

  /// Handles the case where a project could not be found in the [current]
  /// or a parent directory by throwing an error with a helpful message.
  static Future<Never> handleProjectNotFound(Directory current) async {
    throw UnresolvedProject(
      multiLine([
        'Your current directory does not appear to be within a Rapid '
            'project.',
        '',
        // TODO: add link
        'For setting up a project, see: '
            'TODO',
      ]),
    );
  }

  /// The absolute path to the project folder.
  final String path;

  /// The name of the rapid project – used by IDE documentation.
  final String name;

  /// Validates this project configuration for consistency.
  void _validate() {
    final projectDir = Directory(path);
    if (!projectDir.isAbsolute) {
      throw RapidConfigException('path must be an absolute path but got $path');
    }
  }

  /// Validates the physical project on the file system.
  void validatePhysicalProject() {
    if (!Directory(path).existsSync()) {
      throw RapidConfigException(
        'The path $path does not point to a directory',
      );
    }
  }

  bool get isEmpty =>
      name == '______rapid______' && path == Directory.current.path;

  @override
  bool operator ==(Object other) =>
      other is RapidProjectConfig &&
      runtimeType == other.runtimeType &&
      other.path == path &&
      other.name == name;

  @override
  int get hashCode => runtimeType.hashCode ^ path.hashCode ^ name.hashCode;

  Map<String, Object> toJson() {
    return {
      'name': name,
      'path': path,
    };
  }
}

/// An exception thrown when a Rapid project could not be resolved.
class UnresolvedProject extends RapidException {
  UnresolvedProject(this.message);

  final String message;

  @override
  String toString() => message;
}
