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

    await flutterPubRunBuildRunnerBuildDeleteConflictingOutputsTaskGroup(
      packages: [rootPackage, if (navigator) featurePackage],
    );

    await dartFormatFixTask();

    // TODO add link doc to navigation and routing approach
    logger
      ..newLine()
      ..commandSuccess('Added Flow Feature!');
  }

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

    await flutterPubRunBuildRunnerBuildDeleteConflictingOutputsTaskGroup(
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

    await flutterPubRunBuildRunnerBuildDeleteConflictingOutputsTaskGroup(
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

    logger.newLine();

    await task('Adding language', () {
      final rootPackage = platformDirectory.rootPackage;
      switch (rootPackage) {
        case IosRootPackage():
          rootPackage.addLanguage(language);
        case MobileRootPackage():
          rootPackage.addLanguage(language);
        default:
      }
      localizationPackage.addLanguage(language);

      // TODO move down ? check if already there? cleaner
      if (language.hasScriptCode || language.hasCountryCode) {
        switch (rootPackage) {
          case IosRootPackage():
            rootPackage.addLanguage(language);
          case MobileRootPackage():
            rootPackage.addLanguage(language);
          default:
        }
        localizationPackage.addLanguage(
          Language(languageCode: language.languageCode),
        );
      }
    });

    await flutterGenl10nTask(package: localizationPackage);

    await dartFormatFixTask();

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

    await dartFormatFixTask();

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

    logger.newLine();

    await task('Creating bloc', () async {
      await bloc.generate();

      final applicationBarrelFile = featurePackage.applicationBarrelFile;
      if (!applicationBarrelFile.existsSync()) {
        final barrelFile = featurePackage.barrelFile;

        applicationBarrelFile.createSync(recursive: true);
        applicationBarrelFile.addExport(
          p.normalize(p.join(outputDir, '${name.snakeCase}_bloc.dart')),
        );

        barrelFile.addExport('src/application/application.dart');
      } else {
        applicationBarrelFile.addExport(
          p.normalize(p.join(outputDir, '${name.snakeCase}_bloc.dart')),
        );
      }
    });

    await codeGenTask(package: featurePackage);

    await dartFormatFixTask();

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

    logger.newLine();

    await task('Creating cubit', () async {
      await cubit.generate();

      final applicationBarrelFile = featurePackage.applicationBarrelFile;
      if (!applicationBarrelFile.existsSync()) {
        final barrelFile = featurePackage.barrelFile;

        applicationBarrelFile.createSync(recursive: true);
        applicationBarrelFile.addExport(
          p.normalize(p.join(outputDir, '${name.snakeCase}_cubit.dart')),
        );

        barrelFile.addExport('src/application/application.dart');
      } else {
        applicationBarrelFile.addExport(
          p.normalize(p.join(outputDir, '${name.snakeCase}_cubit.dart')),
        );
      }
    });

    await codeGenTask(package: featurePackage);

    await dartFormatFixTask();

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

    logger.newLine();

    await task('Removing bloc', () async {
      final applicationBarrelFile = featurePackage.applicationBarrelFile;

      bloc.delete();

      // TODO delete application dir if empty

      applicationBarrelFile.removeExport(
        p.normalize(p.join(dir, '${name.snakeCase}_bloc.dart')),
      );
      if (!applicationBarrelFile.containsStatements()) {
        applicationBarrelFile.deleteSync(recursive: true);
        final barrelFile = featurePackage.barrelFile;
        barrelFile.removeExport('src/application/application.dart');
      }
    });

    await codeGenTask(package: featurePackage);

    await dartFormatFixTask();

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

    logger.newLine();

    await task('Removing cubit', () async {
      cubit.delete();
      // TODO delete application dir if empty

      final applicationBarrelFile = featurePackage.applicationBarrelFile;
      applicationBarrelFile.removeExport(
        p.normalize(p.join(dir, '${name.snakeCase}_cubit.dart')),
      );
      if (!applicationBarrelFile.containsStatements()) {
        applicationBarrelFile.deleteSync(recursive: true);
        final barrelFile = featurePackage.barrelFile;
        barrelFile.removeExport('src/application/application.dart');
      }
    });

    await codeGenTask(package: featurePackage);

    await dartFormatFixTask();

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

      if (featurePackage is PlatformRoutableFeaturePackage) {
        if (featurePackage.navigatorImplementation.existsAll) {
          await _removeNavigatorInterface(
            featurePackage: featurePackage,
            navigationPackage: platformDirectory.navigationPackage,
          );
        }
      }

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

    logger.newLine();

    await task('Removing language', () {
      final rootPackage = platformDirectory.rootPackage;
      switch (rootPackage) {
        case IosRootPackage():
          rootPackage.removeLanguage(language);
        case MobileRootPackage():
          rootPackage.removeLanguage(language);
        default:
      }
      localizationPackage.removeLanguage(language);

      // TODO move down ? cleaner
      if (!language.hasScriptCode && !language.hasCountryCode) {
        for (final language in supportedLanguages.where((e) =>
            e.languageCode == language.languageCode &&
            (e.hasScriptCode || e.hasCountryCode))) {
          switch (rootPackage) {
            case IosRootPackage():
              rootPackage.removeLanguage(language);
            case MobileRootPackage():
              rootPackage.removeLanguage(language);
            default:
          }
          localizationPackage.removeLanguage(language);
        }
      }
    });

    await flutterGenl10nTask(package: localizationPackage);

    await dartFormatFixTask();

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

    logger.newLine();

    // TODO maybe add set-exit-if-error to behave like currently
    // and a mode where if interface or impl are not existing the command skips those errors
    // and completes without error
    await _removeNavigatorInterface(
      featurePackage: featurePackage,
      navigationPackage: platformDirectory.navigationPackage,
    );
    await _removeNavigatorImplementation(featurePackage: featurePackage);

    await dartFormatFixTask();

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

    await task(
      'Setting default language',
      () => localizationPackage.setDefaultLanguage(language),
    );

    await flutterGenl10nTask(package: localizationPackage);

    await dartFormatFixTask();

    // TODO add hint how to work with localization

    logger
      ..newLine()
      ..commandSuccess('Set Default Language!');
  }

  Future<void> _addNavigator({
    required PlatformRoutableFeaturePackage featurePackage,
    required PlatformNavigationPackage navigationPackage,
  }) async {
    // TODO maybe add set-exit-if-error to behave like currently
    // and a mode where if interface or impl are existing the command skips those errors
    // and completes without error
    await _addNavigatorInterface(
      featurePackage: featurePackage,
      navigationPackage: navigationPackage,
    );
    await _addNavigatorImplementation(featurePackage: featurePackage);
  }

  Future<void> _addNavigatorInterface({
    required PlatformRoutableFeaturePackage featurePackage,
    required PlatformNavigationPackage navigationPackage,
  }) async {
    final featureName = featurePackage.name;
    final navigatorInterface =
        navigationPackage.navigatorInterface(name: featureName.pascalCase);
    if (!navigatorInterface.existsAny) {
      await task('Creating navigator interface', () async {
        await navigatorInterface.generate();
        navigationPackage.barrelFile
            .addExport('src/i_${featureName.snakeCase}_navigator.dart');
      });
    } else {
      throw NavigatorInterfaceAlreadyExistsException._(featurePackage);
    }
  }

  Future<void> _addNavigatorImplementation({
    required PlatformRoutableFeaturePackage featurePackage,
  }) async {
    final navigatorImplementation = featurePackage.navigatorImplementation;
    if (!navigatorImplementation.existsAny) {
      await task(
        'Creating navigator implementation',
        () async => navigatorImplementation.generate(),
      );
      await codeGenTask(package: featurePackage);
    } else {
      throw NavigatorImplementationAlreadyExistsException._(featurePackage);
    }
  }

  Future<void> _removeNavigatorInterface({
    required PlatformRoutableFeaturePackage featurePackage,
    required PlatformNavigationPackage navigationPackage,
  }) async {
    final featureName = featurePackage.name;
    final navigatorInterface =
        navigationPackage.navigatorInterface(name: featureName.pascalCase);
    if (navigatorInterface.existsAny) {
      await task('Deleting navigator interface', () {
        navigatorInterface.delete();
        navigationPackage.barrelFile.removeExport(
          'src/i_${featureName.snakeCase}_navigator.dart',
        );
      });
    } else {
      throw NavigatorInterfaceNotFoundException._(featurePackage);
    }
  }

  Future<void> _removeNavigatorImplementation({
    required PlatformRoutableFeaturePackage featurePackage,
  }) async {
    final navigatorImplementation = featurePackage.navigatorImplementation;
    if (navigatorImplementation.existsAny) {
      await task(
        'Deleting navigator implementation',
        () => navigatorImplementation.delete(),
      );
      await codeGenTask(package: featurePackage);
    } else {
      throw NavigatorImplementationNotFoundException._(featurePackage);
    }
  }
}

class FeatureAlreadyExistsException extends RapidException {
  FeatureAlreadyExistsException._(
      PlatformFeaturePackage feature, Platform platform)
      : super(
          'Feature ${feature.name} already exists. (${platform.prettyName})',
        );
}

class FeatureNotFoundException extends RapidException {
  FeatureNotFoundException._(PlatformFeaturePackage feature, Platform platform)
      : super('Feature ${feature.name} not found. (${platform.prettyName})');
}

class NavigatorInterfaceAlreadyExistsException extends RapidException {
  NavigatorInterfaceAlreadyExistsException._(PlatformFeaturePackage feature)
      : super(
          'The navigator interface "I${feature.name.pascalCase}Navigator" does already exist. (${feature.platform.prettyName})',
        );
}

class NavigatorImplementationAlreadyExistsException extends RapidException {
  NavigatorImplementationAlreadyExistsException._(
      PlatformFeaturePackage feature)
      : super(
          'The navigator implementation "${feature.name.pascalCase}Navigator" does already exist. (${feature.platform.prettyName})',
        );
}

class FeatureNotRoutableException extends RapidException {
  FeatureNotRoutableException._(
      PlatformFeaturePackage feature, Platform platform)
      : super(
          'The feature ${feature.name} is not routable. (${platform.prettyName})',
        );
}

class LanguageAlreadyPresentException extends RapidException {
  LanguageAlreadyPresentException._(Language language)
      : super('The language "$language" is already present.');
}

class NavigatorInterfaceNotFoundException extends RapidException {
  NavigatorInterfaceNotFoundException._(PlatformFeaturePackage feature)
      : super(
          'Navigator interface "I${feature.name.pascalCase}Navigator" not found. (${feature.platform.prettyName})',
        );
}

class NavigatorImplementationNotFoundException extends RapidException {
  NavigatorImplementationNotFoundException._(PlatformFeaturePackage feature)
      : super(
          'Navigator implementation "${feature.name.pascalCase}Navigator" not found. (${feature.platform.prettyName})',
        );
}

class BlocAlreadyExistsException extends RapidException {
  BlocAlreadyExistsException._(
      String name, PlatformFeaturePackage feature, Platform platform)
      : super(
          'The ${name}Bloc does already exist in "${feature.name}". (${platform.prettyName})',
        );
}

class CubitAlreadyExistsException extends RapidException {
  CubitAlreadyExistsException._(
      String name, PlatformFeaturePackage feature, Platform platform)
      : super(
          'The ${name}Cubit does already exist in "${feature.name}". (${platform.prettyName})',
        );
}

class BlocNotFoundException extends RapidException {
  BlocNotFoundException._(
      String name, PlatformFeaturePackage feature, Platform platform)
      : super(
          '${name}Bloc not found in "${feature.name}". (${platform.prettyName})',
        );
}

class CubitNotFoundException extends RapidException {
  CubitNotFoundException._(
      String name, PlatformFeaturePackage feature, Platform platform)
      : super(
          '${name}Cubit not found in "${feature.name}". (${platform.prettyName})',
        );
}

class LanguageNotFoundException extends RapidException {
  LanguageNotFoundException._(Language language)
      : super('Language "$language" not found.');
}

class CantRemoveDefaultLanguageException extends RapidException {
  CantRemoveDefaultLanguageException._(Language language)
      : super(
          'Can not remove language "$language" because it is the default language.',
        );
}

class LanguageIsAlreadyDefaultLanguageException extends RapidException {
  LanguageIsAlreadyDefaultLanguageException._(Language language)
      : super('The language "$language" already is the default language.');
}

class PlatformNotActivatedException extends RapidException {
  PlatformNotActivatedException._(Platform platform)
      : super(
          'The platform ${platform.prettyName} is not activated. '
          'Use "rapid activate ${platform.prettyName}" to activate the platform first.',
        );
}
