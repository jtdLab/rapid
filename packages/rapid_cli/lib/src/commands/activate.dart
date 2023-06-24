part of 'runner.dart';

mixin _ActivateMixin on _Rapid {
  Future<void> activateAndroid({
    required String description,
    required String orgName,
    required String language,
  }) async {
    return _activatePlatform(
      Platform.android,
      (project) async {
        final platformDirectory = project.platformDirectory<NoneIosDirectory>(
          platform: Platform.android,
        );
        await platformDirectory.create(
          description: description,
          orgName: orgName,
          language: language,
        );

        return platformDirectory;
      },
    );
  }

  Future<void> activateIos({
    required String orgName,
    required String language,
  }) async {
    return _activatePlatform(
      Platform.ios,
      (project) async {
        final platformDirectory = project.platformDirectory<IosDirectory>(
          platform: Platform.ios,
        );
        await platformDirectory.create(
          orgName: orgName,
          language: language,
        );

        return platformDirectory;
      },
    );
  }

  Future<void> activateLinux({
    required String orgName,
    required String language,
  }) async {
    return _activatePlatform(
      Platform.linux,
      (project) async {
        final platformDirectory = project.platformDirectory<NoneIosDirectory>(
          platform: Platform.linux,
        );
        await platformDirectory.create(
          orgName: orgName,
          language: language,
        );

        return platformDirectory;
      },
    );
  }

  Future<void> activateMacos({
    required String orgName,
    required String language,
  }) async {
    return _activatePlatform(
      Platform.macos,
      (project) async {
        final platformDirectory = project.platformDirectory<NoneIosDirectory>(
          platform: Platform.macos,
        );
        await platformDirectory.create(
          orgName: orgName,
          language: language,
        );

        return platformDirectory;
      },
    );
  }

  Future<void> activateWeb({
    required String description,
    required String language,
  }) async {
    return _activatePlatform(
      Platform.web,
      (project) async {
        final platformDirectory = project.platformDirectory<NoneIosDirectory>(
          platform: Platform.web,
        );
        await platformDirectory.create(
          description: description,
          language: language,
        );

        return platformDirectory;
      },
    );
  }

  Future<void> activateWindows({
    required String orgName,
    required String language,
  }) async {
    return _activatePlatform(
      Platform.windows,
      (project) async {
        final platformDirectory = project.platformDirectory<NoneIosDirectory>(
          platform: Platform.windows,
        );
        await platformDirectory.create(
          orgName: orgName,
          language: language,
        );

        return platformDirectory;
      },
    );
  }

  Future<void> activateMobile({
    required String description,
    required String orgName,
    required String language,
  }) async {
    return _activatePlatform(
      Platform.mobile,
      (project) async {
        final platformDirectory = project.platformDirectory<MobileDirectory>(
          platform: Platform.mobile,
        );
        await platformDirectory.create(
          orgName: orgName,
          language: language,
          description: description,
        );

        return platformDirectory;
      },
    );
  }

  Future<void> _activatePlatform(
    Platform platform,
    PlatformDirectoryBuilder createPlatformDirectory,
  ) async {
    if (project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidActivateException._platformAlreadyActivated(platform),
      );
    }

    logger
      ..command('rapid activate ${platform.name}')
      ..newLine();

    final platformDirectory = await task(
      'Create platform directory (${platform.prettyName})',
      () async => createPlatformDirectory(project),
    );

    final platformUiPackage = await task(
      'Create platform ui package (${platform.prettyName})',
      () async {
        final platformUiPackage = project.platformUiPackage(platform: platform);
        await platformUiPackage.create();
        return platformUiPackage;
      },
    );

    final platformRootPackage = platformDirectory.rootPackage;
    final platformNavigationPackage = platformDirectory.navigationPackage;
    final platformFeaturePackages =
        platformDirectory.featuresDirectory.featurePackages();

    await bootstrap(
      packages: [
        platformRootPackage,
        platformNavigationPackage,
        ...platformFeaturePackages,
        platformUiPackage,
      ],
    );

    await codeGen(packages: [platformRootPackage]);

    await flutterGenl10n(
      project.featurePackages.where((e) => e.hasLanguages).toList(),
    );

    await dartFormatFix(project);

    switch (platform) {
      case (Platform.android || Platform.mobile):
        await flutterConfigEnableAndroid(project);
      case (Platform.ios || Platform.mobile):
        await flutterConfigEnableIos(project);
      case Platform.linux:
        await flutterConfigEnableLinux(project);
      case Platform.macos:
        await flutterConfigEnableMacos(project);
      case Platform.web:
        await flutterConfigEnableWeb(project);
      case Platform.windows:
        await flutterConfigEnableWindows(project);
    }

    logger
      ..newLine()
      ..success('Success $checkLabel');
  }
}

typedef PlatformDirectoryBuilder = Future<PlatformDirectory> Function(
  RapidProject project,
);

class RapidActivateException extends RapidException {
  RapidActivateException._(super.message);

  factory RapidActivateException._platformAlreadyActivated(
    Platform platform,
  ) {
    return RapidActivateException._(
      'The platform ${platform.prettyName} is already activated.',
    );
  }

  @override
  String toString() {
    return 'RapidActivateException: $message';
  }
}
