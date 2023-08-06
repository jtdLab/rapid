import 'dart:io';

import 'package:ansi_styles/ansi_styles.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'exception.dart';
import 'utils.dart';
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

    if (!dartPackageRegExp.hasMatch(name)) {
      throw RapidConfigException(
        'The name $name is not a valid dart package name',
      );
    }

    return RapidProjectConfig(
      path: path,
      name: name,
    );
  }

  /// Loads the [RapidProjectConfig] for the project at [projectRoot].
  static Future<RapidProjectConfig> fromProjectRoot(
    Directory projectRoot,
  ) async {
    final pubspecYamlFile = File(p.join(projectRoot.path, 'pubspec.yaml'));
    if (!pubspecYamlFile.existsSync()) {
      throw UnresolvedProject(
        // TODO: is link correct ?
        multiLine([
          'Found no pubspec.yaml file in "${projectRoot.path}".',
          '',
          'You must have a ${AnsiStyles.bold('pubspec.yaml')} file in the root ',
          'of your project.',
          '',
          'For more information, see: ',
          'https://docs.page/jtdLab/rapid/cli/create',
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
      throw RapidConfigException('could not be parsed and failed.\n$error');
    }

    if (rapidYamlContents is! Map<Object?, Object?>) {
      throw RapidConfigException('must contain a YAML map.');
    }

    return RapidProjectConfig.fromYaml(
      rapidYamlContents,
      path: projectRoot.path,
    );
  }

  /// Handles the case where a project could not be found in the [current]
  /// or a parent directory by throwing an error with a helpful message.
  static Future<Never> handleProjectNotFound(Directory current) async {
    throw UnresolvedProject(
      // TODO is link correct ?
      multiLine([
        'Your current directory does not appear to be within a Rapid ',
        'project.',
        '',
        'For setting up a project, see: ',
        'https://docs.page/jtdLab/rapid/cli/create',
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
      throw RapidConfigException(
        'path must be an absolute path but got $path.',
      );
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RapidProjectConfig &&
        other.path == path &&
        other.name == name;
  }

  @override
  int get hashCode => path.hashCode ^ name.hashCode;
}

/// An exception thrown when a Rapid project could not be resolved.
class UnresolvedProject extends RapidException {
  UnresolvedProject(super.message);
}
