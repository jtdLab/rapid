import 'package:collection/collection.dart';
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_features_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_navigation_package/platform_navigation_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_root_package/platform_root_package.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_directory.dart';

abstract class PlatformDirectoryImpl extends DartPackageImpl
    implements PlatformDirectory {
  PlatformDirectoryImpl(
    this.platform, {
    required this.project,
  }) : super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_${platform.name}',
          ),
        );

  @override
  PlatformNavigationPackageBuilder? navigationPackageOverrides;

  @override
  PlatformFeaturesDirectoryBuilder? featuresDirectoryOverrides;

  @override
  final Platform platform;

  @override
  final Project project;

  @override
  PlatformNavigationPackage get navigationPackage =>
      (navigationPackageOverrides ?? PlatformNavigationPackage.new)(
        platform,
        project: project,
      );

  @override
  PlatformFeaturesDirectory get featuresDirectory =>
      (featuresDirectoryOverrides ?? PlatformFeaturesDirectory.new)(
        platform,
        project: project,
      );

  @override
  String defaultLanguage() => featuresDirectory.defaultLanguage();

  @override
  Set<String> supportedLanguages() {
    final rootPackageSupportedLanguages = rootPackage.supportedLanguages();

    if (!DeepCollectionEquality.unordered().equals(
      rootPackageSupportedLanguages,
      featuresDirectory.supportedLanguages(),
    )) {
      throw Error(); // TODO more specific
    }

    return rootPackageSupportedLanguages;
  }

  @override
  Future<void> addFeature({
    required String name,
    required String description,
    required Logger logger,
  }) async {
    await featuresDirectory.addFeature(
      name: name,
      description: description,
      defaultLanguage: defaultLanguage(),
      languages: supportedLanguages(),
      logger: logger,
    );

    await rootPackage.registerFeature(
        packageName: '${project.name()}_${platform.name}_$name',
        logger: logger);
  }

  @override
  Future<void> removeFeature({
    required String name,
    required Logger logger,
  }) async {
    await rootPackage.unregisterFeature(
        packageName: '${project.name()}_${platform.name}_$name',
        logger: logger);

    await featuresDirectory.removeFeature(name: name, logger: logger);
  }

  @mustCallSuper
  @override
  Future<void> addLanguage(
    String language, {
    required Logger logger,
  }) async {
    await featuresDirectory.addLanguage(language, logger: logger);
  }

  @mustCallSuper
  @override
  Future<void> removeLanguage(
    String language, {
    required Logger logger,
  }) async {
    await featuresDirectory.removeLanguage(language, logger: logger);
  }

  @override
  Future<void> setDefaultLanguage(
    String newDefaultLanguage, {
    required Logger logger,
  }) async {
    await featuresDirectory.setDefaultLanguage(
      newDefaultLanguage,
      logger: logger,
    );
  }

  @override
  Future<void> addBloc({
    required String name,
    required String featureName,
    required Logger logger,
  }) async {
    await featuresDirectory.addBloc(
      name: name,
      featureName: featureName,
      logger: logger,
    );
  }

  @override
  Future<void> removeBloc({
    required String name,
    required String featureName,
    required Logger logger,
  }) async {
    await featuresDirectory.removeBloc(
      name: name,
      featureName: featureName,
      logger: logger,
    );
  }

  @override
  Future<void> addCubit({
    required String name,
    required String featureName,
    required Logger logger,
  }) async {
    await featuresDirectory.addCubit(
      name: name,
      featureName: featureName,
      logger: logger,
    );
  }

  @override
  Future<void> removeCubit({
    required String name,
    required String featureName,
    required Logger logger,
  }) async {
    await featuresDirectory.removeCubit(
      name: name,
      featureName: featureName,
      logger: logger,
    );
  }
}

class NoneIosDirectoryImpl extends PlatformDirectoryImpl
    implements NoneIosDirectory {
  NoneIosDirectoryImpl(
    super.platform, {
    required super.project,
  }) : assert(platform != Platform.ios);

  @override
  NoneIosRootPackageBuilder? rootPackageOverrides;

  @override
  NoneIosRootPackage get rootPackage =>
      (rootPackageOverrides ?? NoneIosRootPackage.new)(
        platform,
        project: project,
      );

  @override
  Future<void> create({
    String? description,
    String? orgName,
    required String language,
    required Logger logger,
  }) async {
    await rootPackage.create(
      description: description,
      orgName: orgName,
      logger: logger,
    );

    await navigationPackage.create(logger: logger);

    await featuresDirectory.addFeature(
      name: 'app',
      description: 'The App feature.', // TODO platform info
      defaultLanguage: language,
      languages: {language},
      logger: logger,
    );

    await featuresDirectory.addFeature(
      name: 'home_page',
      description: 'The Home Page feature.', // TODO platform info
      defaultLanguage: language,
      languages: {language},
      logger: logger,
    );
  }
}

class IosDirectoryImpl extends PlatformDirectoryImpl implements IosDirectory {
  IosDirectoryImpl({
    required super.project,
  }) : super(Platform.ios);

  @override
  IosRootPackageBuilder? rootPackageOverrides;

  @override
  IosRootPackage get rootPackage =>
      (rootPackageOverrides ?? IosRootPackage.new)(
        project: project,
      );

  @override
  Future<void> create({
    required String orgName,
    required String language,
    required Logger logger,
  }) async {
    await rootPackage.create(
      orgName: orgName,
      language: language,
      logger: logger,
    );

    await navigationPackage.create(logger: logger);

    await featuresDirectory.addFeature(
      name: 'app',
      description: 'The App feature.', // TODO platform info
      defaultLanguage: language,
      languages: {language},
      logger: logger,
    );

    await featuresDirectory.addFeature(
      name: 'home_page',
      description: 'The Home Page feature.', // TODO platform info
      defaultLanguage: language,
      languages: {language},
      logger: logger,
    );
  }

  @override
  Future<void> addLanguage(
    String language, {
    required Logger logger,
  }) async {
    await rootPackage.addLanguage(language, logger: logger);

    await super.addLanguage(language, logger: logger);
  }

  @override
  Future<void> removeLanguage(
    String language, {
    required Logger logger,
  }) async {
    await rootPackage.removeLanguage(language, logger: logger);

    await super.removeLanguage(language, logger: logger);
  }
}
