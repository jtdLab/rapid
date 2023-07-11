part of 'runner.dart';

mixin _PlatformMixin on _Rapid {
  Future<void> platformAddFeatureFlow(
    Platform platform, {
    required String name,
    required String description,
    required bool navigator,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final featurePackage = platformDirectory.featuresDirectory
        .featurePackage<PlatformFlowFeaturePackage>(name: '${name}_flow');

    if (featurePackage.existsSync()) {
      throw FeatureAlreadyExistsException._(featurePackage, platform);
    }

    final rootPackage = platformDirectory.rootPackage;

    logger.newLine();

    await task('Creating feature', () async {
      await featurePackage.generate(description: description);

      await rootPackage.registerFeaturePackage(featurePackage);

      if (navigator) {
        await _addNavigator(
          featurePackage: featurePackage,
          navigationPackage: platformDirectory.navigationPackage,
        );
      }
    });

    await melosBootstrapTask(scope: [rootPackage, featurePackage]);

    await codeGenTaskGroup(
      packages: [rootPackage, if (navigator) featurePackage],
    );

    await dartFormatFixTask();

    // TODO add link doc to navigation and routing approach
    logger
      ..newLine()
      ..commandSuccess('Added Flow Feature!');
  }

  // TODO
  Future<void> platformAddFeatureTabFlow(
    Platform platform, {
    required String name,
    required String description,
    required bool navigator,
    required Set<String> subFeatures,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final featurePackage = platformDirectory.featuresDirectory
        .featurePackage<PlatformTabFlowFeaturePackage>(
      name: '${name}_tab_flow',
    );

    if (featurePackage.existsSync()) {
      throw FeatureAlreadyExistsException._(featurePackage, platform);
    }

    final rootPackage = platformDirectory.rootPackage;

    logger.newLine();

    // TODO rm
    /*  // TODO rewrite resolve featurePackages from features in one line
      // Is it evene needed to convert them to actual feature packages
      final Set<PlatformFeaturePackage> subFeaturePackages = {};

      final existingFeaturePackages =
          platformDirectory.featuresDirectory.featurePackages();
      for (final subFeature in subFeatures) {
        final matchingPackage = existingFeaturePackages.firstWhere(
          (e) => subFeature == e.packageName || subFeature == e.name,
          // TODO maybe sub feature not found
          orElse: () => throw FeatureNotFoundException._(subFeature, platform),
        );

        subFeaturePackages.add(matchingPackage);
      } */

    await task('Creating feature', () async {
      await featurePackage.generate(
        description: description,
        subFeatures: subFeatures,
      );

      await rootPackage.registerFeaturePackage(featurePackage);

      if (navigator) {
        await _addNavigator(
          featurePackage: featurePackage,
          navigationPackage: platformDirectory.navigationPackage,
        );
      }
    });

    await melosBootstrapTask(scope: [rootPackage, featurePackage]);

    await codeGenTaskGroup(
      packages: [rootPackage, if (navigator) featurePackage],
    );

    await dartFormatFixTask();

    // TODO add link doc to navigation and routing approach
    logger
      ..newLine()
      ..commandSuccess('Added Tab Flow Feature!');
  }

  Future<void> platformAddFeaturePage(
    Platform platform, {
    required String name,
    required String description,
    required bool navigator,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final featurePackage = platformDirectory.featuresDirectory
        .featurePackage<PlatformPageFeaturePackage>(name: '${name}_page');

    if (featurePackage.existsSync()) {
      throw FeatureAlreadyExistsException._(featurePackage, platform);
    }

    final rootPackage = platformDirectory.rootPackage;

    logger.newLine();

    await task(
      'Creating feature files',
      () async {
        await featurePackage.generate(description: description);
        await rootPackage.registerFeaturePackage(featurePackage);
        if (navigator) {
          await _addNavigator(
            featurePackage: featurePackage,
            navigationPackage: platformDirectory.navigationPackage,
          );
        }
      },
    );

    await melosBootstrapTask(scope: [rootPackage, featurePackage]);

    await codeGenTaskGroup(
      packages: [rootPackage, if (navigator) featurePackage],
    );

    await dartFormatFixTask();

    // TODO add link doc to navigation and routing approach
    logger
      ..newLine()
      ..commandSuccess('Added Page Feature!');
  }

  Future<void> platformAddFeatureWidget(
    Platform platform, {
    required String name,
    required String description,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final featurePackage = platformDirectory.featuresDirectory
        .featurePackage<PlatformWidgetFeaturePackage>(name: '${name}_widget');

    if (featurePackage.existsSync()) {
      throw FeatureAlreadyExistsException._(featurePackage, platform);
    }

    final rootPackage = platformDirectory.rootPackage;

    logger.newLine();

    await task('Generating feature files', () async {
      await featurePackage.generate(description: description);
      await rootPackage.registerFeaturePackage(featurePackage);
    });

    await melosBootstrapTask(scope: [rootPackage, featurePackage]);

    await codeGenTask(package: rootPackage);

    await dartFormatFixTask();

    // TODO add link doc to navigation and routing approach
    logger
      ..newLine()
      ..commandSuccess('Added Widget Feature!');
  }

  Future<void> platformAddLanguage(
    Platform platform, {
    required Language language,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final localizationPackage = platformDirectory.localizationPackage;

    if (localizationPackage.supportedLanguages().contains(language)) {
      throw LanguageAlreadyPresentException._(language);
    }

    final rootPackage = platformDirectory.rootPackage;

    logger.newLine();

    // TODO cleaner
    if (rootPackage is IosRootPackage) {
      rootPackage.addLanguage(language);
    }
    if (rootPackage is MobileRootPackage) {
      rootPackage.addLanguage(language);
    }

    localizationPackage.addLanguage(language);
    // TODO move down ? check if already there?
    if (language.hasScriptCode || language.hasCountryCode) {
      // TODO cleaner
      if (rootPackage is IosRootPackage) {
        rootPackage.addLanguage(
          Language(languageCode: language.languageCode),
        );
      }
      if (rootPackage is MobileRootPackage) {
        rootPackage.addLanguage(
          Language(languageCode: language.languageCode),
        );
      }
      localizationPackage.addLanguage(
        Language(languageCode: language.languageCode),
      );
    }

    await flutterGenl10n(package: localizationPackage);

    await dartFormatFix(package: localizationPackage);

    // TODO add hint how to work with localization
    logger
      ..newLine()
      ..commandSuccess('Added Language!');
  }

  Future<void> platformAddNavigator(
    Platform platform, {
    required String featureName,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final featurePackage =
        platformDirectory.featuresDirectory.featurePackage(name: featureName);

    if (featurePackage is! PlatformRoutableFeaturePackage) {
      throw FeatureNotRoutableException._(featurePackage, platform);
    }

    if (!featurePackage.existsSync()) {
      throw FeatureNotFoundException._(featurePackage, platform);
    }

    logger.newLine();

    await _addNavigator(
      featurePackage: featurePackage,
      navigationPackage: platformDirectory.navigationPackage,
    );

    logger
      ..newLine()
      ..commandSuccess('Added Navigator!');
  }

  Future<void> platformFeatureAddBloc(
    Platform platform, {
    required String name,
    required String featureName,
    required String outputDir,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final featurePackage =
        platformDirectory.featuresDirectory.featurePackage(name: featureName);

    if (!featurePackage.existsSync()) {
      throw FeatureNotFoundException._(featurePackage, platform);
    }

    final bloc = featurePackage.bloc(name: name);

    if (bloc.existsAny) {
      throw BlocAlreadyExistsException._(name, featurePackage, platform);
    }

    final applicationBarrelFile = featurePackage.applicationBarrelFile;

    logger.newLine();

    await bloc.generate();

    if (!applicationBarrelFile.existsSync()) {
      final barrelFile = featurePackage.barrelFile;

      await applicationBarrelFile.create();
      applicationBarrelFile.addExport(
        p.normalize(p.join(outputDir, '${name.snakeCase}_bloc.dart')),
      );

      barrelFile.addExport('src/application/application.dart');
    } else {
      applicationBarrelFile.addExport(
        p.normalize(p.join(outputDir, '${name.snakeCase}_bloc.dart')),
      );
    }

    await codeGen(package: featurePackage);

    logger
      ..newLine()
      ..commandSuccess('Added Bloc!');
  }

  Future<void> platformFeatureAddCubit(
    Platform platform, {
    required String name,
    required String featureName,
    required String outputDir,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final featurePackage =
        platformDirectory.featuresDirectory.featurePackage(name: featureName);

    if (!featurePackage.existsSync()) {
      throw FeatureNotFoundException._(featurePackage, platform);
    }

    final cubit = featurePackage.cubit(name: name);

    if (cubit.existsAny) {
      throw CubitAlreadyExistsException._(name, featurePackage, platform);
    }

    final applicationBarrelFile = featurePackage.applicationBarrelFile;

    logger.newLine();

    await cubit.generate();

    if (!applicationBarrelFile.existsSync()) {
      final barrelFile = featurePackage.barrelFile;

      await applicationBarrelFile.create();
      applicationBarrelFile.addExport(
        p.normalize(p.join(outputDir, '${name.snakeCase}_cubit.dart')),
      );

      barrelFile.addExport('src/application/application.dart');
    } else {
      applicationBarrelFile.addExport(
        p.normalize(p.join(outputDir, '${name.snakeCase}_cubit.dart')),
      );
    }

    await codeGen(package: featurePackage);

    logger
      ..newLine()
      ..commandSuccess('Added Cubit!');
  }

  Future<void> platformFeatureRemoveBloc(
    Platform platform, {
    required String name,
    required String featureName,
    required String dir,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final featurePackage =
        platformDirectory.featuresDirectory.featurePackage(name: featureName);

    if (!featurePackage.existsSync()) {
      throw FeatureNotFoundException._(featurePackage, platform);
    }

    final bloc = featurePackage.bloc(name: name);

    if (!bloc.existsAny) {
      throw BlocNotFoundException._(name, featurePackage, platform);
    }

    final applicationBarrelFile = featurePackage.applicationBarrelFile;

    logger.newLine();

    bloc.delete();

    // TODO delete application dir if empty

    applicationBarrelFile.removeExport(
      p.normalize(p.join(dir, '${name.snakeCase}_bloc.dart')),
    );
    if (!applicationBarrelFile.containsStatements()) {
      applicationBarrelFile.delete();
      final barrelFile = featurePackage.barrelFile;
      barrelFile.removeExport('src/application/application.dart');
    }

    await codeGen(package: featurePackage);

    logger
      ..newLine()
      ..commandSuccess('Removed Bloc!');
  }

  Future<void> platformFeatureRemoveCubit(
    Platform platform, {
    required String name,
    required String featureName,
    required String dir,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final featurePackage =
        platformDirectory.featuresDirectory.featurePackage(name: featureName);

    if (!featurePackage.existsSync()) {
      throw FeatureNotFoundException._(featurePackage, platform);
    }

    final cubit = featurePackage.cubit(name: name);

    if (!cubit.existsAny) {
      throw CubitNotFoundException._(name, featurePackage, platform);
    }

    final applicationBarrelFile = featurePackage.applicationBarrelFile;

    logger.newLine();

    cubit.delete();
    // TODO delete application dir if empty

    applicationBarrelFile.removeExport(
      p.normalize(p.join(dir, '${name.snakeCase}_cubit.dart')),
    );
    if (!applicationBarrelFile.containsStatements()) {
      applicationBarrelFile.delete();
      final barrelFile = featurePackage.barrelFile;
      barrelFile.removeExport('src/application/application.dart');
    }

    await codeGen(package: featurePackage);

    logger
      ..newLine()
      ..commandSuccess('Removed Cubit!');
  }

  Future<void> platformRemoveFeature(
    Platform platform, {
    required String name,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final featuresDirectory = platformDirectory.featuresDirectory;
    final featurePackage = featuresDirectory.featurePackage(name: name);

    if (!featurePackage.existsSync()) {
      throw FeatureNotFoundException._(featurePackage, platform);
    }

    final rootPackage = platformDirectory.rootPackage;
    final remainingFeaturePackages = featuresDirectory.featurePackages()
      ..remove(featurePackage);

    logger.newLine();

    await task('Deleting feature files', () async {
      await rootPackage.unregisterFeaturePackage(featurePackage);

      for (final remainingFeaturePackage in remainingFeaturePackages) {
        if (remainingFeaturePackage.pubSpecFile
            .hasDependency(name: featurePackage.packageName)) {
          remainingFeaturePackage.pubSpecFile.removeDependency(
            name: featurePackage.packageName,
          );
        }
      }

      await _removeNavigatorInterface(
        featurePackage: featurePackage,
        navigationPackage: platformDirectory.navigationPackage,
      );

      featurePackage.deleteSync(recursive: true);
    });

    await melosBootstrapTask(
      scope: [
        ...remainingFeaturePackages,
        rootPackage,
      ],
    );

    await codeGenTask(package: rootPackage);

    await dartFormatFixTask();

    logger
      ..newLine()
      ..commandSuccess('Removed Feature!');
  }

  Future<void> platformRemoveLanguage(
    Platform platform, {
    required Language language,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final localizationPackage = platformDirectory.localizationPackage;
    final supportedLanguages = localizationPackage.supportedLanguages();

    if (!supportedLanguages.contains(language)) {
      // TODO better hint
      throw LanguageNotFoundException._(language);
    }

    if (localizationPackage.defaultLanguage() == language) {
      // TODO add hint how to change default language
      throw CantRemoveDefaultLanguageException._(language);
    }

    final rootPackage = platformDirectory.rootPackage;

    logger.newLine();

    // TODO cleaner
    if (rootPackage is IosRootPackage) {
      rootPackage.removeLanguage(language);
    }
    if (rootPackage is MobileRootPackage) {
      rootPackage.removeLanguage(language);
    }
    localizationPackage.removeLanguage(language);
    // TODO move down ?
    if (!language.hasScriptCode && !language.hasCountryCode) {
      for (final language in supportedLanguages
          .where((e) => e.languageCode == language.languageCode)) {
        // TODO cleaner
        if (rootPackage is IosRootPackage) {
          rootPackage.removeLanguage(language);
        }
        if (rootPackage is MobileRootPackage) {
          rootPackage.removeLanguage(language);
        }

        localizationPackage.removeLanguage(language);
      }
    }

    await flutterGenl10n(package: localizationPackage);

    await dartFormatFix(package: localizationPackage);

    logger
      ..newLine()
      ..commandSuccess('Removed Language!');
  }

  Future<void> platformRemoveNavigator(
    Platform platform, {
    required String featureName,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final featurePackage =
        platformDirectory.featuresDirectory.featurePackage(name: featureName);

    if (featurePackage is! PlatformRoutableFeaturePackage) {
      throw FeatureNotRoutableException._(featurePackage, platform);
    }

    if (!featurePackage.existsSync()) {
      throw FeatureNotFoundException._(featurePackage, platform);
    }

    final navigationPackage = platformDirectory.navigationPackage;

    logger.newLine();

    await _removeNavigatorInterface(
      featurePackage: featurePackage,
      navigationPackage: navigationPackage,
    );

    await _removeNavigatorImplementation(featurePackage: featurePackage);

    await codeGen(package: featurePackage);

    await dartFormatFix(package: project.rootPackage);

    logger
      ..newLine()
      ..commandSuccess('Removed Navigator!');
  }

  Future<void> platformSetDefaultLanguage(
    Platform platform, {
    required Language language,
  }) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformNotActivatedException._(platform);
    }

    final localizationPackage = project.appModule
        .platformDirectory(platform: platform)
        .localizationPackage;
    if (!localizationPackage.supportedLanguages().contains(language)) {
      throw LanguageNotFoundException._(language);
    }

    if (localizationPackage.defaultLanguage() == language) {
      throw LanguageIsAlreadyDefaultLanguageException._(language);
    }

    logger.newLine();

    localizationPackage.setDefaultLanguage(language);

    await flutterGenl10n(package: localizationPackage);

    await dartFormatFix(package: project.rootPackage);

    // TODO add hint how to work with localization

    logger
      ..newLine()
      ..commandSuccess('Set Default Language!');
  }

  Future<void> _addNavigator({
    required PlatformRoutableFeaturePackage featurePackage,
    required PlatformNavigationPackage navigationPackage,
  }) async {
    // TODO check wheter impl and interface are already existing
    // throw NavigatorAlreadyExistsException._(featureName, platform);
    final featureName = featurePackage.name;
    final navigatorInterface =
        navigationPackage.navigatorInterface(name: featureName.pascalCase);
    if (!navigatorInterface.existsAny) {
      final barrelFile = navigationPackage.barrelFile;

      await navigatorInterface.generate();

      barrelFile.addExport('src/i_${featureName.snakeCase}_navigator.dart');

      // TODO check if the impl is already available
      final navigatorImplementation = featurePackage.navigatorImplementation;
      await navigatorImplementation.generate();
    }
  }

  Future<void> _removeNavigatorInterface({
    required PlatformFeaturePackage featurePackage,
    required PlatformNavigationPackage navigationPackage,
  }) async {
    final featureName = featurePackage.name;
    final navigatorInterface =
        navigationPackage.navigatorInterface(name: featureName.pascalCase);
    if (navigatorInterface.existsAny) {
      navigatorInterface.delete();
      navigationPackage.barrelFile.removeExport(
        'src/i_${featureName.snakeCase}_navigator.dart',
      );
    }
  }

  Future<void> _removeNavigatorImplementation({
    required PlatformRoutableFeaturePackage featurePackage,
  }) async {
    // TODO check if the impl is even available
    final navigatorImplementation = featurePackage.navigatorImplementation;
    navigatorImplementation.delete();
  }
}

class FeatureAlreadyExistsException extends RapidException {
  final PlatformFeaturePackage feature;
  final Platform platform;

  FeatureAlreadyExistsException._(this.feature, this.platform);

  @override
  String toString() {
    return 'Feature ${feature.name} already exists. (${platform.prettyName})';
  }
}

class FeatureNotFoundException extends RapidException {
  final PlatformFeaturePackage feature;
  final Platform platform;

  FeatureNotFoundException._(this.feature, this.platform);

  @override
  String toString() {
    return 'Feature ${feature.name} not found. (${platform.prettyName})';
  }
}

class NavigatorNotFoundException extends RapidException {
  final PlatformFeaturePackage feature;
  final Platform platform;

  NavigatorNotFoundException._(this.feature, this.platform);

  @override
  String toString() {
    return 'The navigator "I${feature.name.pascalCase}Navigator" does not exist. (${platform.prettyName})';
  }
}

class FeatureNotRoutableException extends RapidException {
  final PlatformFeaturePackage feature;
  final Platform platform;

  FeatureNotRoutableException._(this.feature, this.platform);

  @override
  String toString() {
    return 'The feature ${feature.name} is not routable. (${platform.prettyName})';
  }
}

class LanguageAlreadyPresentException extends RapidException {
  final Language language;

  LanguageAlreadyPresentException._(this.language);

  @override
  String toString() {
    return 'The language "$language" is already present.';
  }
}

class NavigatorAlreadyExistsException extends RapidException {
  final PlatformFeaturePackage feature;
  final Platform platform;

  NavigatorAlreadyExistsException._(this.feature, this.platform);

  @override
  String toString() {
    return 'The Navigator "I${feature.name.pascalCase}Navigator" does already exist. (${platform.prettyName})';
  }
}

class BlocAlreadyExistsException extends RapidException {
  final String name;
  final PlatformFeaturePackage feature;
  final Platform platform;

  BlocAlreadyExistsException._(this.name, this.feature, this.platform);

  @override
  String toString() {
    return 'The ${name}Bloc does already exist in "${feature.name}". (${platform.prettyName})';
  }
}

class CubitAlreadyExistsException extends RapidException {
  final String name;
  final PlatformFeaturePackage feature;
  final Platform platform;

  CubitAlreadyExistsException._(this.name, this.feature, this.platform);

  @override
  String toString() {
    return 'The ${name}Cubit does already exist in "${feature.name}". (${platform.prettyName})';
  }
}

class BlocNotFoundException extends RapidException {
  final String name;
  final PlatformFeaturePackage feature;
  final Platform platform;

  BlocNotFoundException._(this.name, this.feature, this.platform);

  @override
  String toString() {
    return 'The ${name}Bloc does not exist in "${feature.name}". (${platform.prettyName})';
  }
}

class CubitNotFoundException extends RapidException {
  final String name;
  final PlatformFeaturePackage feature;
  final Platform platform;

  CubitNotFoundException._(this.name, this.feature, this.platform);

  @override
  String toString() {
    return 'The ${name}Cubit does not exist in "${feature.name}". (${platform.prettyName})';
  }
}

class LanguageNotFoundException extends RapidException {
  final Language language;

  LanguageNotFoundException._(this.language);

  @override
  String toString() {
    return 'The language "$language" is not present.';
  }
}

class CantRemoveDefaultLanguageException extends RapidException {
  final Language language;

  CantRemoveDefaultLanguageException._(this.language);

  @override
  String toString() {
    return 'Can not remove language "$language" because it is the default language.';
  }
}

class LanguageIsAlreadyDefaultLanguageException extends RapidException {
  final Language language;

  LanguageIsAlreadyDefaultLanguageException._(this.language);

  @override
  String toString() {
    return 'The language "$language" already is the default language.';
  }
}

class PlatformNotActivatedException extends RapidException {
  final Platform platform;

  PlatformNotActivatedException._(this.platform);

  @override
  String toString() {
    return 'The platform ${platform.prettyName} is not activated. '
        'Use "rapid activate ${platform.prettyName}" to activate the platform first.';
  }
}
