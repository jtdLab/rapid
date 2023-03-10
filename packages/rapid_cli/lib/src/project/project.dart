import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';

import 'app_package/app_package.dart';
import 'di_package/di_package.dart';
import 'infrastructure_package/infrastructure_package.dart';
import 'logging_package/logging_package.dart';
import 'platform_directory/platform_directory.dart';
import 'platform_ui_package/platform_ui_package.dart';
import 'project_impl.dart';
import 'ui_package/ui_package.dart';

class FeatureDoesNotExist implements Exception {}

class FeatureAlreadyExists implements Exception {}

class NoFeaturesFound implements Exception {}

class FeaturesHaveDiffrentLanguages implements Exception {}

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

class CubitAlreadyExists implements Exception {}

class WidgetAlreadyExists implements Exception {}

class WidgetDoesNotExist implements Exception {}

/// Signature for method that returns the [PlatformDirectory] for [platform].
typedef PlatformDirectoryBuilder = PlatformDirectory Function({
  required Platform platform,
});

/// Signature for method that returns the [PlatformUiPackage] for [platform].
typedef PlatformUiPackageBuilder = PlatformUiPackage Function({
  required Platform platform,
});

/// Signature for method that returns the [Project] for [path].
typedef ProjectBuilder = Project Function({String path});

/// {@template project}
/// Abstraction of a Rapid project.
/// {@endtemplate}
abstract class Project implements Directory {
  /// {@macro project}
  factory Project({
    String path = '.',
    MelosFile? melosFile,
    AppPackage? appPackage,
    DiPackage? diPackage,
    DomainPackage? domainPackage,
    InfrastructurePackage? infrastructurePackage,
    LoggingPackage? loggingPackage,
    PlatformDirectoryBuilder? platformDirectory,
    UiPackage? uiPackage,
    PlatformUiPackageBuilder? platformUiPackage,
    MelosBootstrapCommand? melosBootstrap,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  }) =>
      ProjectImpl(
        path: path,
        melosFile: melosFile,
        appPackage: appPackage,
        diPackage: diPackage,
        domainPackage: domainPackage,
        infrastructurePackage: infrastructurePackage,
        loggingPackage: loggingPackage,
        platformDirectory: platformDirectory,
        uiPackage: uiPackage,
        platformUiPackage: platformUiPackage,
        melosBootstrap: melosBootstrap,
        flutterPubGet: flutterPubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
        dartFormatFix: dartFormatFix,
        generator: generator,
      );

  MelosFile get melosFile;

  AppPackage get appPackage;

  DiPackage get diPackage;

  DomainPackage get domainPackage;

  InfrastructurePackage get infrastructurePackage;

  LoggingPackage get loggingPackage;

  PlatformDirectoryBuilder get platformDirectory;

  UiPackage get uiPackage;

  PlatformUiPackageBuilder get platformUiPackage;

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
    required bool routing,
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

  Future<void> addCubit({
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
