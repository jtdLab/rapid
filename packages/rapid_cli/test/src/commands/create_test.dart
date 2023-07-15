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
    // TODO finish impl

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
            platformDirectory: ({required Platform platform}) =>
                MockPlatformDirectory(
              rootPackage: switch (platform) {
                Platform.ios => MockIosRootPackage(),
                Platform.macos => MockMacosRootPackage(),
                Platform.mobile => MockMobileRootPackage(),
                _ => MockNoneIosRootPackage(),
              },
              featuresDirectory: MockPlatformFeaturesDirectory(),
            ),
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
          // TODO generat platform independent
          () => rootPackage.generate(),
          //TODO flutter pub get task
          () => logger.newLine(),
          // TODO platform dependent
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Created Project!'),
        ]);
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
        final project = MockRapidProject(
          rootPackage: rootPackage,
          appModule: MockAppModule(
            platformDirectory: ({required Platform platform}) =>
                MockPlatformDirectory(
              rootPackage: switch (platform) {
                Platform.ios => MockIosRootPackage(),
                Platform.macos => MockMacosRootPackage(),
                Platform.mobile => MockMobileRootPackage(),
                _ => MockNoneIosRootPackage(),
              },
              featuresDirectory: MockPlatformFeaturesDirectory(),
            ),
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
          // TODO generat platform independent
          () => rootPackage.generate(),
          //TODO flutter pub get task
          () => logger.newLine(),
          // TODO platform dependent
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Created Project!'),
        ]);
      }),
    );

    test(
      'creates project and activates all platforms',
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
            platformDirectory: ({required Platform platform}) =>
                MockPlatformDirectory(
              rootPackage: switch (platform) {
                Platform.ios => MockIosRootPackage(),
                Platform.macos => MockMacosRootPackage(),
                Platform.mobile => MockMobileRootPackage(),
                _ => MockNoneIosRootPackage(),
              },
              featuresDirectory: MockPlatformFeaturesDirectory(),
            ),
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
            platforms: Platform.values.toSet(),
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
          // TODO generat platform independent
          () => rootPackage.generate(),
          //TODO flutter pub get task
          () => logger.newLine(),
          // TODO platform dependent
          ...dartFormatFixTask(manager),
          () => logger.newLine(),
          () => logger.commandSuccess('Created Project!'),
        ]);
      }),
    );
  });
}
