part of 'runner.dart';

mixin _PlatformMixin on _Rapid {
  Future<void> platformAddFeatureCustom(
    Platform platform, {
    required String name,
    required String description,
    required bool routing,
    required bool navigator,
    required bool localization,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} add feature custom')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    final featurePackage = platformDirectory.featuresDirectory
        .featurePackage<PlatformCustomFeaturePackage>(name: name);
    if (!featurePackage.exists()) {
      final rootPackage = platformDirectory.rootPackage;

      await featurePackage.create(
        description: description,
        routing: routing,
        localization: localization,
        // TODO take default lang from featurs or from roots supported langs?
        defaultLanguage: rootPackage.defaultLanguage(),
        languages: rootPackage.supportedLanguages(),
      );

      await rootPackage.registerFeaturePackage(
        featurePackage,
        routing: routing,
        localization: localization,
      );

      if (navigator) {
        // TODO share ?
        final featureName = featurePackage.name;
        final navigationPackage = platformDirectory.navigationPackage;
        final navigator =
            navigationPackage.navigator(name: featureName.pascalCase);
        if (!navigator.existsAny()) {
          final barrelFile = navigationPackage.barrelFile;

          await navigator.create();

          barrelFile.addExport(
            'src/i_${featureName.snakeCase}_navigator.dart',
          );

          // TODO check if the impl is already available
          final navigatorImplementation =
              featurePackage.navigatorImplementation;
          await navigatorImplementation.create();
        }
      }

      await bootstrap(packages: [rootPackage, featurePackage]);

      await codeGen(packages: [
        rootPackage,
        if (navigator) featurePackage,
      ]);

      if (localization) {
        await flutterGenl10n([featurePackage]);
      }

      await dartFormatFix(project);

      // TODO add link doc to navigation and routing approach
      logger.newLine();
      logger.success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidPlatformException._featureAlreadyExists(name, platform: platform),
      );
    }
  }

  Future<void> platformAddFeatureFlow(
    Platform platform, {
    required String name,
    required bool tab,
    required String description,
    required bool navigator,
    required bool localization,
    required Set<String>? features,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} add feature flow')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    final featurePackage = platformDirectory.featuresDirectory
        .featurePackage<PlatformFlowFeaturePackage>(name: '${name}_flow');
    if (!featurePackage.exists()) {
      final List<PlatformFeaturePackage> featurePackages = [];
      if (tab) {
        for (final feature in features!) {
          if (platformDirectory.featuresDirectory
              .featurePackages()
              .any((e) => feature == e.packageName() || feature == e.name)) {
            featurePackages.add(
              platformDirectory.featuresDirectory.featurePackages().firstWhere(
                  (e) => feature == e.packageName() || feature == e.name),
            );
          } else {
            _logAndThrow(
              RapidPlatformException._featureNotFound(
                feature,
                platform: platform,
              ),
            );
          }
        }
      }

      final rootPackage = platformDirectory.rootPackage;

      await featurePackage.create(
        tab: tab,
        description: description,
        localization: localization,
        // TODO take default lang from featurs or from roots supported langs?
        defaultLanguage: rootPackage.defaultLanguage(),
        languages: rootPackage.supportedLanguages(),
        features: tab ? featurePackages.toSet() : null,
      );

      await rootPackage.registerFeaturePackage(
        featurePackage,
        routing: true,
        localization: localization,
      );

      if (navigator) {
        // TODO share ?
        final featureName = featurePackage.name;
        final navigationPackage = platformDirectory.navigationPackage;
        final navigator =
            navigationPackage.navigator(name: featureName.pascalCase);
        if (!navigator.existsAny()) {
          final barrelFile = navigationPackage.barrelFile;

          await navigator.create();

          barrelFile.addExport(
            'src/i_${featureName.snakeCase}_navigator.dart',
          );

          // TODO check if the impl is already available
          final navigatorImplementation =
              featurePackage.navigatorImplementation;
          await navigatorImplementation.create();
        }
      }

      await bootstrap(packages: [rootPackage, featurePackage]);

      await codeGen(packages: [
        rootPackage,
        if (navigator) featurePackage,
      ]);

      if (localization) {
        await flutterGenl10n([featurePackage]);
      }

      await dartFormatFix(project);

      // TODO add link doc to navigation and routing approach
      logger.newLine();
      logger.success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidPlatformException._featureAlreadyExists(
          '${name}_flow',
          platform: platform,
        ),
      );
    }
  }

  Future<void> platformAddFeaturePage(
    Platform platform, {
    required String name,
    required String description,
    required bool navigator,
    required bool localization,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} add feature page')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    final featurePackage = platformDirectory.featuresDirectory
        .featurePackage<PlatformPageFeaturePackage>(name: '${name}_page');
    if (!featurePackage.exists()) {
      final rootPackage = platformDirectory.rootPackage;

      await featurePackage.create(
        description: description,
        localization: localization,
        // TODO take default lang from featurs or from roots supported langs?
        defaultLanguage: rootPackage.defaultLanguage(),
        languages: rootPackage.supportedLanguages(),
      );

      await rootPackage.registerFeaturePackage(
        featurePackage,
        routing: true,
        localization: localization,
      );

      if (navigator) {
        // TODO share ?
        final featureName = featurePackage.name;
        final navigationPackage = platformDirectory.navigationPackage;
        final navigator =
            navigationPackage.navigator(name: featureName.pascalCase);
        if (!navigator.existsAny()) {
          final barrelFile = navigationPackage.barrelFile;

          await navigator.create();

          barrelFile.addExport(
            'src/i_${featureName.snakeCase}_navigator.dart',
          );

          // TODO check if the impl is already available
          final navigatorImplementation =
              featurePackage.navigatorImplementation;
          await navigatorImplementation.create();
        }
      }

      await bootstrap(packages: [rootPackage, featurePackage]);

      await codeGen(packages: [
        rootPackage,
        if (navigator) featurePackage,
      ]);

      if (localization) {
        await flutterGenl10n([featurePackage]);
      }

      await dartFormatFix(project);

      // TODO add link doc to navigation and routing approach
      logger.newLine();
      logger.success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidPlatformException._featureAlreadyExists(
          '${name}_page',
          platform: platform,
        ),
      );
    }
  }

  Future<void> platformAddFeatureWidget(
    Platform platform, {
    required String name,
    required String description,
    required bool localization,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} add feature widget')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    final featurePackage = platformDirectory.featuresDirectory
        .featurePackage<PlatformWidgetFeaturePackage>(name: '${name}_widget');
    if (!featurePackage.exists()) {
      final rootPackage = platformDirectory.rootPackage;

      await featurePackage.create(
        description: description,
        localization: localization,
        // TODO take default lang from featurs or from roots supported langs?
        defaultLanguage: rootPackage.defaultLanguage(),
        languages: rootPackage.supportedLanguages(),
      );

      await rootPackage.registerFeaturePackage(
        featurePackage,
        routing: false,
        localization: localization,
      );

      await bootstrap(packages: [rootPackage, featurePackage]);

      await codeGen(packages: [
        rootPackage,
      ]);

      if (localization) {
        await flutterGenl10n([featurePackage]);
      }

      await dartFormatFix(project);

      // TODO add link doc to navigation and routing approach
      logger.newLine();
      logger.success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidPlatformException._featureAlreadyExists(
          '${name}_widget',
          platform: platform,
        ),
      );
    }
  }

  Future<void> platformAddLanguage(
    Platform platform, {
    required String language,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} add language')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    final featurePackagesWithLanguages = platformDirectory.featuresDirectory
        .featurePackages()
        .where((e) => e.hasLanguages)
        .toList();
    if (featurePackagesWithLanguages.isEmpty) {
      _logAndThrow(
        RapidPlatformException._noFeaturesWithLocalizationFound(platform),
      );
    }

    if (!featurePackagesWithLanguages.supportSameLanguages()) {
      _logAndThrow(
        RapidPlatformException._projectCorrupted(
          'Because not all features support the same languages.',
          platform: platform,
        ),
      );
    }

    if (!featurePackagesWithLanguages.haveSameDefaultLanguage()) {
      _logAndThrow(
        RapidPlatformException._projectCorrupted(
          'Because not all features have the same default language.',
          platform: platform,
        ),
      );
    }

    if (featurePackagesWithLanguages.supportLanguage(language)) {
      _logAndThrow(
        RapidPlatformException._languageAlreadyPresent(language),
      );
    }

    await platformDirectory.rootPackage.addLanguage(language);

    for (final featurePackage in featurePackagesWithLanguages) {
      await featurePackage.addLanguage(language);
    }

    await flutterGenl10n(featurePackagesWithLanguages);

    await dartFormatFix(project);

    // TODO add hint how to work with localization
    logger.newLine();
    logger.success('Success $checkLabel');
  }

  Future<void> platformAddNavigator(
    Platform platform, {
    required String featureName,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} add navigator')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    late final PlatformRoutableFeaturePackage featurePackage;
    try {
      featurePackage = platformDirectory.featuresDirectory
          .featurePackage<PlatformRoutableFeaturePackage>(name: featureName);
    } catch (_) {
      _logAndThrow(
        RapidPlatformException._featureNotRoutable(
          featureName,
          platform: platform,
        ),
      );
    }
    if (featurePackage.exists()) {
      final navigationPackage = platformDirectory.navigationPackage;
      final navigator =
          navigationPackage.navigator(name: featureName.pascalCase);

      if (!navigator.existsAny()) {
        final barrelFile = navigationPackage.barrelFile;

        await navigator.create();

        barrelFile.addExport(
          'src/i_${featureName.snakeCase}_navigator.dart',
        );

        // TODO check if the impl is already available
        final navigatorImplementation = featurePackage.navigatorImplementation;
        await navigatorImplementation.create();

        await codeGen(packages: [featurePackage]);

        await dartFormatFix(project);

        logger.newLine();
        logger.success('Success $checkLabel');
      } else {
        _logAndThrow(
          RapidPlatformException._navigatorAlreadyExists(
            featureName,
            platform: platform,
          ),
        );
      }
    } else {
      _logAndThrow(
        RapidPlatformException._featureNotFound(
          featureName,
          platform: platform,
        ),
      );
    }
  }

  Future<void> platformFeatureAddBloc(
    Platform platform, {
    required String name,
    required String featureName,
    required String outputDir,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} $featureName add bloc')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    final featurePackage =
        platformDirectory.featuresDirectory.featurePackage(name: featureName);
    if (featurePackage.exists()) {
      final bloc = featurePackage.bloc(name: name, dir: outputDir);
      if (!bloc.existsAny()) {
        await bloc.create();

        final applicationBarrelFile = featurePackage.applicationBarrelFile;
        if (!applicationBarrelFile.exists()) {
          final barrelFile = featurePackage.barrelFile;

          await applicationBarrelFile.create();

          applicationBarrelFile.addExport(
            p.normalize(
              p.join(outputDir, '${name.snakeCase}_bloc.dart'),
            ),
          );

          barrelFile.addExport('src/application/application.dart');
        } else {
          applicationBarrelFile.addExport(
            p.normalize(
              p.join(outputDir, '${name.snakeCase}_bloc.dart'),
            ),
          );
        }

        await codeGen(packages: [featurePackage]);

        logger.newLine();
        logger.success('Success $checkLabel');
      } else {
        _logAndThrow(
          // TODO use output dir
          RapidPlatformException._blocAlreadyExists(
            name,
            featureName,
            platform: platform,
          ),
        );
      }
    } else {
      _logAndThrow(
        RapidPlatformException._featureNotFound(
          featureName,
          platform: platform,
        ),
      );
    }
  }

  Future<void> platformFeatureAddCubit(
    Platform platform, {
    required String name,
    required String featureName,
    required String outputDir,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} $featureName add cubit')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);

    final featurePackage =
        platformDirectory.featuresDirectory.featurePackage(name: featureName);
    if (featurePackage.exists()) {
      final cubit = featurePackage.cubit(name: name, dir: outputDir);
      if (!cubit.existsAny()) {
        await cubit.create();

        final applicationBarrelFile = featurePackage.applicationBarrelFile;
        if (!applicationBarrelFile.exists()) {
          final barrelFile = featurePackage.barrelFile;

          await applicationBarrelFile.create();
          applicationBarrelFile.addExport(
            p.normalize(p.join(outputDir, '${name.snakeCase}_cubit.dart')),
          );

          barrelFile.addExport('src/application/application.dart');
        } else {
          applicationBarrelFile.addExport(
            p.normalize(
              p.join(outputDir, '${name.snakeCase}_cubit.dart'),
            ),
          );
        }

        await codeGen(packages: [featurePackage]);

        logger.newLine();
        logger.success('Success $checkLabel');
      } else {
        _logAndThrow(
          // TODO use output dir
          RapidPlatformException._cubitAlreadyExists(
            name,
            featureName,
            platform: platform,
          ),
        );
      }
    } else {
      _logAndThrow(
        RapidPlatformException._featureNotFound(
          featureName,
          platform: platform,
        ),
      );
    }
  }

  Future<void> platformFeatureRemoveBloc(
    Platform platform, {
    required String name,
    required String featureName,
    required String dir,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} $featureName remove bloc')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    final featurePackage =
        platformDirectory.featuresDirectory.featurePackage(name: featureName);
    if (featurePackage.exists()) {
      final bloc = featurePackage.bloc(name: name, dir: dir);
      if (bloc.existsAny()) {
        final applicationBarrelFile = featurePackage.applicationBarrelFile;

        bloc.delete();

        // TODO delete application dir if empty

        applicationBarrelFile.removeExport(
          p.normalize(
            p.join(dir, '${name.snakeCase}_bloc.dart'),
          ),
        );
        if (applicationBarrelFile.read().trim().isEmpty) {
          applicationBarrelFile.delete();
          final barrelFile = featurePackage.barrelFile;
          barrelFile.removeExport('src/application/application.dart');
        }

        await codeGen(packages: [featurePackage]);

        logger.newLine();
        logger.success('Success $checkLabel');
      } else {
        _logAndThrow(
          RapidPlatformException._blocNotFound(
            name,
            featureName,
            platform: platform,
          ),
        );
      }
    } else {
      _logAndThrow(
        RapidPlatformException._featureNotFound(
          featureName,
          platform: platform,
        ),
      );
    }
  }

  Future<void> platformFeatureRemoveCubit(
    Platform platform, {
    required String name,
    required String featureName,
    required String dir,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} $featureName remove cubit')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    final featurePackage =
        platformDirectory.featuresDirectory.featurePackage(name: featureName);
    if (featurePackage.exists()) {
      final cubit = featurePackage.cubit(name: name, dir: dir);
      if (cubit.existsAny()) {
        final applicationBarrelFile = featurePackage.applicationBarrelFile;

        cubit.delete();
        // TODO delete application dir if empty

        applicationBarrelFile.removeExport(
          p.normalize(p.join(dir, '${name.snakeCase}_cubit.dart')),
        );
        if (applicationBarrelFile.read().trim().isEmpty) {
          applicationBarrelFile.delete();
          final barrelFile = featurePackage.barrelFile;
          barrelFile.removeExport('src/application/application.dart');
        }

        await codeGen(packages: [featurePackage]);

        logger.newLine();
        logger.success('Success $checkLabel');
      } else {
        _logAndThrow(
          RapidPlatformException._cubitNotFound(
            name,
            featureName,
            platform: platform,
          ),
        );
      }
    } else {
      _logAndThrow(
        RapidPlatformException._featureNotFound(
          featureName,
          platform: platform,
        ),
      );
    }
  }

  Future<void> platformRemoveFeature(
    Platform platform, {
    required String name,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} remove feature')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    final featuresDirectory = platformDirectory.featuresDirectory;
    final featurePackage = featuresDirectory.featurePackage(name: name);
    if (featurePackage.exists()) {
      final rootPackage = platformDirectory.rootPackage;
      await rootPackage.unregisterFeaturePackage(featurePackage);

      final remainingFeaturePackages = featuresDirectory.featurePackages()
        ..remove(featurePackage);

      for (final remainingFeaturePackage in remainingFeaturePackages) {
        final pubspecFile = remainingFeaturePackage.pubspecFile;
        pubspecFile.removeDependency(featurePackage.packageName());
      }

      featurePackage.delete();

      // TODO share ?
      final featureName = featurePackage.name;
      final navigationPackage = platformDirectory.navigationPackage;
      final navigator =
          navigationPackage.navigator(name: featureName.pascalCase);
      if (navigator.existsAny()) {
        navigator.delete();
        navigationPackage.barrelFile.removeExport(
          'src/i_${featureName.snakeCase}_navigator.dart',
        );
      }

      await bootstrap(
        packages: [
          ...remainingFeaturePackages,
          rootPackage,
        ],
      );

      await codeGen(packages: [rootPackage]);

      logger.newLine();
      logger.success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidPlatformException._featureNotFound(
          name,
          platform: platform,
        ),
      );
    }
  }

  Future<void> platformRemoveLanguage(
    Platform platform, {
    required String language,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} remove language')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    final featurePackagesWithLanguages = platformDirectory.featuresDirectory
        .featurePackages()
        .where((e) => e.hasLanguages)
        .toList();
    if (featurePackagesWithLanguages.isEmpty) {
      _logAndThrow(
        RapidPlatformException._noFeaturesWithLocalizationFound(platform),
      );
    }

    if (!featurePackagesWithLanguages.supportSameLanguages()) {
      _logAndThrow(
        RapidPlatformException._projectCorrupted(
          'Because not all features support the same languages.',
          platform: platform,
        ),
      );
    }

    if (!featurePackagesWithLanguages.haveSameDefaultLanguage()) {
      _logAndThrow(
        RapidPlatformException._projectCorrupted(
          'Because not all features have the same default language.',
          platform: platform,
        ),
      );
    }

    if (!featurePackagesWithLanguages.supportLanguage(language)) {
      // TODO better hint
      _logAndThrow(
        RapidPlatformException._languageNotFound(language),
      );
    }

    if (featurePackagesWithLanguages.first.defaultLanguage() == language) {
      // TODO add hint how to change default language
      _logAndThrow(
        RapidPlatformException._cantRemoveDefaultLanguage(language),
      );
    }

    final rootPackage = platformDirectory.rootPackage;
    await rootPackage.removeLanguage(language);

    for (final featurePackage in featurePackagesWithLanguages) {
      await featurePackage.removeLanguage(language);
    }

    await flutterGenl10n(featurePackagesWithLanguages);

    await dartFormatFix(project);

    logger.newLine();
    logger.success('Success $checkLabel');
  }

  Future<void> platformRemoveNavigator(
    Platform platform, {
    required String featureName,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} remove navigator')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    late final PlatformRoutableFeaturePackage featurePackage;
    try {
      featurePackage = platformDirectory.featuresDirectory
          .featurePackage<PlatformRoutableFeaturePackage>(name: featureName);
    } catch (_) {
      _logAndThrow(
        RapidPlatformException._featureNotRoutable(
          featureName,
          platform: platform,
        ),
      );
    }
    if (featurePackage.exists()) {
      final navigationPackage = platformDirectory.navigationPackage;
      final navigator =
          navigationPackage.navigator(name: featureName.pascalCase);

      if (navigator.existsAny()) {
        navigator.delete();
        navigationPackage.barrelFile.removeExport(
          'src/i_${featureName.snakeCase}_navigator.dart',
        );

        // TODO check if the impl is already available
        final navigatorImplementation = featurePackage.navigatorImplementation;
        navigatorImplementation.delete();

        await codeGen(packages: [featurePackage]);

        await dartFormatFix(project);

        logger.newLine();
        logger.success('Success $checkLabel');
      } else {
        _logAndThrow(
          RapidPlatformException._navigatorNotFound(
            featureName,
            platform: platform,
          ),
        );
      }
    } else {
      _logAndThrow(
        RapidPlatformException._featureNotFound(
          featureName,
          platform: platform,
        ),
      );
    }
  }

  Future<void> platformSetDefaultLanguage(
    Platform platform, {
    required String language,
  }) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidPlatformException._platformNotActivated(platform),
      );
    }

    logger
      ..command('rapid ${platform.name} set default_language')
      ..newLine();

    final platformDirectory = project.platformDirectory(platform: platform);
    final featurePackagesWithLanguages = platformDirectory.featuresDirectory
        .featurePackages()
        .where((e) => e.hasLanguages)
        .toList();

    if (featurePackagesWithLanguages.isEmpty) {
      _logAndThrow(
        RapidPlatformException._noFeaturesWithLocalizationFound(platform),
      );
    }

    if (!featurePackagesWithLanguages.supportSameLanguages()) {
      _logAndThrow(
        RapidPlatformException._projectCorrupted(
          'Because not all features support the same languages.',
          platform: platform,
        ),
      );
    }

    if (!featurePackagesWithLanguages.haveSameDefaultLanguage()) {
      _logAndThrow(
        RapidPlatformException._projectCorrupted(
          'Because not all features have the same default language.',
          platform: platform,
        ),
      );
    }

    if (!featurePackagesWithLanguages.supportLanguage(language)) {
      _logAndThrow(
        RapidPlatformException._languageNotFound(language),
      );
    }

    if (featurePackagesWithLanguages.first.defaultLanguage() == language) {
      _logAndThrow(
        RapidPlatformException._languageIsAlreadyDefaultLanguage(language),
      );
    }

    for (final featurePackage in featurePackagesWithLanguages) {
      await featurePackage.setDefaultLanguage(language);
    }

    await flutterGenl10n(featurePackagesWithLanguages);

    await dartFormatFix(project);

    // TODO add hint how to work with localization
    logger.newLine();
    logger.success('Success $checkLabel');
  }
}

class RapidPlatformException extends RapidException {
  RapidPlatformException._(super.message);

  factory RapidPlatformException._featureAlreadyExists(
    String name, {
    required Platform platform,
  }) {
    return RapidPlatformException._(
      'Feature $name already exists. (${platform.prettyName})',
    );
  }

  factory RapidPlatformException._featureNotFound(
    String name, {
    required Platform platform,
  }) {
    return RapidPlatformException._(
      'Feature $name not found. (${platform.prettyName})',
    );
  }

  factory RapidPlatformException._navigatorNotFound(
    String featureName, {
    required Platform platform,
  }) {
    return RapidPlatformException._(
      'The navigator "I${featureName.pascalCase}Navigator" does not exist. (${platform.prettyName})',
    );
  }

  factory RapidPlatformException._featureNotRoutable(
    String featureName, {
    required Platform platform,
  }) {
    return RapidPlatformException._(
      'The feature $featureName is not routable. (${platform.prettyName})',
    );
  }

  factory RapidPlatformException._projectCorrupted(
    String reason, {
    required Platform platform,
  }) {
    return RapidPlatformException._(
      'ProjectCorrputedException: The ${platform.prettyName} part of your project is corrupted.\n'
      '$reason\n\n'
      'Run "rapid doctor" to see which features are affected.',
    );
  }

  factory RapidPlatformException._noFeaturesWithLocalizationFound(
      Platform platform) {
    return RapidPlatformException._(
      'No ${platform.prettyName} features with localizations found!\n'
      'Run "rapid ${platform.name} add feature" to add your first ${platform.prettyName} feature.',
    );
  }

  factory RapidPlatformException._languageAlreadyPresent(String language) {
    return RapidPlatformException._(
      'The language "$language" is already present.',
    );
  }

  factory RapidPlatformException._navigatorAlreadyExists(
    String featureName, {
    required Platform platform,
  }) {
    return RapidPlatformException._(
      'The Navigator "I${featureName.pascalCase}Navigator" does already exist. (${platform.prettyName})',
    );
  }

  factory RapidPlatformException._blocAlreadyExists(
    String name,
    String featureName, {
    required Platform platform,
  }) {
    return RapidPlatformException._(
      'The ${name}Bloc does already exist in "$featureName". (${platform.prettyName})',
    );
  }

  factory RapidPlatformException._cubitAlreadyExists(
    String name,
    String featureName, {
    required Platform platform,
  }) {
    return RapidPlatformException._(
      'The ${name}Cubit does already exist in "$featureName". (${platform.prettyName})',
    );
  }

  factory RapidPlatformException._blocNotFound(
    String name,
    String featureName, {
    required Platform platform,
  }) {
    return RapidPlatformException._(
      'The ${name}Bloc does not exist in "$featureName". (${platform.prettyName})',
    );
  }

  factory RapidPlatformException._cubitNotFound(
    String name,
    String featureName, {
    required Platform platform,
  }) {
    return RapidPlatformException._(
      'The ${name}Cubit does not exist in "$featureName". (${platform.prettyName})',
    );
  }

  factory RapidPlatformException._languageNotFound(String language) {
    return RapidPlatformException._(
      'The language "$language" is not present.',
    );
  }

  factory RapidPlatformException._cantRemoveDefaultLanguage(String language) {
    return RapidPlatformException._(
      'Can not remove language "$language" because it is the default language.',
    );
  }

  factory RapidPlatformException._languageIsAlreadyDefaultLanguage(
    String language,
  ) {
    return RapidPlatformException._(
      'The language "$language" already is the default language.',
    );
  }

  factory RapidPlatformException._platformNotActivated(
    Platform platform,
  ) {
    return RapidPlatformException._(
      'The platform ${platform.prettyName} is not activated. '
      'Use "rapid activate ${platform.prettyName}" to activate the platform first.',
    );
  }

  @override
  String toString() {
    return 'RapidPlatformException: $message';
  }
}
