import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/domain_directory/domain_directory.dart';
import 'package:rapid_cli/src/project/infrastructure_directory/infrastructure_directory.dart';

import 'di_package/di_package.dart';
import 'logging_package/logging_package.dart';
import 'platform_directory/platform_directory.dart';
import 'platform_ui_package/platform_ui_package.dart';
import 'project_impl.dart';
import 'ui_package/ui_package.dart';

// TODO: all create methods of project entities need better docs.

class RapidException implements Exception {
  final String message;

  RapidException([this.message = '']);

  @override
  String toString() => 'RapidException($message)';
}

/// Signature of [Project.new].
typedef ProjectBuilder = Project Function({String path});

/// {@template project}
/// Abstraction of a Rapid project.
/// {@endtemplate}
abstract class Project implements Directory, OverridableGenerator {
  /// {@macro project}
  factory Project({
    String path = '.',
  }) =>
      ProjectImpl(
        path: path,
      );

  /// Use to override [melosFile] for testing.
  @visibleForTesting
  MelosFileBuilder? melosFileOverrides;

  /// Use to override [diPackage] for testing.
  @visibleForTesting
  DiPackageBuilder? diPackageOverrides;

  /// Use to override [domainDirectory] for testing.
  @visibleForTesting
  DomainDirectoryBuilder? domainDirectoryOverrides;

  /// Use to override [infrastructureDirectory] for testing.
  @visibleForTesting
  InfrastructureDirectoryBuilder? infrastructureDirectoryOverrides;

  /// Use to override [loggingPackage] for testing.
  @visibleForTesting
  LoggingPackageBuilder? loggingPackageOverrides;

  /// Use to override [platformDirectory] for testing.
  @visibleForTesting
  PlatformDirectoryBuilder? platformDirectoryOverrides;

  /// Use to override [uiPackage] for testing.
  @visibleForTesting
  UiPackageBuilder? uiPackageOverrides;

  /// Use to override [platformUiPackage] for testing.
  @visibleForTesting
  PlatformUiPackageBuilder? platformUiPackageOverrides;

  /// Returns the melos file of this projet.
  MelosFile get melosFile;

  /// Returns the di package of this projet.
  DiPackage get diPackage;

  /// Returns the domain package of this projet.
  DomainDirectory get domainDirectory;

  /// Returns the infrastructure package of this projet.
  InfrastructureDirectory get infrastructureDirectory;

  /// Returns the logging package of this projet.
  LoggingPackage get loggingPackage;

  /// Returns the platform directory for [platform] of this projet.
  T platformDirectory<T extends PlatformDirectory>({
    required Platform platform,
  });

  /// Returns the platform-independent ui package for this project.
  UiPackage get uiPackage;

  /// Returns the platform ui package for [platform] of this projet.
  PlatformUiPackage platformUiPackage({required Platform platform});

  /// Returns the file of this project.
  String name();

  /// Returns wheter all files of this project exist.
  bool existsAll();

  /// Returns wheter any file of this project exist.
  bool existsAny();

  /// Returns wheter the [platform] is activated for this project.
  bool platformIsActivated(Platform platform);

  /// Creates this project on disk.
  Future<void> create({
    required String projectName,
    required String description,
    required String orgName,
    required String language,
    required Set<Platform> platforms,
  });
}

// TODO replace with RapidException
class ReadNameFailure implements Exception {}

/// Signature of [MelosFile.new].
typedef MelosFileBuilder = MelosFile Function({required Project project});

/// {@template melos_file}
/// Abstraction of the melos file of a Rapid project.
///
/// Location: `melos.yaml`
/// {@endtemplate}
abstract class MelosFile implements YamlFile {
  /// {@macro melos_file}
  factory MelosFile({
    required Project project,
  }) =>
      MelosFileImpl(
        project: project,
      );

  /// Returns the project associated with this file.
  Project get project;

  /// Reads the `name` of this file from disk.
  String readName();
}
