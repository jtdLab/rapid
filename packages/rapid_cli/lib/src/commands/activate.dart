part of 'runner.dart';

mixin _ActivateMixin on _Rapid {
  Future<void> activateAndroid({
    required String description,
    required String orgName,
    required Language language,
  }) =>
      _activateAndroid(
        description: description,
        orgName: orgName,
        language: language,
      );

  Future<void> activateIos({
    required String orgName,
    required Language language,
  }) =>
      _activateIos(orgName: orgName, language: language);

  Future<void> activateLinux({
    required String orgName,
    required Language language,
  }) async =>
      _activateLinux(orgName: orgName, language: language);

  Future<void> activateMacos({
    required String orgName,
    required Language language,
  }) =>
      _activateMacos(orgName: orgName, language: language);

  Future<void> activateWeb({
    required String description,
    required Language language,
  }) =>
      _activateWeb(description: description, language: language);

  Future<void> activateWindows({
    required String orgName,
    required Language language,
  }) =>
      _activateWindows(orgName: orgName, language: language);

  Future<void> activateMobile({
    required String description,
    required String orgName,
    required Language language,
  }) =>
      _activateMobile(
        description: description,
        orgName: orgName,
        language: language,
      );

  Future<void> _activateAndroid({
    required String description,
    required String orgName,
    required Language language,
    bool calledFromCreate = false,
  }) async {
    final platform = Platform.android;
    await _wrapActivatePlatform(
      platform,
      calledFromCreate: calledFromCreate,
      activatePlatform: () async {
        final rootPackage = project.appModule
            .platformDirectory(platform: platform)
            .rootPackage as NoneIosRootPackage;
        await _activatePlatform(
          platform,
          language: language,
          generateRootPackage: () => rootPackage.generate(
            orgName: orgName,
            description: description,
          ),
          flutterConfigEnablePlatformTasks: [
            // TODO use task and do same for other platforms
            () => _flutterConfigEnablePlatformTask(platform: platform)
          ],
        );
      },
    );
  }

  Future<void> _activateIos({
    required String orgName,
    required Language language,
    bool calledFromCreate = false,
  }) async {
    final platform = Platform.ios;
    await _wrapActivatePlatform(
      platform,
      calledFromCreate: calledFromCreate,
      activatePlatform: () async {
        final rootPackage = project.appModule
            .platformDirectory(platform: platform)
            .rootPackage as IosRootPackage;
        await _activatePlatform(
          platform,
          language: language,
          generateRootPackage: () => rootPackage.generate(
            orgName: orgName,
            language: language,
          ),
          flutterConfigEnablePlatformTasks: [
            () => _flutterConfigEnablePlatformTask(platform: platform),
          ],
        );
      },
    );
  }

  Future<void> _activateLinux({
    required String orgName,
    required Language language,
    bool calledFromCreate = false,
  }) async {
    final platform = Platform.linux;
    await _wrapActivatePlatform(
      platform,
      calledFromCreate: calledFromCreate,
      activatePlatform: () async {
        final rootPackage = project.appModule
            .platformDirectory(platform: platform)
            .rootPackage as NoneIosRootPackage;
        await _activatePlatform(
          platform,
          language: language,
          generateRootPackage: () => rootPackage.generate(
            orgName: orgName,
          ),
          flutterConfigEnablePlatformTasks: [
            () => _flutterConfigEnablePlatformTask(platform: platform),
          ],
        );
      },
    );
  }

  Future<void> _activateMacos({
    required String orgName,
    required Language language,
    bool calledFromCreate = false,
  }) async {
    final platform = Platform.macos;
    return _wrapActivatePlatform(
      platform,
      calledFromCreate: calledFromCreate,
      activatePlatform: () async {
        final rootPackage = project.appModule
            .platformDirectory(platform: platform)
            .rootPackage as MacosRootPackage;
        await _activatePlatform(
          platform,
          language: language,
          generateRootPackage: () => rootPackage.generate(orgName: orgName),
          flutterConfigEnablePlatformTasks: [
            () => _flutterConfigEnablePlatformTask(platform: platform),
          ],
        );
      },
    );
  }

  Future<void> _activateWeb({
    required String description,
    required Language language,
    bool calledFromCreate = false,
  }) async {
    final platform = Platform.web;
    return _wrapActivatePlatform(
      platform,
      calledFromCreate: calledFromCreate,
      activatePlatform: () async {
        final rootPackage = project.appModule
            .platformDirectory(platform: platform)
            .rootPackage as NoneIosRootPackage;
        await _activatePlatform(
          platform,
          language: language,
          generateRootPackage: () => rootPackage.generate(
            description: description,
          ),
          flutterConfigEnablePlatformTasks: [
            () => _flutterConfigEnablePlatformTask(platform: platform),
          ],
        );
      },
    );
  }

  Future<void> _activateWindows({
    required String orgName,
    required Language language,
    bool calledFromCreate = false,
  }) async {
    final platform = Platform.windows;
    return _wrapActivatePlatform(
      platform,
      calledFromCreate: calledFromCreate,
      activatePlatform: () async {
        final rootPackage = project.appModule
            .platformDirectory(platform: platform)
            .rootPackage as NoneIosRootPackage;
        await _activatePlatform(
          platform,
          language: language,
          generateRootPackage: () => rootPackage.generate(
            orgName: orgName,
          ),
          flutterConfigEnablePlatformTasks: [
            () => _flutterConfigEnablePlatformTask(platform: platform),
          ],
        );
      },
    );
  }

  Future<void> _activateMobile({
    required String description,
    required String orgName,
    required Language language,
    bool calledFromCreate = false,
  }) async {
    final platform = Platform.mobile;
    return _wrapActivatePlatform(
      platform,
      calledFromCreate: calledFromCreate,
      activatePlatform: () async {
        final rootPackage = project.appModule
            .platformDirectory(platform: platform)
            .rootPackage as MobileRootPackage;
        await _activatePlatform(
          platform,
          language: language,
          generateRootPackage: () => rootPackage.generate(
            orgName: orgName,
            description: description,
            language: language,
          ),
          flutterConfigEnablePlatformTasks: [
            () => _flutterConfigEnablePlatformTask(platform: Platform.android),
            () => _flutterConfigEnablePlatformTask(platform: Platform.ios),
          ],
        );
      },
    );
  }

  /// Checks wheter [platform] can be activated.
  /// If true executes [activatePlatform].
  /// Afterwards if [cleanup] runs cleanup and logs sucess.
  ///
  /// [cleanup] beeing false indicates the platform activate
  ///  was issued from the create command.
  Future<void> _wrapActivatePlatform(
    Platform platform, {
    required bool calledFromCreate,
    required Future<void> Function() activatePlatform,
  }) async {
    if (project.platformIsActivated(platform)) {
      throw PlatformAlreadyActivatedException._(platform);
    }

    if (!calledFromCreate) {
      logger.newLine();
    }

    await activatePlatform();

    if (!calledFromCreate) {
      logger.newLine();

      await dartFormatFixTask();

      logger
        ..newLine()
        ..commandSuccess('Activated ${platform.prettyName}!');
    }
  }

  Future<void> _activatePlatform(
    Platform platform, {
    required Language language,
    required Future<void> Function() generateRootPackage,
    required List<Future<void> Function()> flutterConfigEnablePlatformTasks,
  }) async {
    final platformDirectory =
        project.appModule.platformDirectory(platform: platform);
    final appFeaturePackage =
        platformDirectory.featuresDirectory.appFeaturePackage;
    final homePageFeaturePackage = platformDirectory.featuresDirectory
        .featurePackage<PlatformPageFeaturePackage>(name: 'home_page');
    final localizationPackage = platformDirectory.localizationPackage;
    final navigationPackage = platformDirectory.navigationPackage;
    final rootPackage = platformDirectory.rootPackage;
    final platformUiPackage =
        project.uiModule.platformUiPackage(platform: platform);
    final infrastructurePackages =
        project.appModule.infrastructureDirectory.infrastructurePackages();

    await taskGroup(
      description:
          '$rocket ${taskGroupTitleStyle('Activating ${platform.prettyName}')}',
      tasks: [
        (
          'Generating ${platform.prettyName} packages',
          () async {
            await appFeaturePackage.generate();
            await homePageFeaturePackage.generate();
            await localizationPackage.generate(defaultLanguage: language);
            await navigationPackage.generate();
            await generateRootPackage();
            await platformUiPackage.generate();
          },
        ),
      ],
      parallelism: 1,
    );

    final infrastructureContainsNonDefaultPackage =
        infrastructurePackages.any((e) => !e.isDefault);
    if (infrastructureContainsNonDefaultPackage) {
      for (final infrastructurePackage
          in infrastructurePackages.where((e) => !e.isDefault)) {
        await rootPackage.registerInfrastructurePackage(infrastructurePackage);
      }
    }

    await flutterPubGetTaskGroup(
      packages: [
        appFeaturePackage,
        homePageFeaturePackage,
        localizationPackage,
        navigationPackage,
        rootPackage,
        platformUiPackage,
      ],
    );

    if (infrastructureContainsNonDefaultPackage) {
      await flutterPubRunBuildRunnerBuildDeleteConflictingOutputsTask(
        package: rootPackage,
      );
    }

    await flutterGenl10nTask(package: localizationPackage);

    for (final flutterConfigEnablePlatform
        in flutterConfigEnablePlatformTasks) {
      await flutterConfigEnablePlatform();
    }
  }

  Future<void> _flutterConfigEnablePlatformTask({
    required Platform platform,
  }) async {
    final commandString = switch (platform) {
      Platform.android => 'flutter config --enable-android',
      Platform.ios => 'flutter config --enable-ios',
      Platform.linux => 'flutter config --enable-linux-desktop',
      Platform.macos => 'flutter config --enable-macos-desktop',
      Platform.web => 'flutter config --enable-web',
      _ => 'flutter config --enable-windows-desktop',
    };
    return task(
      'Running "$commandString"',
      () async => flutterConfigEnable(platform: platform, project: project),
    );
  }
}

typedef PlatformDirectoryBuilder = Future<PlatformDirectory> Function(
  RapidProject project,
);

class PlatformAlreadyActivatedException extends RapidException {
  PlatformAlreadyActivatedException._(Platform platform)
      : super('The platform ${platform.prettyName} is already activated.');
}
