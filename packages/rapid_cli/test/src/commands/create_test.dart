import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io.dart' hide Platform;
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project_config.dart';
import 'package:test/test.dart';

import '../invocations.dart';
import '../mock_env.dart';
import '../mock_fs.dart';
import '../mocks.dart';

// TODO test loggs better and verify nothing ran on exception

Rapid _getRapid({
  RapidProject Function({required RapidProjectConfig config})? projectBuilder,
  MockRapidTool? tool,
  MockRapidLogger? logger,
}) {
  return Rapid(
    tool: tool ?? MockRapidTool(),
    logger: logger ?? MockRapidLogger(),
  )..projectBuilderOverrides = projectBuilder;
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('create', () {
    test(
      'throws OutputDirNotEmptyException when output directory is not empty',
      withMockFs(() async {
        final outputDir = 'some/path';
        // simulate non empty output dir
        File(p.join(outputDir, 'foo')).absolute.createSync(recursive: true);
        final rapid = _getRapid();

        expect(
          rapid.create(
            projectName: 'test_app',
            outputDir: outputDir,
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
            platforms: {},
          ),
          throwsA(isA<OutputDirNotEmptyException>()),
        );
        // TODO
/*         verifyNever(() => tool.loadGroup());
        verifyNever(() => tool.activateCommandGroup());
        verifyNever(() => logger.commandSuccess(any())); */
      }),
    );

    test(
      'creates project and activates no platforms',
      withMockFs(() async {
        final manager = MockProcessManager();
        final rootPackage = MockRootPackage();
        final diPackage = MockDiPackage();
        final defaultDomainPackage = MockDomainPackage();
        final defaultInfrastructurePackage = MockInfrastructurePackage();
        final loggingPackage = MockLoggingPackage();
        final uiPackage = MockUiPackage();
        final project = MockRapidProject(
          rootPackage: rootPackage,
          appModule: MockAppModule(
            diPackage: diPackage,
            domainDirectory: MockDomainDirectory(
              domainPackage: ({name}) => defaultDomainPackage,
            ),
            infrastructureDirectory: MockInfrastructureDirectory(
              infrastructurePackage: ({name}) => defaultInfrastructurePackage,
            ),
            loggingPackage: loggingPackage,
          ),
          uiModule: MockUiModule(uiPackage: uiPackage),
        );
        final projectBuilder = MockRapidProjectBuilder();
        when(() => projectBuilder(config: any(named: 'config')))
            .thenReturn(project);
        final logger = MockRapidLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.create(
            projectName: 'test_app',
            outputDir: 'some/path',
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
            platforms: {},
          ),
          manager: manager,
        );

        verifyInOrder([
          () => projectBuilder(
                config: RapidProjectConfig(
                  path: '/some/path',
                  name: 'test_app',
                ),
              ),
          () => logger.newLine(),
          () => logger.log('📦 Creating project'),
          () => logger.progress('Generating platform-independent packages'),
          () => rootPackage.generate(),
          () => diPackage.generate(),
          () => defaultDomainPackage.generate(),
          () => defaultInfrastructurePackage.generate(),
          () => loggingPackage.generate(),
          () => uiPackage.generate(),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              rootPackage,
              diPackage,
              defaultDomainPackage,
              defaultInfrastructurePackage,
              loggingPackage,
              uiPackage,
            ],
          ),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Created Project!'),
        ]);
        // TODO verify never activate platform
      }),
    );

    test(
      'creates project and activates Android',
      withMockFs(() async {
        final manager = MockProcessManager();
        final rootPackage = MockRootPackage();
        final diPackage = MockDiPackage();
        final defaultDomainPackage = MockDomainPackage();
        final defaultInfrastructurePackage = MockInfrastructurePackage();
        final loggingPackage = MockLoggingPackage();
        final uiPackage = MockUiPackage();
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
          rootPackage: rootPackage,
          appModule: MockAppModule(
            diPackage: diPackage,
            domainDirectory: MockDomainDirectory(
              domainPackage: ({name}) => defaultDomainPackage,
            ),
            infrastructureDirectory: MockInfrastructureDirectory(
              infrastructurePackage: ({name}) => defaultInfrastructurePackage,
            ),
            loggingPackage: loggingPackage,
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
            uiPackage: uiPackage,
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final projectBuilder = MockRapidProjectBuilder();
        when(() => projectBuilder(config: any(named: 'config')))
            .thenReturn(project);
        final logger = MockRapidLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.create(
            projectName: 'test_app',
            outputDir: 'some/path',
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
            platforms: {
              Platform.android,
            },
          ),
          manager: manager,
        );

        verifyInOrder([
          () => projectBuilder(
                config: RapidProjectConfig(
                  path: '/some/path',
                  name: 'test_app',
                ),
              ),
          () => logger.newLine(),
          () => logger.log('📦 Creating project'),
          () => logger.progress('Generating platform-independent packages'),
          () => rootPackage.generate(),
          () => diPackage.generate(),
          () => defaultDomainPackage.generate(),
          () => defaultInfrastructurePackage.generate(),
          () => loggingPackage.generate(),
          () => uiPackage.generate(),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              rootPackage,
              diPackage,
              defaultDomainPackage,
              defaultInfrastructurePackage,
              loggingPackage,
              uiPackage,
            ],
          ),
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
          () => logger.commandSuccess('Created Project!'),
        ]);
      }),
    );

    test(
      'creates project and activates iOS',
      withMockFs(() async {
        final manager = MockProcessManager();
        final rootPackage = MockRootPackage();
        final diPackage = MockDiPackage();
        final defaultDomainPackage = MockDomainPackage();
        final defaultInfrastructurePackage = MockInfrastructurePackage();
        final loggingPackage = MockLoggingPackage();
        final uiPackage = MockUiPackage();
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
          rootPackage: rootPackage,
          appModule: MockAppModule(
            diPackage: diPackage,
            domainDirectory: MockDomainDirectory(
              domainPackage: ({name}) => defaultDomainPackage,
            ),
            infrastructureDirectory: MockInfrastructureDirectory(
              infrastructurePackage: ({name}) => defaultInfrastructurePackage,
            ),
            loggingPackage: loggingPackage,
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
            uiPackage: uiPackage,
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final projectBuilder = MockRapidProjectBuilder();
        when(() => projectBuilder(config: any(named: 'config')))
            .thenReturn(project);
        final logger = MockRapidLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.create(
            projectName: 'test_app',
            outputDir: 'some/path',
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
            platforms: {
              Platform.ios,
            },
          ),
          manager: manager,
        );

        verifyInOrder([
          () => projectBuilder(
                config: RapidProjectConfig(
                  path: '/some/path',
                  name: 'test_app',
                ),
              ),
          () => logger.newLine(),
          () => logger.log('📦 Creating project'),
          () => logger.progress('Generating platform-independent packages'),
          () => rootPackage.generate(),
          () => diPackage.generate(),
          () => defaultDomainPackage.generate(),
          () => defaultInfrastructurePackage.generate(),
          () => loggingPackage.generate(),
          () => uiPackage.generate(),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              rootPackage,
              diPackage,
              defaultDomainPackage,
              defaultInfrastructurePackage,
              loggingPackage,
              uiPackage,
            ],
          ),
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
          () => logger.commandSuccess('Created Project!'),
        ]);
      }),
    );

    test(
      'creates project and activates Linux',
      withMockFs(() async {
        final manager = MockProcessManager();
        final rootPackage = MockRootPackage();
        final diPackage = MockDiPackage();
        final defaultDomainPackage = MockDomainPackage();
        final defaultInfrastructurePackage = MockInfrastructurePackage();
        final loggingPackage = MockLoggingPackage();
        final uiPackage = MockUiPackage();
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
          rootPackage: rootPackage,
          appModule: MockAppModule(
            diPackage: diPackage,
            domainDirectory: MockDomainDirectory(
              domainPackage: ({name}) => defaultDomainPackage,
            ),
            infrastructureDirectory: MockInfrastructureDirectory(
              infrastructurePackage: ({name}) => defaultInfrastructurePackage,
            ),
            loggingPackage: loggingPackage,
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
            uiPackage: uiPackage,
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final projectBuilder = MockRapidProjectBuilder();
        when(() => projectBuilder(config: any(named: 'config')))
            .thenReturn(project);
        final logger = MockRapidLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.create(
            projectName: 'test_app',
            outputDir: 'some/path',
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
            platforms: {
              Platform.linux,
            },
          ),
          manager: manager,
        );

        verifyInOrder([
          () => projectBuilder(
                config: RapidProjectConfig(
                  path: '/some/path',
                  name: 'test_app',
                ),
              ),
          () => logger.newLine(),
          () => logger.log('📦 Creating project'),
          () => logger.progress('Generating platform-independent packages'),
          () => rootPackage.generate(),
          () => diPackage.generate(),
          () => defaultDomainPackage.generate(),
          () => defaultInfrastructurePackage.generate(),
          () => loggingPackage.generate(),
          () => uiPackage.generate(),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              rootPackage,
              diPackage,
              defaultDomainPackage,
              defaultInfrastructurePackage,
              loggingPackage,
              uiPackage,
            ],
          ),
          () => logger.newLine(),
          () => appFeaturePackage.generate(),
          () => homePageFeaturePackage.generate(),
          () => localizationPackage.generate(
                defaultLanguage: Language(languageCode: 'fr'),
              ),
          () => navigationPackage.generate(),
          () => platformRootPackage.generate(
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
          ...flutterConfigEnablePlatform(manager, platform: Platform.linux),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Created Project!'),
        ]);
      }),
    );

    test(
      'creates project and activates macOS',
      withMockFs(() async {
        final manager = MockProcessManager();
        final rootPackage = MockRootPackage();
        final diPackage = MockDiPackage();
        final defaultDomainPackage = MockDomainPackage();
        final defaultInfrastructurePackage = MockInfrastructurePackage();
        final loggingPackage = MockLoggingPackage();
        final uiPackage = MockUiPackage();
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
          rootPackage: rootPackage,
          appModule: MockAppModule(
            diPackage: diPackage,
            domainDirectory: MockDomainDirectory(
              domainPackage: ({name}) => defaultDomainPackage,
            ),
            infrastructureDirectory: MockInfrastructureDirectory(
              infrastructurePackage: ({name}) => defaultInfrastructurePackage,
            ),
            loggingPackage: loggingPackage,
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
            uiPackage: uiPackage,
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final projectBuilder = MockRapidProjectBuilder();
        when(() => projectBuilder(config: any(named: 'config')))
            .thenReturn(project);
        final logger = MockRapidLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.create(
            projectName: 'test_app',
            outputDir: 'some/path',
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
            platforms: {
              Platform.macos,
            },
          ),
          manager: manager,
        );

        verifyInOrder([
          () => projectBuilder(
                config: RapidProjectConfig(
                  path: '/some/path',
                  name: 'test_app',
                ),
              ),
          () => logger.newLine(),
          () => logger.log('📦 Creating project'),
          () => logger.progress('Generating platform-independent packages'),
          () => rootPackage.generate(),
          () => diPackage.generate(),
          () => defaultDomainPackage.generate(),
          () => defaultInfrastructurePackage.generate(),
          () => loggingPackage.generate(),
          () => uiPackage.generate(),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              rootPackage,
              diPackage,
              defaultDomainPackage,
              defaultInfrastructurePackage,
              loggingPackage,
              uiPackage,
            ],
          ),
          () => logger.newLine(),
          () => appFeaturePackage.generate(),
          () => homePageFeaturePackage.generate(),
          () => localizationPackage.generate(
                defaultLanguage: Language(languageCode: 'fr'),
              ),
          () => navigationPackage.generate(),
          () => platformRootPackage.generate(
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
          ...flutterConfigEnablePlatform(manager, platform: Platform.macos),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Created Project!'),
        ]);
      }),
    );

    test(
      'creates project and activates Web',
      withMockFs(() async {
        final manager = MockProcessManager();
        final rootPackage = MockRootPackage();
        final diPackage = MockDiPackage();
        final defaultDomainPackage = MockDomainPackage();
        final defaultInfrastructurePackage = MockInfrastructurePackage();
        final loggingPackage = MockLoggingPackage();
        final uiPackage = MockUiPackage();
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
          rootPackage: rootPackage,
          appModule: MockAppModule(
            diPackage: diPackage,
            domainDirectory: MockDomainDirectory(
              domainPackage: ({name}) => defaultDomainPackage,
            ),
            infrastructureDirectory: MockInfrastructureDirectory(
              infrastructurePackage: ({name}) => defaultInfrastructurePackage,
            ),
            loggingPackage: loggingPackage,
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
            uiPackage: uiPackage,
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final projectBuilder = MockRapidProjectBuilder();
        when(() => projectBuilder(config: any(named: 'config')))
            .thenReturn(project);
        final logger = MockRapidLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.create(
            projectName: 'test_app',
            outputDir: 'some/path',
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
            platforms: {
              Platform.web,
            },
          ),
          manager: manager,
        );

        verifyInOrder([
          () => projectBuilder(
                config: RapidProjectConfig(
                  path: '/some/path',
                  name: 'test_app',
                ),
              ),
          () => logger.newLine(),
          () => logger.log('📦 Creating project'),
          () => logger.progress('Generating platform-independent packages'),
          () => rootPackage.generate(),
          () => diPackage.generate(),
          () => defaultDomainPackage.generate(),
          () => defaultInfrastructurePackage.generate(),
          () => loggingPackage.generate(),
          () => uiPackage.generate(),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              rootPackage,
              diPackage,
              defaultDomainPackage,
              defaultInfrastructurePackage,
              loggingPackage,
              uiPackage,
            ],
          ),
          () => logger.newLine(),
          () => appFeaturePackage.generate(),
          () => homePageFeaturePackage.generate(),
          () => localizationPackage.generate(
                defaultLanguage: Language(languageCode: 'fr'),
              ),
          () => navigationPackage.generate(),
          () => platformRootPackage.generate(
                description: 'Some desc.',
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
          ...flutterConfigEnablePlatform(manager, platform: Platform.web),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Created Project!'),
        ]);
      }),
    );

    test(
      'creates project and activates Windows',
      withMockFs(() async {
        final manager = MockProcessManager();
        final rootPackage = MockRootPackage();
        final diPackage = MockDiPackage();
        final defaultDomainPackage = MockDomainPackage();
        final defaultInfrastructurePackage = MockInfrastructurePackage();
        final loggingPackage = MockLoggingPackage();
        final uiPackage = MockUiPackage();
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
          rootPackage: rootPackage,
          appModule: MockAppModule(
            diPackage: diPackage,
            domainDirectory: MockDomainDirectory(
              domainPackage: ({name}) => defaultDomainPackage,
            ),
            infrastructureDirectory: MockInfrastructureDirectory(
              infrastructurePackage: ({name}) => defaultInfrastructurePackage,
            ),
            loggingPackage: loggingPackage,
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
            uiPackage: uiPackage,
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final projectBuilder = MockRapidProjectBuilder();
        when(() => projectBuilder(config: any(named: 'config')))
            .thenReturn(project);
        final logger = MockRapidLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.create(
            projectName: 'test_app',
            outputDir: 'some/path',
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
            platforms: {
              Platform.windows,
            },
          ),
          manager: manager,
        );

        verifyInOrder([
          () => projectBuilder(
                config: RapidProjectConfig(
                  path: '/some/path',
                  name: 'test_app',
                ),
              ),
          () => logger.newLine(),
          () => logger.log('📦 Creating project'),
          () => logger.progress('Generating platform-independent packages'),
          () => rootPackage.generate(),
          () => diPackage.generate(),
          () => defaultDomainPackage.generate(),
          () => defaultInfrastructurePackage.generate(),
          () => loggingPackage.generate(),
          () => uiPackage.generate(),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              rootPackage,
              diPackage,
              defaultDomainPackage,
              defaultInfrastructurePackage,
              loggingPackage,
              uiPackage,
            ],
          ),
          () => logger.newLine(),
          () => appFeaturePackage.generate(),
          () => homePageFeaturePackage.generate(),
          () => localizationPackage.generate(
                defaultLanguage: Language(languageCode: 'fr'),
              ),
          () => navigationPackage.generate(),
          () => platformRootPackage.generate(
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
          ...flutterConfigEnablePlatform(manager, platform: Platform.windows),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Created Project!'),
        ]);
      }),
    );

    test(
      'creates project and activates Mobile',
      withMockFs(() async {
        final manager = MockProcessManager();
        final rootPackage = MockRootPackage();
        final diPackage = MockDiPackage();
        final defaultDomainPackage = MockDomainPackage();
        final defaultInfrastructurePackage = MockInfrastructurePackage();
        final loggingPackage = MockLoggingPackage();
        final uiPackage = MockUiPackage();
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
          rootPackage: rootPackage,
          appModule: MockAppModule(
            diPackage: diPackage,
            domainDirectory: MockDomainDirectory(
              domainPackage: ({name}) => defaultDomainPackage,
            ),
            infrastructureDirectory: MockInfrastructureDirectory(
              infrastructurePackage: ({name}) => defaultInfrastructurePackage,
            ),
            loggingPackage: loggingPackage,
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
            uiPackage: uiPackage,
            platformUiPackage: ({required platform}) => platformUiPackage,
          ),
        );
        final projectBuilder = MockRapidProjectBuilder();
        when(() => projectBuilder(config: any(named: 'config')))
            .thenReturn(project);
        final logger = MockRapidLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await withMockProcessManager(
          () async => rapid.create(
            projectName: 'test_app',
            outputDir: 'some/path',
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
            platforms: {
              Platform.mobile,
            },
          ),
          manager: manager,
        );

        verifyInOrder([
          () => projectBuilder(
                config: RapidProjectConfig(
                  path: '/some/path',
                  name: 'test_app',
                ),
              ),
          () => logger.newLine(),
          () => logger.log('📦 Creating project'),
          () => logger.progress('Generating platform-independent packages'),
          () => rootPackage.generate(),
          () => diPackage.generate(),
          () => defaultDomainPackage.generate(),
          () => defaultInfrastructurePackage.generate(),
          () => loggingPackage.generate(),
          () => uiPackage.generate(),
          ...flutterPubGetTaskGroup(
            manager,
            packages: [
              rootPackage,
              diPackage,
              defaultDomainPackage,
              defaultInfrastructurePackage,
              loggingPackage,
              uiPackage,
            ],
          ),
          () => logger.newLine(),
          () => appFeaturePackage.generate(),
          () => homePageFeaturePackage.generate(),
          () => localizationPackage.generate(
                defaultLanguage: Language(languageCode: 'fr'),
              ),
          () => navigationPackage.generate(),
          () => platformRootPackage.generate(
                orgName: 'test.example',
                description: 'Some desc.',
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
          ...flutterConfigEnablePlatform(manager, platform: Platform.android),
          ...flutterConfigEnablePlatform(manager, platform: Platform.ios),
          () => logger.newLine(),
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Created Project!'),
        ]);
      }),
    );

    // TODO add test for all platforms ?
    ///  test(
    ///   'creates project and activates all platforms',
    ///   withMockFs(() async {
    ///     final manager = MockProcessManager();
    ///     final rootPackage = MockRootPackage();
    ///     final diPackage = MockDiPackage();
    ///     final defaultDomainPackage = MockDomainPackage();
    ///     final defaultInfrastructurePackage = MockInfrastructurePackage();
    ///     final loggingPackage = MockLoggingPackage();
    ///     final uiPackage = MockUiPackage();
    ///     final platformRootPackage = MockNoneIosRootPackage();
    ///     final localizationPackage = MockPlatformLocalizationPackage();
    ///     final navigationPackage = MockPlatformNavigationPackage();
    ///     final appFeaturePackage = MockPlatformAppFeaturePackage();
    ///     final homePageFeaturePackage = MockPlatformPageFeaturePackage();
    ///     T featurePackage<T extends PlatformFeaturePackage>({
    ///       required String name,
    ///     }) =>
    ///         homePageFeaturePackage as T;
    ///     final platformUiPackage = MockPlatformUiPackage();
    ///
    ///     final project = MockRapidProject(
    ///       rootPackage: rootPackage,
    ///       appModule: MockAppModule(
    ///         diPackage: diPackage,
    ///         domainDirectory: MockDomainDirectory(
    ///           domainPackage: ({name}) => defaultDomainPackage,
    ///         ),
    ///         infrastructureDirectory: MockInfrastructureDirectory(
    ///           infrastructurePackage: ({name}) => defaultInfrastructurePackage,
    ///         ),
    ///         loggingPackage: loggingPackage,
    ///         platformDirectory: ({required platform}) => MockPlatformDirectory(
    ///           rootPackage: platformRootPackage,
    ///           localizationPackage: localizationPackage,
    ///           navigationPackage: navigationPackage,
    ///           featuresDirectory: MockPlatformFeaturesDirectory(
    ///             appFeaturePackage: appFeaturePackage,
    ///             featurePackage: featurePackage,
    ///           ),
    ///         ),
    ///       ),
    ///       uiModule: MockUiModule(
    ///         uiPackage: uiPackage,
    ///         platformUiPackage: ({required platform}) => platformUiPackage,
    ///       ),
    ///     );
    ///     final projectBuilder = MockRapidProjectBuilder();
    ///     when(() => projectBuilder(config: any(named: 'config')))
    ///         .thenReturn(project);
    ///     final logger = MockRapidLogger();
    ///     final rapid = _getRapid(
    ///       projectBuilder: projectBuilder,
    ///       logger: logger,
    ///     );
    ///
    ///     await withMockProcessManager(
    ///       () async => rapid.create(
    ///         projectName: 'test_app',
    ///         outputDir: 'some/path',
    ///         description: 'Some desc.',
    ///         orgName: 'test.example',
    ///         language: Language(languageCode: 'fr'),
    ///         platforms: {
    ///           Platform.android,
    ///           Platform.ios,
    ///           Platform.linux,
    ///           Platform.macos,
    ///           Platform.web,
    ///           Platform.windows,
    ///           Platform.mobile,
    ///         },
    ///       ),
    ///       manager: manager,
    ///     );
    ///
    ///     verifyInOrder([
    ///       () => projectBuilder(
    ///             config: RapidProjectConfig(
    ///               path: '/some/path',
    ///               name: 'test_app',
    ///             ),
    ///           ),
    ///       () => logger.newLine(),
    ///       () => logger.log('📦 Creating project'),
    ///       () => logger.progress('Generating platform-independent packages'),
    ///       () => rootPackage.generate(),
    ///       () => diPackage.generate(),
    ///       () => defaultDomainPackage.generate(),
    ///       () => defaultInfrastructurePackage.generate(),
    ///       () => loggingPackage.generate(),
    ///       () => uiPackage.generate(),
    ///       ...flutterPubGetTaskGroup(
    ///         manager,
    ///         packages: [
    ///           rootPackage,
    ///           diPackage,
    ///           defaultDomainPackage,
    ///           defaultInfrastructurePackage,
    ///           loggingPackage,
    ///           uiPackage,
    ///         ],
    ///       ),
    ///       () => logger.newLine(),
    ///       () => appFeaturePackage.generate(),
    ///       () => homePageFeaturePackage.generate(),
    ///       () => localizationPackage.generate(
    ///             defaultLanguage: Language(languageCode: 'fr'),
    ///           ),
    ///       () => navigationPackage.generate(),
    ///       () => platformRootPackage.generate(
    ///             description: 'Some desc.',
    ///             orgName: 'test.example',
    ///           ),
    ///       () => platformUiPackage.generate(),
    ///       ...flutterPubGetTaskGroup(
    ///         manager,
    ///         packages: [
    ///           appFeaturePackage,
    ///           homePageFeaturePackage,
    ///           localizationPackage,
    ///           navigationPackage,
    ///           platformRootPackage,
    ///           platformUiPackage,
    ///         ],
    ///       ),
    ///       ...flutterGenl10nTask(manager, package: localizationPackage),
    ///       ...flutterConfigEnablePlatform(manager, platform: Platform.android),
    ///       ...flutterConfigEnablePlatform(manager, platform: Platform.ios),
    ///       ...flutterConfigEnablePlatform(manager, platform: Platform.linux),
    ///       ...flutterConfigEnablePlatform(manager, platform: Platform.macos),
    ///       ...flutterConfigEnablePlatform(manager, platform: Platform.web),
    ///       ...flutterConfigEnablePlatform(manager, platform: Platform.windows),
    ///       ...flutterConfigEnablePlatform(manager, platform: Platform.mobile),
    ///       () => logger.newLine(),
    ///       ...dartFormatFixTask(manager),
    ///       () => logger.newLine(),
    ///       () => logger.commandSuccess('Created Project!'),
    ///     ]);
    ///   }),
    /// );
    ///

    // TODO add macos regression
    ///  test(
    ///   'regression issue 96: Podfile creation (file does not exist)',
    ///   withMockFs(() async {
    ///     final manager = MockProcessManager();
    ///     final rootPackage = MockMacosRootPackage();
    ///     final platformRootPackage = MockMacosRootPackage();
    ///     final podFile = MockFile();
    ///     when(() => podFile.existsSync()).thenReturn(false);
    ///     when(() => rootPackage.nativeDirectory.podFile).thenReturn(podFile);
    ///
    ///     final project = MockRapidProject(
    ///       rootPackage: rootPackage,
    ///       appModule: MockAppModule(
    ///         platformDirectory: ({required platform}) => MockPlatformDirectory(
    ///           rootPackage: platformRootPackage,
    ///         ),
    ///       ),
    ///     );
    ///     final projectBuilder = MockRapidProjectBuilder();
    ///     when(() => projectBuilder(config: any(named: 'config')))
    ///         .thenReturn(project);
    ///     final logger = MockRapidLogger();
    ///     final rapid = _getRapid(
    ///       projectBuilder: projectBuilder,
    ///       logger: logger,
    ///     );
    ///
    ///     await rapid.__activatePlatform(Platform.macos);
    ///
    ///     verify(() => logger.log('Modifying Podfile for macOS')).called(1);
    ///     verify(() => replaceInFile(any(named: 'file'), any(named: 'pattern'),
    ///         any(named: 'replacement'))).called(1);
    ///   }),
    /// );
    ///
    /// test(
    ///   'regression issue 96: Podfile modification (file exists)',
    ///   withMockFs(() async {
    ///     final manager = MockProcessManager();
    ///     final rootPackage = MockMacosRootPackage();
    ///     final platformRootPackage = MockMacosRootPackage();
    ///     final podFile = MockFile();
    ///     when(() => podFile.existsSync()).thenReturn(true);
    ///     when(() => rootPackage.nativeDirectory.podFile).thenReturn(podFile);
    ///
    ///     final project = MockRapidProject(
    ///       rootPackage: rootPackage,
    ///       appModule: MockAppModule(
    ///         platformDirectory: ({required platform}) => MockPlatformDirectory(
    ///           rootPackage: platformRootPackage,
    ///         ),
    ///       ),
    ///     );
    ///     final projectBuilder = MockRapidProjectBuilder();
    ///     when(() => projectBuilder(config: any(named: 'config')))
    ///         .thenReturn(project);
    ///     final logger = MockRapidLogger();
    ///     final rapid = _getRapid(
    ///       projectBuilder: projectBuilder,
    ///       logger: logger,
    ///     );
    ///
    ///     await rapid.__activatePlatform(Platform.macos);
    ///
    ///     verify(() => logger.log('Modifying Podfile for macOS')).called(1);
    ///     verify(() => replaceInFile(any(named: 'file'), any(named: 'pattern'),
    ///         any(named: 'replacement'))).called(1);
    ///   }),
    /// );
  });
}
