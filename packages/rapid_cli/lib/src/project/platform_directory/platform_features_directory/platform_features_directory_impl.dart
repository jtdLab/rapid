import 'package:collection/collection.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_features_directory.dart';
import 'package:rapid_cli/src/project/project.dart';

class PlatformFeaturesDirectoryImpl extends DartPackageImpl
    implements PlatformFeaturesDirectory {
  PlatformFeaturesDirectoryImpl(
    Platform platform, {
    required this.project,
  })  : _platform = platform,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_${platform.name}',
            '${project.name()}_${platform.name}_features',
          ),
        );

  final Platform _platform;

  @override
  PlatformFeaturePackageBuilder? featurePackageOverrides;

  @override
  List<PlatformFeaturePackage>? featurePackagesOverrides;

  @override
  final Project project;

  @override
  T featurePackage<T extends PlatformFeaturePackage>(String name) =>
      featurePackageOverrides?.call(name, _platform, project: project) as T? ??
      (name == 'app'
          ? PlatformAppFeaturePackage(_platform, project: project)
          : PlatformFeaturePackage(name, _platform, project: project)) as T;

  @override
  List<PlatformFeaturePackage> featurePackages() => featurePackagesOverrides ??
      list().whereType<Directory>().map(
        (e) {
          final name = p
              .basename(e.path)
              .replaceAll('${project.name()}_${_platform.name}_', '');

          return featurePackage(name);
        },
      ).toList()
    ..sort();

  @override
  Set<String> supportedLanguages() {
    final features = featurePackages();

    if (!features.supportSameLanguages()) {
      throw Error(); // TODO
    }

    return features.first.supportedLanguages();
  }

  @override
  Future<void> addFeature({
    required String name,
    String? description,
    required String defaultLanguage,
    required Set<String> languages,
    required Logger logger,
  }) async {
    final featurePackage = this.featurePackage(name);

    if (featurePackage.exists()) {
      throw FeatureAlreadyExists();
    }

    // TODO creation and adding coupled good?
    await featurePackage.create(
      description: description,
      defaultLanguage: defaultLanguage,
      languages: languages,
      logger: logger,
    );
  }

  @override
  Future<void> removeFeature({
    required String name,
    required Logger logger,
  }) async {
    if (name == 'app') {
      throw Error(); // TODO more specific
    }

    final featurePackage = this.featurePackage(name);
    if (!featurePackage.exists()) {
      throw FeatureDoesNotExist();
    }

    final otherFeaturePackages = featurePackages()
      ..removeWhere((e) => e.packageName() == featurePackage.packageName());
    for (final otherFeaturePackage in otherFeaturePackages) {
      otherFeaturePackage.pubspecFile.removeDependency(
        featurePackage.packageName(),
      );
    }

    featurePackage.delete(logger: logger);
  }

  @override
  Future<void> addLanguage(
    String language, {
    required Logger logger,
  }) async {
    final features = featurePackages();

    if (features.isEmpty) {
      throw NoFeaturesFound();
    }

    if (!features.supportSameLanguages()) {
      throw FeaturesSupportDiffrentLanguages();
    }

    if (!features.haveSameDefaultLanguage()) {
      throw FeaturesHaveDiffrentDefaultLanguage();
    }

    if (features.first.supportsLanguage(language)) {
      throw FeaturesAlreadySupportLanguage();
    }

    for (final customFeature in features) {
      await customFeature.addLanguage(language: language, logger: logger);
    }
  }

  @override
  Future<void> removeLanguage(
    String language, {
    required Logger logger,
  }) async {
    final features = featurePackages();

    if (features.isEmpty) {
      throw NoFeaturesFound();
    }

    if (!features.supportSameLanguages()) {
      throw FeaturesSupportDiffrentLanguages();
    }

    if (!features.haveSameDefaultLanguage()) {
      throw FeaturesHaveDiffrentDefaultLanguage();
    }

    if (!features.first.supportsLanguage(language)) {
      throw FeaturesDoNotSupportLanguage();
    }

    if (features.first.defaultLanguage() == language) {
      throw UnableToRemoveDefaultLanguage();
    }

    for (final feature in features) {
      await feature.removeLanguage(language: language, logger: logger);
    }
  }

  @override
  Future<void> setDefaultLanguage(
    String newDefaultLanguage, {
    required Logger logger,
  }) async {
    final features = featurePackages();

    if (features.isEmpty) {
      throw NoFeaturesFound();
    }

    if (!features.supportSameLanguages()) {
      throw FeaturesSupportDiffrentLanguages();
    }

    if (!features.haveSameDefaultLanguage()) {
      throw FeaturesHaveDiffrentDefaultLanguage();
    }

    if (!features.first.supportsLanguage(newDefaultLanguage)) {
      throw FeaturesDoNotSupportLanguage();
    }

    if (features.first.defaultLanguage() == newDefaultLanguage) {
      throw DefaultLanguageAlreadySetToRequestedLanguage();
    }

    for (final feature in features) {
      await feature.setDefaultLanguage(newDefaultLanguage, logger: logger);
    }
  }

  @override
  String defaultLanguage() {
    final features = featurePackages();
    final allFeaturesHaveSameDefaultLanguage =
        features.map((e) => e.defaultLanguage()).toSet().length == 1;

    if (!allFeaturesHaveSameDefaultLanguage) {
      throw Error(); // TODO
    }

    return features.first.defaultLanguage();
  }

  @override
  Future<void> addBloc({
    required String name,
    required String featureName,
    required Logger logger,
  }) async {
    final featurePackage = this.featurePackage(featureName);
    if (!featurePackage.exists()) {
      throw FeatureDoesNotExist();
    }

    await featurePackage.addBloc(name: name, logger: logger);
  }

  @override
  Future<void> removeBloc({
    required String name,
    required String featureName,
    required Logger logger,
  }) async {
    final featurePackage = this.featurePackage(featureName);
    if (!featurePackage.exists()) {
      throw FeatureDoesNotExist();
    }

    await featurePackage.removeBloc(name: name, logger: logger);
  }

  @override
  Future<void> addCubit({
    required String name,
    required String featureName,
    required Logger logger,
  }) async {
    final featurePackage = this.featurePackage(featureName);
    if (!featurePackage.exists()) {
      throw FeatureDoesNotExist();
    }

    await featurePackage.addCubit(name: name, logger: logger);
  }

  @override
  Future<void> removeCubit({
    required String name,
    required String featureName,
    required Logger logger,
  }) async {
    final featurePackage = this.featurePackage(featureName);
    if (!featurePackage.exists()) {
      throw FeatureDoesNotExist();
    }

    await featurePackage.removeCubit(name: name, logger: logger);
  }
}

extension on Iterable<PlatformFeaturePackage> {
  /// Wheter all [PlatformFeaturePackage]s support the same languages.
  bool supportSameLanguages() =>
      EqualitySet.from(
        DeepCollectionEquality.unordered(),
        map((e) => e.supportedLanguages()),
      ).length ==
      1;

  /// Wheter all [PlatformFeaturePackage] have the same default language.
  bool haveSameDefaultLanguage() =>
      map((e) => e.defaultLanguage()).toSet().length == 1;
}
