void main() {
  // TODO impl
}

/* import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../invocations.dart';
import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
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
      verifyNever(
        () => rapid._activatePlatform(
          Platform.android,
          description: any(named: 'description'),
          orgName: any(named: 'orgName'),
          language: any(named: 'language'),
        ),
      );
      verifyNever(() => dartFormatFixTask(manager));
      verifyNever(() => logger.commandSuccess(any()));
    });

    test('completes', () async {
      final manager = MockProcessManager();
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.android))
          .thenReturn(false);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

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
        () => rapid._activatePlatform(
              Platform.android,
              description: 'Some desc.',
              orgName: 'test.example',
              language: Language(languageCode: 'fr'),
            ),
        ...dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Activated Android!')
      ]);
    });
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
      verifyNever(
        () => rapid._activatePlatform(
          Platform.ios,
          orgName: any(named: 'orgName'),
          language: any(named: 'language'),
        ),
      );
      verifyNever(() => dartFormatFixTask(manager));
      verifyNever(() => logger.commandSuccess(any()));
    });

    test('completes', () async {
      final manager = MockProcessManager();
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.ios)).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.activateIos(
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => rapid._activatePlatform(
              Platform.ios,
              orgName: 'TestOrg',
              language: Language.dart,
            ),
        ...dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Activated iOS!')
      ]);
    });
  });

  group('activateLinux', () {
    test(
        'throws PlatformAlreadyActivatedException when Linux is already activated',
        () async {
      final manager = MockProcessManager();
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(true);
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
      verifyNever(() => rapid._activatePlatform(
            Platform.linux,
            orgName: any(named: 'orgName'),
            language: any(named: 'language'),
          ));
      verifyNever(() => dartFormatFixTask(manager));
      verifyNever(() => logger.commandSuccess(any()));
    });

    test('completes', () async {
      final manager = MockProcessManager();
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.activateLinux(
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => rapid._activatePlatform(
              Platform.linux,
              orgName: 'TestOrg',
              language: Language.dart,
            ),
        ...dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Activated Linux!')
      ]);
    });
  });

  group('activateMacos', () {
    test(
        'throws PlatformAlreadyActivatedException when macOS is already activated',
        () async {
      final manager = MockProcessManager();
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.macos)).thenReturn(true);
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
      verifyNever(() => rapid._activatePlatform(
            Platform.macos,
            orgName: any(named: 'orgName'),
            language: any(named: 'language'),
          ));
      verifyNever(() => dartFormatFixTask(manager));
      verifyNever(() => logger.commandSuccess(any()));
    });

    test('completes', () async {
      final manager = MockProcessManager();
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.macos)).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.activateMacos(
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => rapid._activatePlatform(
              Platform.macos,
              orgName: 'TestOrg',
              language: Language.dart,
            ),
        ...dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Activated macOS!')
      ]);
    });
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
      verifyNever(() => rapid._activatePlatform(
            Platform.web,
            description: any(named: 'description'),
            language: any(named: 'language'),
          ));
      verifyNever(() => dartFormatFixTask(manager));
      verifyNever(() => logger.commandSuccess(any()));
    });

    test('completes', () async {
      final manager = MockProcessManager();
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.web)).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.activateWeb(
          description: 'Some desc.',
          language: Language(languageCode: 'fr'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => rapid._activatePlatform(
              Platform.web,
              description: 'Test Description',
              language: Language.dart,
            ),
        ...dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Activated Web!')
      ]);
    });
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
      verifyNever(() => rapid._activatePlatform(
            Platform.windows,
            orgName: any(named: 'orgName'),
            language: any(named: 'language'),
          ));
      verifyNever(() => dartFormatFixTask(manager));
      verifyNever(() => logger.commandSuccess(any()));
    });

    test('completes', () async {
      final manager = MockProcessManager();
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.windows))
          .thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.activateWindows(
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => rapid._activatePlatform(
              Platform.windows,
              orgName: 'TestOrg',
              language: Language.dart,
            ),
        ...dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Activated Windows!')
      ]);
    });
  });

  group('activateMobile', () {
    test(
        'throws PlatformAlreadyActivatedException when Mobile is already activated',
        () async {
      final manager = MockProcessManager();
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.mobile)).thenReturn(true);
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
      verifyNever(() => rapid._activatePlatform(
            Platform.mobile,
            description: any(named: 'description'),
            orgName: any(named: 'orgName'),
            language: any(named: 'language'),
          ));
      verifyNever(() => dartFormatFixTask(manager));
      verifyNever(() => logger.commandSuccess(any()));
    });

    test('completes', () async {
      final manager = MockProcessManager();
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.mobile)).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.activateMobile(
          description: 'Some desc.',
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => rapid._activatePlatform(
              Platform.mobile,
              description: 'Test Description',
              orgName: 'TestOrg',
              language: Language.dart,
            ),
        ...dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Activated Mobile!')
      ]);
    });
  });

  group('_activatePlatform', () {
    test(
        'throws PlatformAlreadyActivatedException when platform is already activated',
        () async {
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.android))
          .thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      expect(
        () => rapid._activatePlatform(
          Platform.android,
          description: '',
          orgName: '',
          language: Language.dart,
        ),
        throwsA(isA<PlatformAlreadyActivatedException>()),
      );
      verifyNever(() => logger.newLine());
      verifyNever(() => rapid.__activatePlatform(
            any(),
            description: any(named: 'description'),
            orgName: any(named: 'orgName'),
            language: any(named: 'language'),
          ));
      verifyNever(() => dartFormatFixTask(manager));
      verifyNever(() => logger.commandSuccess(any()));
    });

    test('completes', () async {
      final project = MockRapidProject();
      when(() => project.platformIsActivated(Platform.android))
          .thenReturn(false);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await rapid._activatePlatform(
        Platform.android,
        description: 'Test Description',
        orgName: 'TestOrg',
        language: Language.dart,
      );

      verifyNever(() => logger.newLine());
      verify(() => rapid.__activatePlatform(
            Platform.android,
            description: 'Test Description',
            orgName: 'TestOrg',
            language: Language.dart,
          )).called(1);
      verifyNever(() => dartFormatFixTask(manager));
      verifyNever(() => logger.newLine());
      verify(() => logger.commandSuccess('Activated Android!')).called(1);
    });
  });

  group('__activatePlatform', () {
    test('activates platform and performs necessary tasks', () async {
      final project = MockRapidProject();
      final appModule = MockRapidAppModule();
      final platformDirectory = MockPlatformDirectory();
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.platformDirectory(platform: any(named: 'platform')))
          .thenReturn(platformDirectory);
      final appFeaturePackage = MockRapidAppFeaturePackage();
      final homePageFeaturePackage = MockRapidPlatformPageFeaturePackage();
      final localizationPackage = MockRapidLocalizationPackage();
      final navigationPackage = MockRapidNavigationPackage();
      final rootPackage = MockRapidNoneIosRootPackage();
      final platformUiPackage = MockDirectory();
      when(() => platformDirectory.featuresDirectory.appFeaturePackage)
          .thenReturn(appFeaturePackage);
      when(() => platformDirectory.featuresDirectory
              .featurePackage<PlatformPageFeaturePackage>(name: 'home_page'))
          .thenReturn(homePageFeaturePackage);
      when(() => platformDirectory.localizationPackage)
          .thenReturn(localizationPackage);
      when(() => platformDirectory.navigationPackage)
          .thenReturn(navigationPackage);
      when(() => platformDirectory.rootPackage).thenReturn(rootPackage);
      when(() => project.uiModule.platformUiPackage(
          platform: any(named: 'platform'))).thenReturn(platformUiPackage);
      final infrastructurePackages = [MockRapidInfrastructurePackage()];
      when(() => project.appModule.infrastructureDirectory
          .infrastructurePackages()).thenReturn(infrastructurePackages);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await rapid.__activatePlatform(
        Platform.android,
        description: 'Test Description',
        orgName: 'TestOrg',
        language: Language.dart,
      );

      verify(() => platformDirectory.generate()).called(1);
      verify(() => appFeaturePackage.generate()).called(1);
      verify(() => homePageFeaturePackage.generate()).called(1);
      verify(() => localizationPackage.generate(defaultLanguage: Language.dart))
          .called(1);
      verify(() => navigationPackage.generate()).called(1);
      verify(() => rootPackage.generate(
          orgName: 'TestOrg', description: 'Test Description')).called(1);
      verify(() => platformUiPackage.createSync(recursive: true)).called(1);
      verify(() => flutterPubGetTaskGroup(packages: any(named: 'packages')))
          .called(1);
      verify(() => codeGenTask(package: rootPackage)).called(1);
      verify(() => flutterGenl10nTask(package: localizationPackage)).called(1);
      verify(() =>
              flutterConfigEnable(platform: Platform.android, project: project))
          .called(1);
      verifyNever(() => logger.newLine());
    });
  });
}
 */
