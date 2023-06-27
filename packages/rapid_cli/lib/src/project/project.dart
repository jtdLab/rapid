import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_root_package/platform_root_package.dart';
import 'package:rapid_cli/src/project/project_impl.dart';

import '../project_config.dart';
import 'core/generator_mixins.dart';
import 'di_package/di_package.dart';
import 'domain_directory/domain_directory.dart';
import 'infrastructure_directory/infrastructure_directory.dart';
import 'logging_package/logging_package.dart';
import 'platform_directory/platform_directory.dart';
import 'platform_ui_package/platform_ui_package.dart';
import 'ui_package/ui_package.dart';

/// {@template rapid_project}
/// Abstraction of a Rapid project.
/// {@endtemplate}
abstract class RapidProject extends DartPackageImpl
    with OverridableGenerator, Generatable {
  /// {@macro rapid_project}
  factory RapidProject({
    required RapidProjectConfig config,
  }) =>
      RapidProjectImpl(config: config);

  /// The required name as defined in the rapid section of "pubspec.yaml".
  /// This name is used for naming project directories, files and components.
  String get name;

  /// Full file path to the location of this project.
  @override
  String get path;

  RapidProjectConfig get config;

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

  /// Returns wheter the [platform] is activated for this project.
  bool platformIsActivated(Platform platform);

  /// All packages of this project.
  List<DartPackage> get packages;

  /// All feature packages of all active platforms of this project.
  List<PlatformFeaturePackage> get featurePackages;

  /// All root packages of all active platforms of this project.
  List<PlatformRootPackage> get rootPackages;

  /// Creates this project on disk.
  Future<void> create({
    required String projectName,
    required String description,
    required String orgName,
    required Language language,
    required Set<Platform> platforms,
  });
}
