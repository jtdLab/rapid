import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/domain_dir/domain_directory.dart';
import 'package:rapid_cli/src/project/infrastructure_dir/infrastructure_directory.dart';

import 'di_package/di_package.dart';
import 'logging_package/logging_package.dart';
import 'platform_directory/platform_directory.dart';
import 'platform_ui_package/platform_ui_package.dart';
import 'project_impl.dart';
import 'ui_package/ui_package.dart';

class RapidException implements Exception {
  final String message;

  RapidException([this.message = '']);

  @override
  String toString() => 'RapidException($message)';
}

/// Signature for method that returns the [Project] for [path].
typedef ProjectBuilder = Project Function({String path});

/// {@template project}
/// Abstraction of a Rapid project.
/// {@endtemplate}
abstract class Project implements Directory, OverridableGenerator {
  /// {@macro project}
  factory Project({String path = '.'}) => ProjectImpl(path: path);

  @visibleForTesting
  MelosFileBuilder? melosFileOverrides;

  @visibleForTesting
  DiPackageBuilder? diPackageOverrides;

  @visibleForTesting
  DomainDirectoryBuilder? domainDirectoryOverrides;

  @visibleForTesting
  InfrastructureDirectoryBuilder? infrastructureDirectoryOverrides;

  @visibleForTesting
  LoggingPackageBuilder? loggingPackageOverrides;

  @visibleForTesting
  PlatformDirectoryBuilder? platformDirectoryOverrides;

  @visibleForTesting
  UiPackageBuilder? uiPackageOverrides;

  @visibleForTesting
  PlatformUiPackageBuilder? platformUiPackageOverrides;

  MelosFile get melosFile;

  DiPackage get diPackage;

  DomainDirectory get domainDirectory;

  InfrastructureDirectory get infrastructureDirectory;

  LoggingPackage get loggingPackage;

  T platformDirectory<T extends PlatformDirectory>({
    required Platform platform,
  });

  UiPackage get uiPackage;

  PlatformUiPackage platformUiPackage({required Platform platform});

  String name();

  bool existsAll();

  bool existsAny();

  bool platformIsActivated(Platform platform);

  Future<void> create({
    required String projectName,
    required String description,
    required String orgName,
    required String language,
    required Set<Platform> platforms,
  });
}

/// Thrown when [MelosFile.readName] fails to read the `name` property.
class ReadNameFailure implements Exception {}

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

  Project get project;

  String readName();
}
