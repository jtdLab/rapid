import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../invocations.dart';
import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('platformAddFeatureFlow', () {
    test('adds a new flow feature to the platform', () async {
      final manager = MockProcessManager();
      final platformRootPackage = MockNoneIosRootPackage();
      final platformNavigationPackage = MockPlatformNavigationPackage();
      final platformFeaturePackage =
          MockPlatformFlowFeaturePackage(name: 'cool_flow');
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: platformRootPackage,
            navigationPackage: platformNavigationPackage,
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(
        project: project,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.platformAddFeatureFlow(
          Platform.android,
          name: 'cool_flow',
          description: 'Cool flow.',
          navigator: false,
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformFeaturePackage.generate(description: 'Cool flow.'),
        () =>
            platformRootPackage.registerFeaturePackage(platformFeaturePackage),
        () => melosBootstrapTask(
              manager,
              scope: [platformRootPackage, platformFeaturePackage],
            ),
        () => flutterPubRunBuildRunnerBuildTaskGroup(
              manager,
              packages: [
                platformRootPackage,
              ],
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Flow Feature!'),
      ]);
    });

    test('adds a new flow feature to the platform (with navigator)', () async {
      final manager = MockProcessManager();
      final platformRootPackage = MockNoneIosRootPackage();
      final navigatorInterface = MockNavigatorInterface();
      when(() => navigatorInterface.existsAny).thenReturn(false);
      final navigationBarrelFile = MockDartFile();
      final platformNavigationPackage = MockPlatformNavigationPackage(
        barrelFile: navigationBarrelFile,
        navigatorInterface: ({required name}) => navigatorInterface,
      );
      final navigatorImplementation = MockNavigatorImplementation();
      when(() => navigatorImplementation.existsAny).thenReturn(false);
      final platformFeaturePackage = MockPlatformFlowFeaturePackage(
        name: 'cool_flow',
        navigatorImplementation: navigatorImplementation,
      );
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: platformRootPackage,
            navigationPackage: platformNavigationPackage,
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(
        project: project,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.platformAddFeatureFlow(
          Platform.android,
          name: 'cool',
          description: 'Cool flow.',
          navigator: true,
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformFeaturePackage.generate(description: 'Cool flow.'),
        () =>
            platformRootPackage.registerFeaturePackage(platformFeaturePackage),
        () => navigatorInterface.generate(),
        () => navigationBarrelFile.addExport('src/i_cool_flow_navigator.dart'),
        () => navigatorImplementation.generate(),
        ...flutterPubRunBuildRunnerBuildTask(
          manager,
          package: platformFeaturePackage,
        ),
        () => melosBootstrapTask(
              manager,
              scope: [platformRootPackage, platformFeaturePackage],
            ),
        () => flutterPubRunBuildRunnerBuildTaskGroup(
              manager,
              packages: [platformRootPackage, platformFeaturePackage],
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Flow Feature!'),
      ]);
    });

    test(
        'throws PlatformNotActivatedException when the platform is not activated',
        () async {
      final project = MockRapidProject();
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureFlow(
          Platform.android,
          name: 'cool',
          description: 'Cool flow.',
          navigator: true,
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureAlreadyExistsException when feature package already exists',
        () async {
      final featurePackage = MockPlatformFlowFeaturePackage(name: 'cool_flow');
      when(() => featurePackage.existsSync()).thenReturn(true);
      T featurePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;

      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: featurePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureFlow(
          Platform.android,
          name: 'cool',
          description: 'Cool flow.',
          navigator: true,
        ),
        throwsA(isA<FeatureAlreadyExistsException>()),
      );
    });
  });

  group('platformAddFeatureTabFlow', () {
    test('adds a new tab flow feature to the platform', () async {
      final manager = MockProcessManager();
      final platformRootPackage = MockNoneIosRootPackage();
      final platformNavigationPackage = MockPlatformNavigationPackage();
      final platformFeaturePackage =
          MockPlatformTabFlowFeaturePackage(name: 'cool_tab_flow');
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: platformRootPackage,
            navigationPackage: platformNavigationPackage,
            featuresDirectory: MockPlatformFeaturesDirectory(
                featurePackage: platformFeaturePackageBuilder,
                featurePackages: [
                  MockPlatformPageFeaturePackage(name: 'home_page'),
                ]),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(
        project: project,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.platformAddFeatureTabFlow(
          Platform.android,
          name: 'cool',
          description: 'Cool tab flow.',
          navigator: false,
          subFeatures: {'home_page'},
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformFeaturePackage.generate(
              description: 'Cool tab flow.',
              subFeatures: {'home_page'},
            ),
        () =>
            platformRootPackage.registerFeaturePackage(platformFeaturePackage),
        () => melosBootstrapTask(
              manager,
              scope: [platformRootPackage, platformFeaturePackage],
            ),
        () => flutterPubRunBuildRunnerBuildTaskGroup(
              manager,
              packages: [
                platformRootPackage,
              ],
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Tab Flow Feature!'),
      ]);
    });

    test('adds a new tab flow feature to the platform (with navigator)',
        () async {
      final manager = MockProcessManager();
      final platformRootPackage = MockNoneIosRootPackage();
      final navigatorInterface = MockNavigatorInterface();
      when(() => navigatorInterface.existsAny).thenReturn(false);
      final navigationBarrelFile = MockDartFile();
      final platformNavigationPackage = MockPlatformNavigationPackage(
        barrelFile: navigationBarrelFile,
        navigatorInterface: ({required name}) => navigatorInterface,
      );
      final navigatorImplementation = MockNavigatorImplementation();
      when(() => navigatorImplementation.existsAny).thenReturn(false);
      final platformFeaturePackage = MockPlatformTabFlowFeaturePackage(
        name: 'cool_tab_flow',
        navigatorImplementation: navigatorImplementation,
      );
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: platformRootPackage,
            navigationPackage: platformNavigationPackage,
            featuresDirectory: MockPlatformFeaturesDirectory(
                featurePackage: platformFeaturePackageBuilder,
                featurePackages: [
                  MockPlatformPageFeaturePackage(name: 'home_page'),
                ]),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(
        project: project,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.platformAddFeatureTabFlow(
          Platform.android,
          name: 'cool',
          description: 'Cool tab flow.',
          navigator: true,
          subFeatures: {'home_page'},
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformFeaturePackage.generate(
              description: 'Cool tab flow.',
              subFeatures: {'home_page'},
            ),
        () =>
            platformRootPackage.registerFeaturePackage(platformFeaturePackage),
        () => navigatorInterface.generate(),
        () => navigationBarrelFile
            .addExport('src/i_cool_tab_flow_navigator.dart'),
        () => navigatorImplementation.generate(),
        ...flutterPubRunBuildRunnerBuildTask(
          manager,
          package: platformFeaturePackage,
        ),
        () => melosBootstrapTask(
              manager,
              scope: [platformRootPackage, platformFeaturePackage],
            ),
        () => flutterPubRunBuildRunnerBuildTaskGroup(
              manager,
              packages: [platformRootPackage, platformFeaturePackage],
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Tab Flow Feature!'),
      ]);
    });

    test(
        'throws PlatformNotActivatedException when the platform is not activated',
        () async {
      final project = MockRapidProject();
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureTabFlow(
          Platform.android,
          name: 'cool',
          description: 'Cool tab flow.',
          navigator: false,
          subFeatures: {'home_page'},
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureAlreadyExistsException when feature package already exists',
        () async {
      final featurePackage =
          MockPlatformTabFlowFeaturePackage(name: 'cool_tab_flow');
      when(() => featurePackage.existsSync()).thenReturn(true);
      T featurePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;

      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: featurePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureTabFlow(
          Platform.android,
          name: 'cool',
          description: 'Cool tab flow.',
          navigator: false,
          subFeatures: {'home_page'},
        ),
        throwsA(isA<FeatureAlreadyExistsException>()),
      );
    });

    test('throws SubFeaturesNotFoundException when sub feature not found',
        () async {
      final platformRootPackage = MockNoneIosRootPackage();
      final platformFeaturePackage =
          MockPlatformTabFlowFeaturePackage(name: 'cool_tab_flow');
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: platformRootPackage,
            featuresDirectory: MockPlatformFeaturesDirectory(
                featurePackage: platformFeaturePackageBuilder,
                featurePackages: [
                  MockPlatformPageFeaturePackage(name: 'other_page'),
                ]),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(
        project: project,
        logger: logger,
      );

      expect(
        () => rapid.platformAddFeatureTabFlow(
          Platform.android,
          name: 'cool',
          description: 'Cool tab flow.',
          navigator: false,
          subFeatures: {'home_page'},
        ),
        throwsA(isA<SubFeaturesNotFoundException>()),
      );
    });
  });

  group('platformAddFeaturePage', () {
    test('adds a new page feature to the platform', () async {
      final manager = MockProcessManager();
      final platformRootPackage = MockNoneIosRootPackage();
      final platformNavigationPackage = MockPlatformNavigationPackage();
      final platformFeaturePackage =
          MockPlatformPageFeaturePackage(name: 'cool_page');
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: platformRootPackage,
            navigationPackage: platformNavigationPackage,
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(
        project: project,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.platformAddFeaturePage(
          Platform.android,
          name: 'cool_page',
          description: 'Cool page.',
          navigator: false,
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformFeaturePackage.generate(description: 'Cool page.'),
        () =>
            platformRootPackage.registerFeaturePackage(platformFeaturePackage),
        () => melosBootstrapTask(
              manager,
              scope: [platformRootPackage, platformFeaturePackage],
            ),
        () => flutterPubRunBuildRunnerBuildTaskGroup(
              manager,
              packages: [
                platformRootPackage,
              ],
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Page Feature!'),
      ]);
    });

    test('adds a new page feature to the platform (with navigator)', () async {
      final manager = MockProcessManager();
      final platformRootPackage = MockNoneIosRootPackage();
      final navigatorInterface = MockNavigatorInterface();
      when(() => navigatorInterface.existsAny).thenReturn(false);
      final navigationBarrelFile = MockDartFile();
      final platformNavigationPackage = MockPlatformNavigationPackage(
        barrelFile: navigationBarrelFile,
        navigatorInterface: ({required name}) => navigatorInterface,
      );
      final navigatorImplementation = MockNavigatorImplementation();
      when(() => navigatorImplementation.existsAny).thenReturn(false);
      final platformFeaturePackage = MockPlatformPageFeaturePackage(
        name: 'cool_page',
        navigatorImplementation: navigatorImplementation,
      );
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: platformRootPackage,
            navigationPackage: platformNavigationPackage,
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(
        project: project,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.platformAddFeaturePage(
          Platform.android,
          name: 'cool',
          description: 'Cool page.',
          navigator: true,
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformFeaturePackage.generate(description: 'Cool page.'),
        () =>
            platformRootPackage.registerFeaturePackage(platformFeaturePackage),
        () => navigatorInterface.generate(),
        () => navigationBarrelFile.addExport('src/i_cool_page_navigator.dart'),
        () => navigatorImplementation.generate(),
        ...flutterPubRunBuildRunnerBuildTask(
          manager,
          package: platformFeaturePackage,
        ),
        () => melosBootstrapTask(
              manager,
              scope: [platformRootPackage, platformFeaturePackage],
            ),
        // TODO duplicated in feature package
        () => flutterPubRunBuildRunnerBuildTaskGroup(
              manager,
              packages: [platformRootPackage, platformFeaturePackage],
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Page Feature!'),
      ]);
    });

    test(
        'throws PlatformNotActivatedException when the platform is not activated',
        () async {
      final project = MockRapidProject();
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeaturePage(
          Platform.android,
          name: 'cool',
          description: 'Cool page.',
          navigator: true,
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureAlreadyExistsException when feature package already exists',
        () async {
      final featurePackage = MockPlatformPageFeaturePackage(name: 'cool_page');
      when(() => featurePackage.existsSync()).thenReturn(true);
      T featurePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;

      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: featurePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeaturePage(
          Platform.android,
          name: 'cool',
          description: 'Cool page.',
          navigator: true,
        ),
        throwsA(isA<FeatureAlreadyExistsException>()),
      );
    });
  });

  group('platformAddFeatureWidget', () {
    test('adds a new widget feature to the platform', () async {
      final manager = MockProcessManager();
      final platformRootPackage = MockNoneIosRootPackage();
      final platformNavigationPackage = MockPlatformNavigationPackage();
      final platformFeaturePackage =
          MockPlatformWidgetFeaturePackage(name: 'cool_widget');
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: platformRootPackage,
            navigationPackage: platformNavigationPackage,
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(
        project: project,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.platformAddFeatureWidget(
          Platform.android,
          name: 'cool_widget',
          description: 'Cool widget.',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformFeaturePackage.generate(description: 'Cool widget.'),
        () =>
            platformRootPackage.registerFeaturePackage(platformFeaturePackage),
        () => melosBootstrapTask(
              manager,
              scope: [platformRootPackage, platformFeaturePackage],
            ),
        () => flutterPubRunBuildRunnerBuildTaskGroup(
              manager,
              packages: [
                platformRootPackage,
              ],
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Widget Feature!'),
      ]);
    });

    test(
        'throws PlatformNotActivatedException when the platform is not activated',
        () async {
      final project = MockRapidProject();
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureWidget(
          Platform.android,
          name: 'cool',
          description: 'Cool widget.',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureAlreadyExistsException when feature package already exists',
        () async {
      final featurePackage =
          MockPlatformWidgetFeaturePackage(name: 'cool_widget');
      when(() => featurePackage.existsSync()).thenReturn(true);
      T featurePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;

      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: featurePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureWidget(
          Platform.android,
          name: 'cool',
          description: 'Cool widget.',
        ),
        throwsA(isA<FeatureAlreadyExistsException>()),
      );
    });
  });

  group('platformAddLanguage', () {
    test('adds a new language', () async {
      final manager = MockProcessManager();

      final localizationPackage = MockPlatformLocalizationPackage();
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            localizationPackage: localizationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      when(() => localizationPackage.supportedLanguages()).thenReturn({
        Language(languageCode: 'en'),
        Language(languageCode: 'fr'),
        Language(languageCode: 'de'),
      });
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformAddLanguage(
          Platform.android,
          language: Language(languageCode: 'es'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => localizationPackage.addLanguage(Language(languageCode: 'es')),
        () => flutterGenl10nTask(manager, package: localizationPackage),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Language!')
      ]);
    });

    test('adds a new language (ios)', () async {
      final manager = MockProcessManager();
      final rootPackage = MockIosRootPackage();
      final localizationPackage = MockPlatformLocalizationPackage();
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: rootPackage,
            localizationPackage: localizationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      when(() => localizationPackage.supportedLanguages()).thenReturn({
        Language(languageCode: 'en'),
        Language(languageCode: 'fr'),
        Language(languageCode: 'de'),
      });
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformAddLanguage(
          Platform.android,
          language: Language(languageCode: 'es'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => rootPackage.addLanguage(Language(languageCode: 'es')),
        () => localizationPackage.addLanguage(Language(languageCode: 'es')),
        () => flutterGenl10nTask(manager, package: localizationPackage),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Language!')
      ]);
    });

    test('adds a new language (mobile)', () async {
      final manager = MockProcessManager();
      final rootPackage = MockMobileRootPackage();
      final localizationPackage = MockPlatformLocalizationPackage();
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: rootPackage,
            localizationPackage: localizationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      when(() => localizationPackage.supportedLanguages()).thenReturn({
        Language(languageCode: 'en'),
        Language(languageCode: 'fr'),
        Language(languageCode: 'de'),
      });
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformAddLanguage(
          Platform.android,
          language: Language(languageCode: 'es'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => rootPackage.addLanguage(Language(languageCode: 'es')),
        () => localizationPackage.addLanguage(Language(languageCode: 'es')),
        () => flutterGenl10nTask(manager, package: localizationPackage),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Language!')
      ]);
    });

    test('throws LanguageAlreadyPresentException for an existing language',
        () async {
      final localizationPackage = MockPlatformLocalizationPackage();
      when(() => localizationPackage.supportedLanguages()).thenReturn({
        Language(languageCode: 'en'),
        Language(languageCode: 'fr'),
        Language(languageCode: 'de'),
      });
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            localizationPackage: localizationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddLanguage(
          Platform.android,
          language: Language(languageCode: 'fr'),
        ),
        throwsA(isA<LanguageAlreadyPresentException>()),
      );
    });

    test('throws PlatformNotActivatedException for an inactive platform',
        () async {
      final project = MockRapidProject();
      final rapid = getRapid(project: project);

      when(() => project.platformIsActivated(any())).thenReturn(false);

      expect(
        () => rapid.platformAddLanguage(
          Platform.android,
          language: Language(languageCode: 'en'),
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });
  });

  group('platformAddNavigator', () {
    test('adds a navigator to a routable feature package', () async {
      final manager = MockProcessManager();
      final navigatorInterface = MockNavigatorInterface();
      when(() => navigatorInterface.existsAny).thenReturn(false);
      final navigationBarrelFile = MockDartFile();
      final platformNavigationPackage = MockPlatformNavigationPackage(
        barrelFile: navigationBarrelFile,
        navigatorInterface: ({required name}) => navigatorInterface,
      );
      final navigatorImplementation = MockNavigatorImplementation();
      when(() => navigatorImplementation.existsAny).thenReturn(false);
      final platformFeaturePackage = MockPlatformPageFeaturePackage(
        name: 'cool_page',
        navigatorImplementation: navigatorImplementation,
      );
      when(() => platformFeaturePackage.existsSync()).thenReturn(true);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
            navigationPackage: platformNavigationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformAddNavigator(
          Platform.android,
          featureName: 'featureA',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => navigatorInterface.generate(),
        () => navigationBarrelFile.addExport('src/i_cool_page_navigator.dart'),
        () => navigatorImplementation.generate(),
        ...flutterPubRunBuildRunnerBuildTask(
          manager,
          package: platformFeaturePackage,
        ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Navigator!')
      ]);
    });

    test('throws PlatformNotActivatedException for an inactive platform',
        () async {
      final project = MockRapidProject();
      final rapid = getRapid(project: project);

      when(() => project.platformIsActivated(any())).thenReturn(false);

      expect(
        () => rapid.platformAddNavigator(
          Platform.android,
          featureName: 'featureA',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureNotRoutableException for a non-routable feature package',
        () async {
      final platformFeaturePackage =
          MockPlatformWidgetFeaturePackage(name: 'cool_widget');
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddNavigator(
          Platform.android,
          featureName: 'cool_widget',
        ),
        throwsA(isA<FeatureNotRoutableException>()),
      );
    });

    test('throws FeatureNotFoundException for a non-existing feature package',
        () async {
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          MockPlatformPageFeaturePackage(name: 'cool_page') as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddNavigator(
          Platform.android,
          featureName: 'non_existing',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });
  });

  group('platformFeatureAddBloc', () {
    test('adds a new bloc to an existing feature package', () async {
      final manager = MockProcessManager();
      final bloc = MockBloc();
      when(() => bloc.existsAny).thenReturn(false);
      final applicationBarrelFile = MockDartFile(existsSync: true);
      final featurePackage = MockPlatformWidgetFeaturePackage(
        applicationBarrelFile: applicationBarrelFile,
      );
      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featurePackage.bloc).thenReturn(({required name}) => bloc);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformFeatureAddBloc(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => bloc.generate(),
        () => applicationBarrelFile.addExport('cool_bloc.dart'),
        () => flutterPubRunBuildRunnerBuildTask(
              manager,
              package: featurePackage,
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Bloc!')
      ]);
    });

    test('handles non existing application barrel file', () async {
      final manager = MockProcessManager();
      final bloc = MockBloc();
      when(() => bloc.existsAny).thenReturn(false);
      final featureBarrelFile = MockDartFile(existsSync: true);
      final applicationBarrelFile = MockDartFile(existsSync: false);
      final featurePackage = MockPlatformWidgetFeaturePackage(
        barrelFile: featureBarrelFile,
        applicationBarrelFile: applicationBarrelFile,
      );
      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featurePackage.bloc).thenReturn(({required name}) => bloc);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformFeatureAddBloc(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => bloc.generate(),
        () => applicationBarrelFile.createSync(recursive: true),
        () => applicationBarrelFile.addExport('cool_bloc.dart'),
        () => featureBarrelFile.addExport('src/application/application.dart'),
        () => flutterPubRunBuildRunnerBuildTask(
              manager,
              package: featurePackage,
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Bloc!')
      ]);
    });

    test('throws PlatformNotActivatedException for an inactive platform',
        () async {
      final project = MockRapidProject();
      final rapid = getRapid(project: project);

      when(() => project.platformIsActivated(any())).thenReturn(false);

      expect(
        () => rapid.platformFeatureAddBloc(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException for a non-existent feature package',
        () async {
      final featurePackage = MockPlatformWidgetFeaturePackage();
      when(() => featurePackage.existsSync()).thenReturn(false);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureAddBloc(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('throws BlocAlreadyExistsException for an existing bloc', () async {
      final bloc = MockBloc();
      when(() => bloc.existsAny).thenReturn(true);
      final featurePackage = MockPlatformWidgetFeaturePackage();
      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featurePackage.bloc).thenReturn(({required name}) => bloc);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureAddBloc(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<BlocAlreadyExistsException>()),
      );
    });
  });

  group('platformFeatureAddCubit', () {
    test('adds a new cubit to an existing feature package', () async {
      final manager = MockProcessManager();
      final cubit = MockCubit();
      when(() => cubit.existsAny).thenReturn(false);
      final applicationBarrelFile = MockDartFile(existsSync: true);
      final featurePackage = MockPlatformWidgetFeaturePackage(
        applicationBarrelFile: applicationBarrelFile,
      );
      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featurePackage.cubit).thenReturn(({required name}) => cubit);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformFeatureAddCubit(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => cubit.generate(),
        () => applicationBarrelFile.addExport('cool_cubit.dart'),
        () => flutterPubRunBuildRunnerBuildTask(
              manager,
              package: featurePackage,
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Cubit!')
      ]);
    });

    test('handles non existing application barrel file', () async {
      final manager = MockProcessManager();
      final cubit = MockCubit();
      when(() => cubit.existsAny).thenReturn(false);
      final featureBarrelFile = MockDartFile(existsSync: true);
      final applicationBarrelFile = MockDartFile(existsSync: false);
      final featurePackage = MockPlatformWidgetFeaturePackage(
        barrelFile: featureBarrelFile,
        applicationBarrelFile: applicationBarrelFile,
      );
      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featurePackage.cubit).thenReturn(({required name}) => cubit);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformFeatureAddCubit(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => cubit.generate(),
        () => applicationBarrelFile.createSync(recursive: true),
        () => applicationBarrelFile.addExport('cool_cubit.dart'),
        () => featureBarrelFile.addExport('src/application/application.dart'),
        () => flutterPubRunBuildRunnerBuildTask(
              manager,
              package: featurePackage,
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Cubit!')
      ]);
    });

    test('throws PlatformNotActivatedException for an inactive platform',
        () async {
      final project = MockRapidProject();
      final rapid = getRapid(project: project);

      when(() => project.platformIsActivated(any())).thenReturn(false);

      expect(
        () => rapid.platformFeatureAddCubit(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException for a non-existent feature package',
        () async {
      final featurePackage = MockPlatformWidgetFeaturePackage();
      when(() => featurePackage.existsSync()).thenReturn(false);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureAddCubit(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('throws CubitAlreadyExistsException for an existing cubit', () async {
      final cubit = MockCubit();
      when(() => cubit.existsAny).thenReturn(true);
      final featurePackage = MockPlatformWidgetFeaturePackage();
      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featurePackage.cubit).thenReturn(({required name}) => cubit);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureAddCubit(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<CubitAlreadyExistsException>()),
      );
    });
  });

  group('platformFeatureRemoveBloc', () {
    test('removes a bloc to an existing feature package', () async {
      final manager = MockProcessManager();
      final bloc = MockBloc();
      when(() => bloc.existsAny).thenReturn(true);
      final applicationBarrelFile = MockDartFile(existsSync: true);
      when(() => applicationBarrelFile.containsStatements()).thenReturn(true);
      final featurePackage = MockPlatformWidgetFeaturePackage(
        applicationBarrelFile: applicationBarrelFile,
      );
      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featurePackage.bloc).thenReturn(({required name}) => bloc);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformFeatureRemoveBloc(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => bloc.delete(),
        () => applicationBarrelFile.removeExport('cool_bloc.dart'),
        () => flutterPubRunBuildRunnerBuildTask(
              manager,
              package: featurePackage,
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Bloc!')
      ]);
    });

    test('remove application barrel file if it does not contain any code',
        () async {
      final manager = MockProcessManager();
      final bloc = MockBloc();
      when(() => bloc.existsAny).thenReturn(true);
      final featureBarrelFile = MockDartFile(existsSync: true);
      final applicationBarrelFile = MockDartFile(existsSync: true);
      when(() => applicationBarrelFile.containsStatements()).thenReturn(false);
      final featurePackage = MockPlatformWidgetFeaturePackage(
        barrelFile: featureBarrelFile,
        applicationBarrelFile: applicationBarrelFile,
      );
      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featurePackage.bloc).thenReturn(({required name}) => bloc);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformFeatureRemoveBloc(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => bloc.delete(),
        () => applicationBarrelFile.removeExport('cool_bloc.dart'),
        () => applicationBarrelFile.deleteSync(recursive: true),
        () =>
            featureBarrelFile.removeExport('src/application/application.dart'),
        () => flutterPubRunBuildRunnerBuildTask(
              manager,
              package: featurePackage,
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Bloc!')
      ]);
    });

    test('throws PlatformNotActivatedException for an inactive platform',
        () async {
      final project = MockRapidProject();
      final rapid = getRapid(project: project);

      when(() => project.platformIsActivated(any())).thenReturn(false);

      expect(
        () => rapid.platformFeatureRemoveBloc(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException for a non-existent feature package',
        () async {
      final featurePackage = MockPlatformWidgetFeaturePackage();
      when(() => featurePackage.existsSync()).thenReturn(false);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureRemoveBloc(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('throws BlocAlreadyExistsException for an existing bloc', () async {
      final bloc = MockBloc();
      when(() => bloc.existsAny).thenReturn(false);
      final featurePackage = MockPlatformWidgetFeaturePackage();
      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featurePackage.bloc).thenReturn(({required name}) => bloc);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureRemoveBloc(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<BlocNotFoundException>()),
      );
    });
  });

  group('platformFeatureRemoveCubit', () {
    test('removes a cubit to an existing feature package', () async {
      final manager = MockProcessManager();
      final cubit = MockCubit();
      when(() => cubit.existsAny).thenReturn(true);
      final applicationBarrelFile = MockDartFile(existsSync: true);
      when(() => applicationBarrelFile.containsStatements()).thenReturn(true);
      final featurePackage = MockPlatformWidgetFeaturePackage(
        applicationBarrelFile: applicationBarrelFile,
      );
      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featurePackage.cubit).thenReturn(({required name}) => cubit);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformFeatureRemoveCubit(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => cubit.delete(),
        () => applicationBarrelFile.removeExport('cool_cubit.dart'),
        () => flutterPubRunBuildRunnerBuildTask(
              manager,
              package: featurePackage,
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Cubit!')
      ]);
    });

    test('remove application barrel file if it does not contain any code',
        () async {
      final manager = MockProcessManager();
      final cubit = MockCubit();
      when(() => cubit.existsAny).thenReturn(true);
      final featureBarrelFile = MockDartFile(existsSync: true);
      final applicationBarrelFile = MockDartFile(existsSync: true);
      when(() => applicationBarrelFile.containsStatements()).thenReturn(false);
      final featurePackage = MockPlatformWidgetFeaturePackage(
        barrelFile: featureBarrelFile,
        applicationBarrelFile: applicationBarrelFile,
      );
      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featurePackage.cubit).thenReturn(({required name}) => cubit);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformFeatureRemoveCubit(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => cubit.delete(),
        () => applicationBarrelFile.removeExport('cool_cubit.dart'),
        () => applicationBarrelFile.deleteSync(recursive: true),
        () =>
            featureBarrelFile.removeExport('src/application/application.dart'),
        () => flutterPubRunBuildRunnerBuildTask(
              manager,
              package: featurePackage,
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Cubit!')
      ]);
    });

    test('throws PlatformNotActivatedException for an inactive platform',
        () async {
      final project = MockRapidProject();
      final rapid = getRapid(project: project);

      when(() => project.platformIsActivated(any())).thenReturn(false);

      expect(
        () => rapid.platformFeatureRemoveCubit(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException for a non-existent feature package',
        () async {
      final featurePackage = MockPlatformWidgetFeaturePackage();
      when(() => featurePackage.existsSync()).thenReturn(false);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureRemoveCubit(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('throws CubitNotFoundException for an existing cubit', () async {
      final cubit = MockCubit();
      when(() => cubit.existsAny).thenReturn(false);
      final featurePackage = MockPlatformWidgetFeaturePackage();
      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featurePackage.cubit).thenReturn(({required name}) => cubit);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureRemoveCubit(
          Platform.android,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<CubitNotFoundException>()),
      );
    });
  });

  group('platformRemoveFeature', () {
    test('removes a feature', () async {
      final manager = MockProcessManager();
      final platformRootPackage = MockNoneIosRootPackage();
      final platformNavigationPackage = MockPlatformNavigationPackage();
      final platformFeaturePackage = MockPlatformWidgetFeaturePackage(
        name: 'cool_widget',
        packageName: 'test_project_cool_widget',
      );
      when(() => platformFeaturePackage.existsSync()).thenReturn(true);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final remainingFeaturePubspecFile = MockPubspecYamlFile();
      when(
        () => remainingFeaturePubspecFile.hasDependency(
          name: 'test_project_cool_widget',
        ),
      ).thenReturn(true);
      final remainingFeaturePackage = MockPlatformWidgetFeaturePackage(
        pubSpec: remainingFeaturePubspecFile,
      );
      final platformFeaturePackages = [
        platformFeaturePackage,
        remainingFeaturePackage,
      ];
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: platformRootPackage,
            navigationPackage: platformNavigationPackage,
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackages: platformFeaturePackages,
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(
        project: project,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.platformRemoveFeature(
          Platform.android,
          name: 'cool_widget',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformRootPackage
            .unregisterFeaturePackage(platformFeaturePackage),
        () => remainingFeaturePubspecFile.removeDependency(
              name: 'test_project_cool_widget',
            ),
        () => melosBootstrapTask(
              manager,
              scope: [remainingFeaturePackage, platformRootPackage],
            ),
        () => flutterPubRunBuildRunnerBuildTask(
              manager,
              package: platformRootPackage,
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Feature!'),
      ]);
    });

    test('removes a feature (with navigator)', () async {
      final manager = MockProcessManager();
      final platformRootPackage = MockNoneIosRootPackage();
      final navigatorInterface = MockNavigatorInterface();
      when(() => navigatorInterface.existsAny).thenReturn(true);
      final navigationBarrelFile = MockDartFile();
      final platformNavigationPackage = MockPlatformNavigationPackage(
        barrelFile: navigationBarrelFile,
        navigatorInterface: ({required name}) => navigatorInterface,
      );
      final platformFeaturePackage = MockPlatformPageFeaturePackage(
        name: 'cool_page',
        packageName: 'test_project_cool_page',
      );
      when(() => platformFeaturePackage.existsSync()).thenReturn(true);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final remainingFeaturePubspecFile = MockPubspecYamlFile();
      when(
        () => remainingFeaturePubspecFile.hasDependency(
          name: 'test_project_cool_page',
        ),
      ).thenReturn(true);
      final remainingFeaturePackage = MockPlatformWidgetFeaturePackage(
        pubSpec: remainingFeaturePubspecFile,
      );
      final platformFeaturePackages = [
        platformFeaturePackage,
        remainingFeaturePackage,
      ];
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: platformRootPackage,
            navigationPackage: platformNavigationPackage,
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackages: platformFeaturePackages,
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(
        project: project,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.platformRemoveFeature(
          Platform.android,
          name: 'cool_page',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformRootPackage
            .unregisterFeaturePackage(platformFeaturePackage),
        () => remainingFeaturePubspecFile.removeDependency(
              name: 'test_project_cool_page',
            ),
        () => navigatorInterface.delete(),
        () =>
            navigationBarrelFile.removeExport('src/i_cool_page_navigator.dart'),
        () => melosBootstrapTask(
              manager,
              scope: [remainingFeaturePackage, platformRootPackage],
            ),
        () => flutterPubRunBuildRunnerBuildTask(
              manager,
              package: platformRootPackage,
            ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Feature!'),
      ]);
    });

    test(
        'throws PlatformNotActivatedException when the platform is not activated',
        () async {
      final project = MockRapidProject();
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveFeature(
          Platform.android,
          name: 'cool_page',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureNotFoundException when the feature package does not exist',
        () async {
      final featurePackage = MockPlatformPageFeaturePackage(name: 'cool_page');
      when(() => featurePackage.existsSync()).thenReturn(false);
      T featurePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          featurePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: featurePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveFeature(
          Platform.android,
          name: 'cool_page',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });
  });

  group('platformRemoveLanguage', () {
    test('removes a supported language', () async {
      final manager = MockProcessManager();
      final localizationPackage = MockPlatformLocalizationPackage();
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            localizationPackage: localizationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      when(() => localizationPackage.supportedLanguages()).thenReturn({
        Language(languageCode: 'en'),
        Language(languageCode: 'fr'),
        Language(languageCode: 'de'),
      });
      when(() => localizationPackage.defaultLanguage())
          .thenReturn(Language(languageCode: 'en'));
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformRemoveLanguage(
          Platform.android,
          language: Language(languageCode: 'fr'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => localizationPackage.removeLanguage(Language(languageCode: 'fr')),
        () => flutterGenl10nTask(manager, package: localizationPackage),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Language!')
      ]);
    });

    test('removes a supported language (ios)', () async {
      final manager = MockProcessManager();
      final rootPackage = MockIosRootPackage();
      final localizationPackage = MockPlatformLocalizationPackage();
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: rootPackage,
            localizationPackage: localizationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      when(() => localizationPackage.supportedLanguages()).thenReturn({
        Language(languageCode: 'en'),
        Language(languageCode: 'fr'),
        Language(languageCode: 'de'),
      });
      when(() => localizationPackage.defaultLanguage())
          .thenReturn(Language(languageCode: 'en'));
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformRemoveLanguage(
          Platform.android,
          language: Language(languageCode: 'fr'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => rootPackage.removeLanguage(Language(languageCode: 'fr')),
        () => localizationPackage.removeLanguage(Language(languageCode: 'fr')),
        () => flutterGenl10nTask(manager, package: localizationPackage),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Language!')
      ]);
    });

    test('removes a supported language (mobile)', () async {
      final manager = MockProcessManager();
      final rootPackage = MockMobileRootPackage();
      final localizationPackage = MockPlatformLocalizationPackage();
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            rootPackage: rootPackage,
            localizationPackage: localizationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      when(() => localizationPackage.supportedLanguages()).thenReturn({
        Language(languageCode: 'en'),
        Language(languageCode: 'fr'),
        Language(languageCode: 'de'),
      });
      when(() => localizationPackage.defaultLanguage())
          .thenReturn(Language(languageCode: 'en'));
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformRemoveLanguage(
          Platform.android,
          language: Language(languageCode: 'fr'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => rootPackage.removeLanguage(Language(languageCode: 'fr')),
        () => localizationPackage.removeLanguage(Language(languageCode: 'fr')),
        () => flutterGenl10nTask(manager, package: localizationPackage),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Language!')
      ]);
    });

    test('throws PlatformNotActivatedException for an inactive platform',
        () async {
      final project = MockRapidProject();
      final rapid = getRapid(project: project);

      when(() => project.platformIsActivated(any())).thenReturn(false);

      expect(
        () => rapid.platformRemoveLanguage(
          Platform.android,
          language: Language(languageCode: 'en'),
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws LanguageNotFoundException for an unsupported language',
        () async {
      final localizationPackage = MockPlatformLocalizationPackage();
      when(() => localizationPackage.supportedLanguages()).thenReturn({
        Language(languageCode: 'en'),
        Language(languageCode: 'fr'),
      });
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            localizationPackage: localizationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveLanguage(
          Platform.android,
          language: Language(languageCode: 'de'),
        ),
        throwsA(isA<LanguageNotFoundException>()),
      );
    });

    test('throws CantRemoveDefaultLanguageException for the default language',
        () async {
      final localizationPackage = MockPlatformLocalizationPackage();
      when(() => localizationPackage.supportedLanguages()).thenReturn({
        Language(languageCode: 'en'),
        Language(languageCode: 'fr'),
      });
      when(() => localizationPackage.defaultLanguage())
          .thenReturn(Language(languageCode: 'en'));
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            localizationPackage: localizationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveLanguage(
          Platform.android,
          language: Language(languageCode: 'en'),
        ),
        throwsA(isA<CantRemoveDefaultLanguageException>()),
      );
    });
  });

  group('platformRemoveNavigator', () {
    test('removes navigator for a routable feature package', () async {
      final manager = MockProcessManager();
      final navigatorInterface = MockNavigatorInterface();
      when(() => navigatorInterface.existsAny).thenReturn(true);
      final navigationBarrelFile = MockDartFile();
      final navigatorImplementation = MockNavigatorImplementation();
      when(() => navigatorImplementation.existsAny).thenReturn(true);
      final platformFeaturePackage = MockPlatformPageFeaturePackage(
        name: 'cool_page',
        navigatorImplementation: navigatorImplementation,
      );
      when(() => platformFeaturePackage.existsSync()).thenReturn(true);
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
            navigationPackage: MockPlatformNavigationPackage(
              barrelFile: navigationBarrelFile,
              navigatorInterface: ({required name}) => navigatorInterface,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformRemoveNavigator(
          Platform.android,
          featureName: 'cool_page',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => navigatorInterface.delete(),
        () =>
            navigationBarrelFile.removeExport('src/i_cool_page_navigator.dart'),
        () => navigatorImplementation.delete(),
        ...flutterPubRunBuildRunnerBuildTask(
          manager,
          package: platformFeaturePackage,
        ),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Navigator!')
      ]);
    });

    test('throws PlatformNotActivatedException for an inactive platform',
        () async {
      final project = MockRapidProject();
      final rapid = getRapid(project: project);

      when(() => project.platformIsActivated(any())).thenReturn(false);

      expect(
        () => rapid.platformRemoveNavigator(
          Platform.android,
          featureName: 'some_feature',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureNotRoutableException for a non-routable feature package',
        () async {
      final platformFeaturePackage =
          MockPlatformWidgetFeaturePackage(name: 'cool_widget');
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          platformFeaturePackage as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveNavigator(
          Platform.android,
          featureName: 'cool_widget',
        ),
        throwsA(isA<FeatureNotRoutableException>()),
      );
    });

    test('throws FeatureNotFoundException for a non-existing feature package',
        () async {
      T platformFeaturePackageBuilder<T extends PlatformFeaturePackage>({
        required String name,
      }) =>
          MockPlatformPageFeaturePackage(name: 'cool_page') as T;
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            featuresDirectory: MockPlatformFeaturesDirectory(
              featurePackage: platformFeaturePackageBuilder,
            ),
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveNavigator(
          Platform.android,
          featureName: 'non_existing',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });
  });

  group('platformSetDefaultLanguage', () {
    test('sets default language', () async {
      final manager = MockProcessManager();
      final localizationPackage = MockPlatformLocalizationPackage();
      when(() => localizationPackage.supportedLanguages()).thenReturn({
        Language(languageCode: 'en'),
        Language(languageCode: 'fr'),
      });
      when(() => localizationPackage.defaultLanguage())
          .thenReturn(Language(languageCode: 'en'));
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            localizationPackage: localizationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.platformSetDefaultLanguage(
          Platform.android,
          language: Language(languageCode: 'fr'),
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => localizationPackage.setDefaultLanguage(
              Language(languageCode: 'fr'),
            ),
        () => flutterGenl10nTask(manager, package: localizationPackage),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Set Default Language!')
      ]);
    });

    test('throws PlatformNotActivatedException for an inactive platform',
        () async {
      final project = MockRapidProject();
      final rapid = getRapid(project: project);

      when(() => project.platformIsActivated(any())).thenReturn(false);

      expect(
        () => rapid.platformSetDefaultLanguage(
          Platform.android,
          language: Language(languageCode: 'en'),
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws LanguageNotFoundException for an unsupported language',
        () async {
      final localizationPackage = MockPlatformLocalizationPackage();
      when(() => localizationPackage.supportedLanguages()).thenReturn({
        Language(languageCode: 'en'),
      });
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            localizationPackage: localizationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformSetDefaultLanguage(
          Platform.android,
          language: Language(languageCode: 'de'),
        ),
        throwsA(isA<LanguageNotFoundException>()),
      );
    });

    test(
        'throws LanguageIsAlreadyDefaultLanguageException for an already default language',
        () async {
      final localizationPackage = MockPlatformLocalizationPackage();
      when(() => localizationPackage.supportedLanguages()).thenReturn({
        Language(languageCode: 'en'),
      });
      when(() => localizationPackage.defaultLanguage())
          .thenReturn(Language(languageCode: 'en'));
      final project = MockRapidProject(
        appModule: MockAppModule(
          platformDirectory: ({required platform}) => MockPlatformDirectory(
            localizationPackage: localizationPackage,
          ),
        ),
      );
      when(() => project.platformIsActivated(any())).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformSetDefaultLanguage(
          Platform.android,
          language: Language(languageCode: 'en'),
        ),
        throwsA(isA<LanguageIsAlreadyDefaultLanguageException>()),
      );
    });
  });
}
