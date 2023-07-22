import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../invocations.dart';
import '../mock_env.dart';
import '../mock_fs.dart';
import '../mocks.dart';
import '../utils.dart';

// TODO test loggs better and verify nothing ran on exception

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('activateAndroid', () {
    test(
        'throws PlatformAlreadyActivatedException when Android is already activated',
        () async {
      final manager = MockProcessManager();
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.android))
          .thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      expect(
        withMockProcessManager(
          () async => rapid.activateAndroid(
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          manager: manager,
        ),
        throwsA(isA<PlatformAlreadyActivatedException>()),
      );
      // TODO
      //verifyNever(() => dartFormatFixTask(manager));
      // verifyNever(() => logger.commandSuccess(any()));
    });

    test(
      'completes',
      () async {
        final manager = MockProcessManager();
        final platformRootPackage = MockNoneIosRootPackage();
        final localizationPackage = MockPlatformLocalizationPackage();
        final navigationPackage = MockPlatformNavigationPackage();
        final appFeaturePackage = MockPlatformAppFeaturePackage();
        final homePageFeaturePackage = MockPlatformPageFeaturePackage();
        T featurePackage<T extends PlatformFeaturePackage>({
          required String name,
        }) =>
            homePageFeaturePackage as T;
        final platformUiPackage = MockPlatformUiPackage();

        final project = MockRapidProject(
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: platformRootPackage,
              localizationPackage: localizationPackage,
              navigationPackage: navigationPackage,
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage: appFeaturePackage,
                featurePackage: featurePackage,
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final logger = MockRapidLogger();
        final rapid = getRapid(
          project: project,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.activateAndroid(
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          manager: manager,
        );

        verifyInOrder([
          () => logger.newLine(),
          () => appFeaturePackage.generate(),
          () => homePageFeaturePackage.generate(),
          () => localizationPackage.generate(
                defaultLanguage: Language(languageCode: 'fr'),
              ),
          () => navigationPackage.generate(),
          () => platformRootPackage.generate(
                description: 'Some desc.',
                orgName: 'test.example',
              ),
          () => platformUiPackage.generate(),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              appFeaturePackage,
              homePageFeaturePackage,
              localizationPackage,
              navigationPackage,
              platformRootPackage,
              platformUiPackage,
            ],
          ),
          ...flutterGenl10nTask(manager, package: localizationPackage),
          ...flutterConfigEnablePlatform(manager, platform: Platform.android),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Activated Android!'),
        ]);
      },
    );
  });

  group('activateIos', () {
    test(
      'throws PlatformAlreadyActivatedException when iOS is already activated',
      () async {
        final manager = MockProcessManager();
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.ios)).thenReturn(true);
        final logger = MockRapidLogger();
        final rapid = getRapid(project: project, logger: logger);

        expect(
          withMockProcessManager(
            () async => rapid.activateIos(
              orgName: 'test.example',
              language: Language(languageCode: 'fr'),
            ),
            manager: manager,
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'completes',
      () async {
        final manager = MockProcessManager();
        final platformRootPackage = MockIosRootPackage();
        final localizationPackage = MockPlatformLocalizationPackage();
        final navigationPackage = MockPlatformNavigationPackage();
        final appFeaturePackage = MockPlatformAppFeaturePackage();
        final homePageFeaturePackage = MockPlatformPageFeaturePackage();
        T featurePackage<T extends PlatformFeaturePackage>({
          required String name,
        }) =>
            homePageFeaturePackage as T;
        final platformUiPackage = MockPlatformUiPackage();

        final project = MockRapidProject(
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: platformRootPackage,
              localizationPackage: localizationPackage,
              navigationPackage: navigationPackage,
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage: appFeaturePackage,
                featurePackage: featurePackage,
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final logger = MockRapidLogger();
        final rapid = getRapid(
          project: project,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.activateIos(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          manager: manager,
        );

        verifyInOrder([
          () => logger.newLine(),
          () => appFeaturePackage.generate(),
          () => homePageFeaturePackage.generate(),
          () => localizationPackage.generate(
                defaultLanguage: Language(languageCode: 'fr'),
              ),
          () => navigationPackage.generate(),
          () => platformRootPackage.generate(
                orgName: 'test.example',
                language: Language(languageCode: 'fr'),
              ),
          () => platformUiPackage.generate(),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              appFeaturePackage,
              homePageFeaturePackage,
              localizationPackage,
              navigationPackage,
              platformRootPackage,
              platformUiPackage,
            ],
          ),
          ...flutterGenl10nTask(manager, package: localizationPackage),
          ...flutterConfigEnablePlatform(manager, platform: Platform.ios),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Activated iOS!'),
        ]);
      },
    );
  });

  group('activateLinux', () {
    test(
      'throws PlatformAlreadyActivatedException when Linux is already activated',
      () async {
        final manager = MockProcessManager();
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.linux))
            .thenReturn(true);
        final logger = MockRapidLogger();
        final rapid = getRapid(project: project, logger: logger);

        expect(
          withMockProcessManager(
            () async => rapid.activateLinux(
              orgName: 'test.example',
              language: Language(languageCode: 'fr'),
            ),
            manager: manager,
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'completes',
      () async {
        final manager = MockProcessManager();
        final platformRootPackage = MockNoneIosRootPackage();
        final localizationPackage = MockPlatformLocalizationPackage();
        final navigationPackage = MockPlatformNavigationPackage();
        final appFeaturePackage = MockPlatformAppFeaturePackage();
        final homePageFeaturePackage = MockPlatformPageFeaturePackage();
        T featurePackage<T extends PlatformFeaturePackage>({
          required String name,
        }) =>
            homePageFeaturePackage as T;
        final platformUiPackage = MockPlatformUiPackage();

        final project = MockRapidProject(
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: platformRootPackage,
              localizationPackage: localizationPackage,
              navigationPackage: navigationPackage,
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage: appFeaturePackage,
                featurePackage: featurePackage,
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final logger = MockRapidLogger();
        final rapid = getRapid(
          project: project,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.activateLinux(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          manager: manager,
        );

        verifyInOrder([
          () => platformRootPackage.generate(
                orgName: 'test.example',
              ),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              appFeaturePackage,
              homePageFeaturePackage,
              localizationPackage,
              navigationPackage,
              platformRootPackage,
              platformUiPackage,
            ],
          ),
          ...flutterConfigEnablePlatform(manager, platform: Platform.linux),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Activated Linux!'),
        ]);
      },
    );
  });

  group('activateMacos', () {
    test(
      'throws PlatformAlreadyActivatedException when macOS is already activated',
      () async {
        final manager = MockProcessManager();
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.macos))
            .thenReturn(true);
        final logger = MockRapidLogger();
        final rapid = getRapid(project: project, logger: logger);

        expect(
          withMockProcessManager(
            () async => rapid.activateMacos(
              orgName: 'test.example',
              language: Language(languageCode: 'fr'),
            ),
            manager: manager,
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'completes',
      () async {
        final manager = MockProcessManager();
        final platformRootPackage = MockMacosRootPackage();
        final localizationPackage = MockPlatformLocalizationPackage();
        final navigationPackage = MockPlatformNavigationPackage();
        final appFeaturePackage = MockPlatformAppFeaturePackage();
        final homePageFeaturePackage = MockPlatformPageFeaturePackage();
        T featurePackage<T extends PlatformFeaturePackage>({
          required String name,
        }) =>
            homePageFeaturePackage as T;
        final platformUiPackage = MockPlatformUiPackage();

        final project = MockRapidProject(
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: platformRootPackage,
              localizationPackage: localizationPackage,
              navigationPackage: navigationPackage,
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage: appFeaturePackage,
                featurePackage: featurePackage,
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final logger = MockRapidLogger();
        final rapid = getRapid(
          project: project,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.activateMacos(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          manager: manager,
        );

        verifyInOrder([
          () => platformRootPackage.generate(
                orgName: 'test.example',
              ),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              appFeaturePackage,
              homePageFeaturePackage,
              localizationPackage,
              navigationPackage,
              platformRootPackage,
              platformUiPackage,
            ],
          ),
          ...flutterGenl10nTask(manager, package: localizationPackage),
          ...flutterConfigEnablePlatform(manager, platform: Platform.macos),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Activated macOS!'),
        ]);
      },
    );

    test(
      'handles existing non default infrastructure packages',
      () async {
        final manager = MockProcessManager();
        final nonDefaultInfrastructurePackage =
            MockInfrastructurePackage(isDefault: false);
        final platformRootPackage = MockMacosRootPackage();

        final project = MockRapidProject(
          appModule: MockAppModule(
            infrastructureDirectory: MockInfrastructureDirectory(
              infrastructurePackages: [
                MockInfrastructurePackage(isDefault: true),
                nonDefaultInfrastructurePackage,
              ],
            ),
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: platformRootPackage,
            ),
          ),
        );
        final logger = MockRapidLogger();
        final rapid = getRapid(
          project: project,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.activateMacos(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          manager: manager,
        );

        verifyInOrder([
          () => platformRootPackage
              .registerInfrastructurePackage(nonDefaultInfrastructurePackage),
          ...flutterPubRunBuildRunnerBuildTask(
            manager,
            package: platformRootPackage,
          ),
        ]);
      },
    );

    test(
      'regression for issue 96',
      withMockFs(() async {
        final manager = MockProcessManager();
        final podFile = File('Podfile')
          ..writeAsStringSync('platform :osx, \'10.14\'');
        final nativeDirectory = MockMacosNativeDirectory(podFile: podFile);
        final platformRootPackage =
            MockMacosRootPackage(nativeDirectory: nativeDirectory);

        final project = MockRapidProject(
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: platformRootPackage,
            ),
          ),
        );
        final logger = MockRapidLogger();
        final rapid = getRapid(
          project: project,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.activateMacos(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          manager: manager,
        );

        expect(podFile.readAsStringSync(), 'platform :osx, \'10.15.7.7\'');
      }),
    );

    test(
      'regression for issue 96 (not existing podfile)',
      withMockFs(() async {
        final manager = MockProcessManager();
        final podFile = File('Podfile');
        final nativeDirectory = MockMacosNativeDirectory(podFile: podFile);
        final platformRootPackage =
            MockMacosRootPackage(nativeDirectory: nativeDirectory);

        final project = MockRapidProject(
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: platformRootPackage,
            ),
          ),
        );
        final logger = MockRapidLogger();
        final rapid = getRapid(
          project: project,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.activateMacos(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          manager: manager,
        );

        expect(podFile.readAsStringSync(), '''
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
      }),
    );
  });

  group('activateWeb', () {
    test(
      'throws PlatformAlreadyActivatedException when Web is already activated',
      () async {
        final manager = MockProcessManager();
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.web)).thenReturn(true);
        final logger = MockRapidLogger();
        final rapid = getRapid(project: project, logger: logger);

        expect(
          withMockProcessManager(
            () async => rapid.activateWeb(
              description: 'Some desc.',
              language: Language(languageCode: 'fr'),
            ),
            manager: manager,
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'completes',
      () async {
        final manager = MockProcessManager();
        final platformRootPackage = MockNoneIosRootPackage();
        final localizationPackage = MockPlatformLocalizationPackage();
        final navigationPackage = MockPlatformNavigationPackage();
        final appFeaturePackage = MockPlatformAppFeaturePackage();
        final homePageFeaturePackage = MockPlatformPageFeaturePackage();
        T featurePackage<T extends PlatformFeaturePackage>({
          required String name,
        }) =>
            homePageFeaturePackage as T;
        final platformUiPackage = MockPlatformUiPackage();

        final project = MockRapidProject(
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: platformRootPackage,
              localizationPackage: localizationPackage,
              navigationPackage: navigationPackage,
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage: appFeaturePackage,
                featurePackage: featurePackage,
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final logger = MockRapidLogger();
        final rapid = getRapid(
          project: project,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.activateWeb(
            description: 'Some desc.',
            language: Language(languageCode: 'fr'),
          ),
          manager: manager,
        );

        verifyInOrder([
          () => platformRootPackage.generate(
                description: 'Some desc.',
              ),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              appFeaturePackage,
              homePageFeaturePackage,
              localizationPackage,
              navigationPackage,
              platformRootPackage,
              platformUiPackage,
            ],
          ),
          ...flutterGenl10nTask(manager, package: localizationPackage),
          ...flutterConfigEnablePlatform(manager, platform: Platform.web),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Activated Web!'),
        ]);
      },
    );
  });

  group('activateWindows', () {
    test(
      'throws PlatformAlreadyActivatedException when Windows is already activated',
      () async {
        final manager = MockProcessManager();
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.windows))
            .thenReturn(true);
        final logger = MockRapidLogger();
        final rapid = getRapid(project: project, logger: logger);

        expect(
          withMockProcessManager(
            () async => rapid.activateWindows(
              orgName: 'test.example',
              language: Language(languageCode: 'fr'),
            ),
            manager: manager,
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'completes',
      () async {
        final manager = MockProcessManager();
        final platformRootPackage = MockNoneIosRootPackage();
        final localizationPackage = MockPlatformLocalizationPackage();
        final navigationPackage = MockPlatformNavigationPackage();
        final appFeaturePackage = MockPlatformAppFeaturePackage();
        final homePageFeaturePackage = MockPlatformPageFeaturePackage();
        T featurePackage<T extends PlatformFeaturePackage>({
          required String name,
        }) =>
            homePageFeaturePackage as T;
        final platformUiPackage = MockPlatformUiPackage();

        final project = MockRapidProject(
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: platformRootPackage,
              localizationPackage: localizationPackage,
              navigationPackage: navigationPackage,
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage: appFeaturePackage,
                featurePackage: featurePackage,
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final logger = MockRapidLogger();
        final rapid = getRapid(
          project: project,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.activateWindows(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          manager: manager,
        );

        verifyInOrder([
          () => platformRootPackage.generate(
                orgName: 'test.example',
              ),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              appFeaturePackage,
              homePageFeaturePackage,
              localizationPackage,
              navigationPackage,
              platformRootPackage,
              platformUiPackage,
            ],
          ),
          ...flutterGenl10nTask(manager, package: localizationPackage),
          ...flutterConfigEnablePlatform(manager, platform: Platform.windows),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Activated Windows!'),
        ]);
      },
    );
  });

  group('activateMobile', () {
    test(
      'throws PlatformAlreadyActivatedException when Mobile is already activated',
      () async {
        final manager = MockProcessManager();
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.mobile))
            .thenReturn(true);
        final logger = MockRapidLogger();
        final rapid = getRapid(project: project, logger: logger);

        expect(
          withMockProcessManager(
            () async => rapid.activateMobile(
              description: 'Some desc.',
              orgName: 'test.example',
              language: Language(languageCode: 'fr'),
            ),
            manager: manager,
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'completes',
      () async {
        final manager = MockProcessManager();
        final platformRootPackage = MockMobileRootPackage();
        final localizationPackage = MockPlatformLocalizationPackage();
        final navigationPackage = MockPlatformNavigationPackage();
        final appFeaturePackage = MockPlatformAppFeaturePackage();
        final homePageFeaturePackage = MockPlatformPageFeaturePackage();
        T featurePackage<T extends PlatformFeaturePackage>({
          required String name,
        }) =>
            homePageFeaturePackage as T;
        final platformUiPackage = MockPlatformUiPackage();

        final project = MockRapidProject(
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: platformRootPackage,
              localizationPackage: localizationPackage,
              navigationPackage: navigationPackage,
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage: appFeaturePackage,
                featurePackage: featurePackage,
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final logger = MockRapidLogger();
        final rapid = getRapid(
          project: project,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.activateMobile(
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          manager: manager,
        );

        verifyInOrder([
          () => platformRootPackage.generate(
                orgName: 'test.example',
                description: 'Some desc.',
                language: Language(languageCode: 'fr'),
              ),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              appFeaturePackage,
              homePageFeaturePackage,
              localizationPackage,
              navigationPackage,
              platformRootPackage,
              platformUiPackage,
            ],
          ),
          ...flutterGenl10nTask(manager, package: localizationPackage),
          ...flutterConfigEnablePlatform(manager, platform: Platform.android),
          ...flutterConfigEnablePlatform(manager, platform: Platform.ios),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Activated Mobile!'),
        ]);
      },
    );
  });
}
