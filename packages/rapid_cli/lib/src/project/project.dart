import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';

import 'di_package/di_package.dart';
import 'infrastructure_package/infrastructure_package.dart';
import 'logging_package/logging_package.dart';
import 'platform_directory/platform_directory.dart';
import 'platform_ui_package/platform_ui_package.dart';
import 'project_impl.dart';
import 'ui_package/ui_package.dart';

// TODO move to source

class FeatureDoesNotExist implements Exception {}

class FeatureAlreadyExists implements Exception {}

class NoFeaturesFound implements Exception {}

class FeaturesSupportDiffrentLanguages implements Exception {}

class FeaturesHaveDiffrentDefaultLanguage implements Exception {}

class FeaturesAlreadySupportLanguage implements Exception {}

class FeaturesDoNotSupportLanguage implements Exception {}

class UnableToRemoveDefaultLanguage implements Exception {}

class DefaultLanguageAlreadySetToRequestedLanguage implements Exception {}

class EntityAlreadyExists implements Exception {}

class EntityDoesNotExist implements Exception {}

class ServiceInterfaceAlreadyExists implements Exception {}

class ServiceInterfaceDoesNotExist implements Exception {}

class ValueObjectAlreadyExists implements Exception {}

class ValueObjectDoesNotExist implements Exception {}

class DataTransferObjectAlreadyExists implements Exception {}

class DataTransferObjectDoesNotExist implements Exception {}

class ServiceImplementationAlreadyExists implements Exception {}

class ServiceImplementationDoesNotExist implements Exception {}

class BlocAlreadyExists implements Exception {}

class BlocDoesNotExist implements Exception {}

class CubitAlreadyExists implements Exception {}

class CubitDoesNotExist implements Exception {}

class WidgetAlreadyExists implements Exception {}

class WidgetDoesNotExist implements Exception {}

class LanguageArbFileAlreadyExists implements Exception {}

class LanguageArbFileDoesNotExists implements Exception {}

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
  DomainPackageBuilder? domainPackageOverrides;

  @visibleForTesting
  InfrastructurePackageBuilder? infrastructurePackageOverrides;

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

  DomainPackage get domainPackage;

  InfrastructurePackage get infrastructurePackage;

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
    required bool example,
    required bool android,
    required bool ios,
    required bool linux,
    required bool macos,
    required bool web,
    required bool windows,
    required Logger logger,
  });

  Future<void> addPlatform(
    Platform platform, {
    String? description,
    String? orgName,
    required String language,
    required Logger logger,
  });

  Future<void> removePlatform(
    Platform platform, {
    required Logger logger,
  });

  Future<void> addFeature({
    required String name,
    required String description,
    required Platform platform,
    required Logger logger,
  });

  Future<void> removeFeature({
    required String name,
    required Platform platform,
    required Logger logger,
  });

  Future<void> addLanguage(
    String language, {
    required Platform platform,
    required Logger logger,
  });

  Future<void> removeLanguage(
    String language, {
    required Platform platform,
    required Logger logger,
  });

  Future<void> setDefaultLanguage(
    String newDefaultLanguage, {
    required Platform platform,
    required Logger logger,
  });

  Future<void> addEntity({
    required String name,
    required String outputDir,
    required Logger logger,
  });

  Future<void> removeEntity({
    required String name,
    required String dir,
    required Logger logger,
  });

  Future<void> addServiceInterface({
    required String name,
    required String outputDir,
    required Logger logger,
  });

  Future<void> removeServiceInterface({
    required String name,
    required String dir,
    required Logger logger,
  });

  Future<void> addValueObject({
    required String name,
    required String outputDir,
    required String type,
    required String generics,
    required Logger logger,
  });

  Future<void> removeValueObject({
    required String name,
    required String dir,
    required Logger logger,
  });

  Future<void> addDataTransferObject({
    required String entityName,
    required String outputDir,
    required Logger logger,
  });

  Future<void> removeDataTransferObject({
    required String name,
    required String dir,
    required Logger logger,
  });

  Future<void> addServiceImplementation({
    required String name,
    required String serviceName,
    required String outputDir,
    required Logger logger,
  });

  Future<void> removeServiceImplementation({
    required String name,
    required String serviceName,
    required String dir,
    required Logger logger,
  });

  Future<void> addBloc({
    required String name,
    required String featureName,
    required Platform platform,
    required Logger logger,
  });

  Future<void> removeBloc({
    required String name,
    required String featureName,
    required Platform platform,
    required Logger logger,
  });

  Future<void> addCubit({
    required String name,
    required String featureName,
    required Platform platform,
    required Logger logger,
  });

  Future<void> removeCubit({
    required String name,
    required String featureName,
    required Platform platform,
    required Logger logger,
  });

  Future<void> addWidget({
    required String name,
    required String outputDir,
    required Platform platform,
    required Logger logger,
  });

  Future<void> removeWidget({
    required String name,
    required String dir,
    required Platform platform,
    required Logger logger,
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
