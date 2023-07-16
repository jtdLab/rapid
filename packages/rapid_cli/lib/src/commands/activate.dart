part of 'runner.dart';

mixin _ActivateMixin on _Rapid {
  Future<void> activateAndroid({
    required String description,
    required String orgName,
    required Language language,
  }) async =>
      _activatePlatform(
        Platform.android,
        description: description,
        orgName: orgName,
        language: language,
      );

  Future<void> activateIos({
    required String orgName,
    required Language language,
  }) async =>
      _activatePlatform(
        Platform.ios,
        orgName: orgName,
        language: language,
      );

  Future<void> activateLinux({
    required String orgName,
    required Language language,
  }) async =>
      _activatePlatform(
        Platform.linux,
        orgName: orgName,
        language: language,
      );

  Future<void> activateMacos({
    required String orgName,
    required Language language,
  }) async =>
      _activatePlatform(
        Platform.macos,
        orgName: orgName,
        language: language,
      );

  Future<void> activateWeb({
    required String description,
    required Language language,
  }) async =>
      _activatePlatform(
        Platform.web,
        description: description,
        language: language,
      );

  Future<void> activateWindows({
    required String orgName,
    required Language language,
  }) async =>
      _activatePlatform(
        Platform.windows,
        orgName: orgName,
        language: language,
      );

  Future<void> activateMobile({
    required String description,
    required String orgName,
    required Language language,
  }) async =>
      _activatePlatform(
        Platform.mobile,
        description: description,
        orgName: orgName,
        language: language,
      );

  Future<void> _activatePlatform(
    Platform platform, {
    String? description,
    String? orgName,
    required Language language,
  }) async {
    if (project.platformIsActivated(platform)) {
      throw PlatformAlreadyActivatedException._(platform);
    }

    logger.newLine();

    await __activatePlatform(
      platform,
      description: description,
      orgName: orgName,
      language: language,
    );

    await dartFormatFixTask();

    logger
      ..newLine()
      ..commandSuccess('Activated ${platform.prettyName}!');
  }

  // TODO: consider adding __activateAndroid, __activateIos ... methods to match params
  Future<void> __activatePlatform(
    Platform platform, {
    String? description,
    String? orgName,
    required Language language,
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

            // TODO the ! is not good practice
            switch (platform) {
              case Platform.ios:
                await (rootPackage as IosRootPackage).generate(
                  orgName: orgName!,
                  language: language,
                );
              case Platform.macos:
                await (rootPackage as MacosRootPackage).generate(
                  orgName: orgName!,
                );
              case Platform.mobile:
                await (rootPackage as MobileRootPackage).generate(
                  orgName: orgName!,
                  description: description!,
                  language: language,
                );
              default:
                await (rootPackage as NoneIosRootPackage).generate(
                  orgName: orgName,
                  description: description,
                );
            }
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
      await codeGenTask(package: rootPackage);
    }

    await flutterGenl10nTask(package: localizationPackage);

    // TODO use tasks
    switch (platform) {
      case Platform.mobile:
        await flutterConfigEnable(platform: Platform.android, project: project);
        await flutterConfigEnable(platform: Platform.ios, project: project);
      default:
        await flutterConfigEnable(platform: platform, project: project);
    }

    logger.newLine();

    // TODO: Required due to https://github.com/jtdLab/rapid/issues/96
    if (platform == Platform.macos) {
      // Sets the `osx` version inside the `Podfile` of the `macos` app
      // to `10.15.7.7`. This is required because rapid projects use a
      // [macos_ui](https://pub.dev/packages/macos_ui) version from the dev channel.
      final podFile = (rootPackage as MacosRootPackage).nativeDirectory.podFile;
      if (podFile.existsSync()) {
        replaceInFile(
          podFile,
          'platform :osx, \'10.14\'',
          'platform :osx, \'10.15.7.7\'',
        );
      } else {
        podFile.createSync(recursive: true);
        // Required because on ci (maybe other systems too) the Podfile is not generated by flutter tooling.
        podFile.writeAsStringSync('''
platform :osx, '10.15.7.7'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'ephemeral', 'Flutter-Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure \\"flutter pub get\\" is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Flutter-Generated.xcconfig, then run \\"flutter pub get\\""
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_macos_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_macos_pods File.dirname(File.realpath(__FILE__))
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_macos_build_settings(target)
  end
end
''');
      }
    }
  }
}

typedef PlatformDirectoryBuilder = Future<PlatformDirectory> Function(
  RapidProject project,
);

class PlatformAlreadyActivatedException extends RapidException {
  PlatformAlreadyActivatedException._(Platform platform)
      : super('The platform ${platform.prettyName} is already activated.');
}
