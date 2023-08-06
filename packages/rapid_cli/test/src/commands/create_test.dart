import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io/io.dart' hide Platform;
import 'package:rapid_cli/src/logging.dart';
import 'package:rapid_cli/src/native_platform.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project_config.dart';
import 'package:rapid_cli/src/tool.dart';
import 'package:test/test.dart';

import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

// TODO refactor using global setup and share some logic with activate

typedef _ProjectSetup<T extends PlatformRootPackage> = ({
  RootPackage rootPackage,
  DiPackage diPackage,
  DomainPackage defaultDomainPackage,
  InfrastructurePackage defaultInfrastructurePackage,
  LoggingPackage loggingPackage,
  UiPackage uiPackage,
  RapidProject project,
});

typedef _ProjectWithPlatformSetup<T extends PlatformRootPackage> = ({
  RootPackage rootPackage,
  DiPackage diPackage,
  DomainPackage defaultDomainPackage,
  InfrastructurePackage defaultInfrastructurePackage,
  LoggingPackage loggingPackage,
  UiPackage uiPackage,
  T platformRootPackage,
  PlatformLocalizationPackage platformLocalizationPackage,
  PlatformNavigationPackage platformNavigationPackage,
  PlatformAppFeaturePackage platformAppFeaturePackage,
  PlatformPageFeaturePackage platformHomePageFeaturePackage,
  PlatformUiPackage platformUiPackage,
  RapidProject project,
});

_ProjectSetup _setupProject() {
  final rootPackage = MockRootPackage(
    packageName: 'root_package',
    path: 'root_package_path',
  );
  final diPackage = MockDiPackage(
    packageName: 'di_package',
    path: 'di_package_path',
  );
  final defaultDomainPackage = MockDomainPackage(
    packageName: 'domain_package',
    path: 'domain_package_path',
  );
  final defaultInfrastructurePackage = MockInfrastructurePackage(
    packageName: 'infrastructure_package',
    path: 'infrastructure_package_path',
  );
  final loggingPackage = MockLoggingPackage(
    packageName: 'logging_package',
    path: 'logging_package_path',
  );
  final uiPackage = MockUiPackage(
    packageName: 'ui_package',
    path: 'ui_package_path',
  );
  final project = MockRapidProject(
    path: 'project_path',
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
    uiModule: MockUiModule(
      uiPackage: uiPackage,
    ),
  );

  return (
    rootPackage: rootPackage,
    diPackage: diPackage,
    defaultDomainPackage: defaultDomainPackage,
    defaultInfrastructurePackage: defaultInfrastructurePackage,
    loggingPackage: loggingPackage,
    uiPackage: uiPackage,
    project: project,
  );
}

_ProjectWithPlatformSetup
    _setupProjectWithPlatform<T extends PlatformRootPackage>() {
  final (
    rootPackage: rootPackage,
    diPackage: diPackage,
    defaultDomainPackage: defaultDomainPackage,
    defaultInfrastructurePackage: defaultInfrastructurePackage,
    loggingPackage: loggingPackage,
    uiPackage: uiPackage,
    project: _,
  ) = _setupProject();
  final platformRootPackage = switch (T) {
    IosRootPackage => MockIosRootPackage(
        packageName: 'platform_root_package',
        path: 'platform_root_package_path',
      ),
    MacosRootPackage => MockMacosRootPackage(
        packageName: 'platform_root_package',
        path: 'platform_root_package_path',
      ),
    MobileRootPackage => MockMobileRootPackage(
        packageName: 'platform_root_package',
        path: 'platform_root_package_path',
      ),
    _ => MockNoneIosRootPackage(
        packageName: 'platform_root_package',
        path: 'platform_root_package_path',
      ),
  } as T;
  final platformLocalizationPackage = MockPlatformLocalizationPackage(
    packageName: 'platform_localization_package',
    path: 'platform_localization_package_path',
  );
  final platformNavigationPackage = MockPlatformNavigationPackage(
    packageName: 'platform_navigation_package',
    path: 'platform_navigation_package_path',
  );
  final platformAppFeaturePackage = MockPlatformAppFeaturePackage(
    packageName: 'platform_app_feature_package',
    path: 'platform_app_feature_package_path',
  );
  final platformHomePageFeaturePackage = MockPlatformPageFeaturePackage(
    packageName: 'platform_home_page_feature_package',
    path: 'platform_home_page_feature_package_path',
  );
  P platformFeaturePackage<P extends PlatformFeaturePackage>({
    required String name,
  }) =>
      platformHomePageFeaturePackage as P;
  final platformUiPackage = MockPlatformUiPackage(
    packageName: 'platform_ui_package',
    path: 'platform_ui_package_path',
  );
  final project = MockRapidProject(
    path: 'project_path',
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
        localizationPackage: platformLocalizationPackage,
        navigationPackage: platformNavigationPackage,
        featuresDirectory: MockPlatformFeaturesDirectory(
          appFeaturePackage: platformAppFeaturePackage,
          featurePackage: platformFeaturePackage,
        ),
      ),
    ),
    uiModule: MockUiModule(
      uiPackage: uiPackage,
      platformUiPackage: ({required platform}) => platformUiPackage,
    ),
  );

  return (
    rootPackage: rootPackage,
    diPackage: diPackage,
    defaultDomainPackage: defaultDomainPackage,
    defaultInfrastructurePackage: defaultInfrastructurePackage,
    loggingPackage: loggingPackage,
    uiPackage: uiPackage,
    platformRootPackage: platformRootPackage,
    platformLocalizationPackage: platformLocalizationPackage,
    platformNavigationPackage: platformNavigationPackage,
    platformAppFeaturePackage: platformAppFeaturePackage,
    platformHomePageFeaturePackage: platformHomePageFeaturePackage,
    platformUiPackage: platformUiPackage,
    project: project,
  );
}

Rapid _getRapid({
  RapidProject Function({required RapidProjectConfig config})? projectBuilder,
  RapidTool? tool,
  RapidLogger? logger,
}) {
  return Rapid(
    tool: tool ?? MockRapidTool(),
    logger: logger ?? MockRapidLogger(),
  )..projectBuilderOverrides = projectBuilder;
}

void _verifyCreateProjectAndActivatePlatform<T extends PlatformRootPackage>(
  Platform platform, {
  required ProcessManager manager,
  required _ProjectWithPlatformSetup<T> projectSetup,
  required MockRapidProjectBuilder projectBuilder,
  required LoggerSetup loggerSetup,
}) {
  final (
    rootPackage: rootPackage,
    diPackage: diPackage,
    defaultDomainPackage: defaultDomainPackage,
    defaultInfrastructurePackage: defaultInfrastructurePackage,
    loggingPackage: loggingPackage,
    uiPackage: uiPackage,
    platformRootPackage: platformRootPackage,
    platformLocalizationPackage: platformLocalizationPackage,
    platformNavigationPackage: platformNavigationPackage,
    platformAppFeaturePackage: platformAppFeaturePackage,
    platformHomePageFeaturePackage: platformHomePageFeaturePackage,
    platformUiPackage: platformUiPackage,
    project: _,
  ) = projectSetup;
  final (
    progress: progress,
    groupableProgress: groupableProgress,
    progressGroup: progressGroup,
    logger: logger,
  ) = loggerSetup;

  verifyInOrder([
    () => projectBuilder(
          config: RapidProjectConfig(
            path: '/some/path',
            name: 'test_app',
          ),
        ),
    logger.newLine,
    () => logger.info('📦 Creating project'),
    () => logger.progress('Generating platform-independent packages'),
    rootPackage.generate,
    diPackage.generate,
    defaultDomainPackage.generate,
    defaultInfrastructurePackage.generate,
    loggingPackage.generate,
    uiPackage.generate,
    progress.complete,
    logger.progressGroup,
    () => progressGroup.progress('Running "dart pub get" in root_package'),
    () => manager.runDartPubGet(workingDirectory: 'root_package_path'),
    groupableProgress.complete,
    () => progressGroup.progress('Running "dart pub get" in di_package'),
    () => manager.runDartPubGet(workingDirectory: 'di_package_path'),
    groupableProgress.complete,
    () => progressGroup.progress('Running "dart pub get" in domain_package'),
    () => manager.runDartPubGet(workingDirectory: 'domain_package_path'),
    groupableProgress.complete,
    () => progressGroup
        .progress('Running "dart pub get" in infrastructure_package'),
    () =>
        manager.runDartPubGet(workingDirectory: 'infrastructure_package_path'),
    groupableProgress.complete,
    () => progressGroup.progress('Running "dart pub get" in logging_package'),
    () => manager.runDartPubGet(workingDirectory: 'logging_package_path'),
    groupableProgress.complete,
    () => progressGroup.progress('Running "dart pub get" in ui_package'),
    () => manager.runDartPubGet(workingDirectory: 'ui_package_path'),
    groupableProgress.complete,
    logger.newLine,
    () => logger.info('🚀 Activating ${platform.prettyName}'),
    () => logger.progress('Generating ${platform.prettyName} packages'),
    platformAppFeaturePackage.generate,
    platformHomePageFeaturePackage.generate,
    () => platformLocalizationPackage.generate(
          defaultLanguage: const Language(languageCode: 'fr'),
        ),
    platformNavigationPackage.generate,
    switch (platform) {
      Platform.android => () =>
          (platformRootPackage as NoneIosRootPackage).generate(
            orgName: 'test.example',
            description: 'Some desc.',
          ),
      Platform.ios => () => (platformRootPackage as IosRootPackage).generate(
            orgName: 'test.example',
            language: const Language(languageCode: 'fr'),
          ),
      Platform.linux => () =>
          (platformRootPackage as NoneIosRootPackage).generate(
            orgName: 'test.example',
          ),
      Platform.macos => () =>
          (platformRootPackage as MacosRootPackage).generate(
            orgName: 'test.example',
          ),
      Platform.web => () =>
          (platformRootPackage as NoneIosRootPackage).generate(
            description: 'Some desc.',
          ),
      Platform.windows => () =>
          (platformRootPackage as NoneIosRootPackage).generate(
            orgName: 'test.example',
          ),
      Platform.mobile => () =>
          (platformRootPackage as MobileRootPackage).generate(
            description: 'Some desc.',
            orgName: 'test.example',
            language: const Language(languageCode: 'fr'),
          ),
    },
    platformUiPackage.generate,
    progress.complete,
    logger.progressGroup,
    () => progressGroup
        .progress('Running "dart pub get" in platform_app_feature_package'),
    () => manager.runDartPubGet(
          workingDirectory: 'platform_app_feature_package_path',
        ),
    groupableProgress.complete,
    () => progressGroup.progress(
          'Running "dart pub get" in platform_home_page_feature_package',
        ),
    () => manager.runDartPubGet(
          workingDirectory: 'platform_home_page_feature_package_path',
        ),
    groupableProgress.complete,
    () => progressGroup
        .progress('Running "dart pub get" in platform_localization_package'),
    () => manager.runDartPubGet(
          workingDirectory: 'platform_localization_package_path',
        ),
    groupableProgress.complete,
    () => progressGroup
        .progress('Running "dart pub get" in platform_navigation_package'),
    () => manager.runDartPubGet(
          workingDirectory: 'platform_navigation_package_path',
        ),
    groupableProgress.complete,
    () => progressGroup
        .progress('Running "dart pub get" in platform_root_package'),
    () => manager.runDartPubGet(workingDirectory: 'platform_root_package_path'),
    groupableProgress.complete,
    () =>
        progressGroup.progress('Running "dart pub get" in platform_ui_package'),
    () => manager.runDartPubGet(workingDirectory: 'platform_ui_package_path'),
    groupableProgress.complete,
    () => logger.progress(
          'Running "flutter gen-l10n" in platform_localization_package',
        ),
    () => manager.runFlutterGenl10n(
          workingDirectory: 'platform_localization_package_path',
        ),
    progress.complete,
    ...switch (platform) {
      Platform.android => [
          () => logger.progress('Running "flutter config --enable-android"'),
          () => manager.runFlutterConfigEnablePlatform(NativePlatform.android),
          progress.complete,
        ],
      Platform.ios => [
          () => logger.progress('Running "flutter config --enable-ios"'),
          () => manager.runFlutterConfigEnablePlatform(NativePlatform.ios),
          progress.complete,
        ],
      Platform.linux => [
          () => logger
              .progress('Running "flutter config --enable-linux-desktop"'),
          () => manager.runFlutterConfigEnablePlatform(NativePlatform.linux),
          progress.complete,
        ],
      Platform.macos => [
          () => logger
              .progress('Running "flutter config --enable-macos-desktop"'),
          () => manager.runFlutterConfigEnablePlatform(NativePlatform.macos),
          progress.complete,
        ],
      Platform.web => [
          () => logger.progress('Running "flutter config --enable-web"'),
          () => manager.runFlutterConfigEnablePlatform(NativePlatform.web),
          progress.complete,
        ],
      Platform.windows => [
          () => logger
              .progress('Running "flutter config --enable-windows-desktop"'),
          () => manager.runFlutterConfigEnablePlatform(NativePlatform.windows),
          progress.complete,
        ],
      Platform.mobile => [
          () => logger.progress('Running "flutter config --enable-android"'),
          () => manager.runFlutterConfigEnablePlatform(NativePlatform.android),
          progress.complete,
          () => logger.progress('Running "flutter config --enable-ios"'),
          () => manager.runFlutterConfigEnablePlatform(NativePlatform.ios),
          progress.complete,
        ],
    },
    logger.newLine,
    () => logger.progress('Running "dart format . --fix" in project'),
    () => manager.runDartFormatFix(workingDirectory: 'project_path'),
    progress.complete,
    logger.newLine,
    () => logger.commandSuccess('Created Project!'),
  ]);
  verifyNoMoreInteractions(manager);
  verifyNoMoreInteractions(logger);
  verifyNoMoreInteractions(progress);
  verifyNoMoreInteractions(progressGroup);
  verifyNoMoreInteractions(groupableProgress);
}

void main() {
  setUpAll(registerFallbackValues);

  group('create', () {
    test(
      'throws OutputDirNotEmptyException when output directory is not empty',
      withMockFs(() async {
        const outputDir = 'some/path';
        // simulate non empty output dir
        File(p.join(outputDir, 'foo')).createSync(recursive: true);
        final rapid = _getRapid();

        expect(
          rapid.create(
            projectName: 'test_app',
            outputDir: outputDir,
            description: 'Some desc.',
            orgName: 'test.example',
            language: const Language(languageCode: 'fr'),
            platforms: {},
          ),
          throwsA(isA<OutputDirNotEmptyException>()),
        );
      }),
    );

    test(
      'creates project and activates no platforms',
      withMockEnv((manager) async {
        final (
          rootPackage: rootPackage,
          diPackage: diPackage,
          defaultDomainPackage: defaultDomainPackage,
          defaultInfrastructurePackage: defaultInfrastructurePackage,
          loggingPackage: loggingPackage,
          uiPackage: uiPackage,
          project: project,
        ) = _setupProject();
        final projectBuilder = MockRapidProjectBuilder(project: project);
        final (
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger
        ) = setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder.call,
          logger: logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: const Language(languageCode: 'fr'),
          platforms: {},
        );

        verifyInOrder([
          () => projectBuilder(
                config: RapidProjectConfig(
                  path: '/some/path',
                  name: 'test_app',
                ),
              ),
          logger.newLine,
          () => logger.info('📦 Creating project'),
          () => logger.progress('Generating platform-independent packages'),
          rootPackage.generate,
          diPackage.generate,
          defaultDomainPackage.generate,
          defaultInfrastructurePackage.generate,
          loggingPackage.generate,
          uiPackage.generate,
          progress.complete,
          logger.progressGroup,
          () =>
              progressGroup.progress('Running "dart pub get" in root_package'),
          () => manager.runDartPubGet(workingDirectory: 'root_package_path'),
          groupableProgress.complete,
          () => progressGroup.progress('Running "dart pub get" in di_package'),
          () => manager.runDartPubGet(workingDirectory: 'di_package_path'),
          groupableProgress.complete,
          () => progressGroup
              .progress('Running "dart pub get" in domain_package'),
          () => manager.runDartPubGet(workingDirectory: 'domain_package_path'),
          groupableProgress.complete,
          () => progressGroup
              .progress('Running "dart pub get" in infrastructure_package'),
          () => manager.runDartPubGet(
                workingDirectory: 'infrastructure_package_path',
              ),
          groupableProgress.complete,
          () => progressGroup
              .progress('Running "dart pub get" in logging_package'),
          () => manager.runDartPubGet(workingDirectory: 'logging_package_path'),
          groupableProgress.complete,
          () => progressGroup.progress('Running "dart pub get" in ui_package'),
          () => manager.runDartPubGet(workingDirectory: 'ui_package_path'),
          groupableProgress.complete,
          logger.newLine,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Created Project!'),
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
        verifyNoMoreInteractions(progressGroup);
        verifyNoMoreInteractions(groupableProgress);
      }),
    );

    test(
      'creates project and activates Android',
      withMockEnv((manager) async {
        final projectSetup = _setupProjectWithPlatform<NoneIosRootPackage>();
        final projectBuilder =
            MockRapidProjectBuilder(project: projectSetup.project);
        final loggerSetup = setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder.call,
          logger: loggerSetup.logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: const Language(languageCode: 'fr'),
          platforms: {Platform.android},
        );

        _verifyCreateProjectAndActivatePlatform(
          Platform.android,
          manager: manager,
          projectSetup: projectSetup,
          projectBuilder: projectBuilder,
          loggerSetup: loggerSetup,
        );
      }),
    );

    test(
      'creates project and activates iOS',
      withMockEnv((manager) async {
        final projectSetup = _setupProjectWithPlatform<IosRootPackage>();
        final projectBuilder =
            MockRapidProjectBuilder(project: projectSetup.project);
        final loggerSetup = setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder.call,
          logger: loggerSetup.logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: const Language(languageCode: 'fr'),
          platforms: {Platform.ios},
        );

        _verifyCreateProjectAndActivatePlatform(
          Platform.ios,
          manager: manager,
          projectSetup: projectSetup,
          projectBuilder: projectBuilder,
          loggerSetup: loggerSetup,
        );
      }),
    );

    test(
      'creates project and activates Linux',
      withMockEnv((manager) async {
        final projectSetup = _setupProjectWithPlatform<NoneIosRootPackage>();
        final projectBuilder =
            MockRapidProjectBuilder(project: projectSetup.project);
        final loggerSetup = setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder.call,
          logger: loggerSetup.logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: const Language(languageCode: 'fr'),
          platforms: {Platform.linux},
        );

        _verifyCreateProjectAndActivatePlatform(
          Platform.linux,
          manager: manager,
          projectSetup: projectSetup,
          projectBuilder: projectBuilder,
          loggerSetup: loggerSetup,
        );
      }),
    );

    test(
      'creates project and activates macOS',
      withMockEnv((manager) async {
        final projectSetup = _setupProjectWithPlatform<MacosRootPackage>();
        final projectBuilder =
            MockRapidProjectBuilder(project: projectSetup.project);
        final loggerSetup = setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder.call,
          logger: loggerSetup.logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: const Language(languageCode: 'fr'),
          platforms: {Platform.macos},
        );

        _verifyCreateProjectAndActivatePlatform(
          Platform.macos,
          manager: manager,
          projectSetup: projectSetup,
          projectBuilder: projectBuilder,
          loggerSetup: loggerSetup,
        );
      }),
    );

    test(
      'creates project and activates Web',
      withMockEnv((manager) async {
        final projectSetup = _setupProjectWithPlatform<NoneIosRootPackage>();
        final projectBuilder =
            MockRapidProjectBuilder(project: projectSetup.project);
        final loggerSetup = setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder.call,
          logger: loggerSetup.logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: const Language(languageCode: 'fr'),
          platforms: {Platform.web},
        );

        _verifyCreateProjectAndActivatePlatform(
          Platform.web,
          manager: manager,
          projectSetup: projectSetup,
          projectBuilder: projectBuilder,
          loggerSetup: loggerSetup,
        );
      }),
    );

    test(
      'creates project and activates Windows',
      withMockEnv((manager) async {
        final projectSetup = _setupProjectWithPlatform<NoneIosRootPackage>();
        final projectBuilder =
            MockRapidProjectBuilder(project: projectSetup.project);
        final loggerSetup = setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder.call,
          logger: loggerSetup.logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: const Language(languageCode: 'fr'),
          platforms: {Platform.windows},
        );

        _verifyCreateProjectAndActivatePlatform(
          Platform.windows,
          manager: manager,
          projectSetup: projectSetup,
          projectBuilder: projectBuilder,
          loggerSetup: loggerSetup,
        );
      }),
    );

    test(
      'creates project and activates Mobile',
      withMockEnv((manager) async {
        final projectSetup = _setupProjectWithPlatform<MobileRootPackage>();
        final projectBuilder =
            MockRapidProjectBuilder(project: projectSetup.project);
        final loggerSetup = setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder.call,
          logger: loggerSetup.logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: const Language(languageCode: 'fr'),
          platforms: {Platform.mobile},
        );

        _verifyCreateProjectAndActivatePlatform(
          Platform.mobile,
          manager: manager,
          projectSetup: projectSetup,
          projectBuilder: projectBuilder,
          loggerSetup: loggerSetup,
        );
      }),
    );

    // TODO
/*     test(
      'creates project and activates all platforms',
      withMockEnv((manager) async {
        final projectSetup = _setupProjectWithPlatform<NoneIosRootPackage>();
        final projectBuilder =
            MockRapidProjectBuilder(project: projectSetup.project);
        final loggerSetup = setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: loggerSetup.logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
          platforms: Platform.values.toSet(),
        );

        _verifyCreateProjectAndActivatePlatform(
          Platform.android,
          manager: manager,
          projectSetup: projectSetup,
          projectBuilder: projectBuilder,
          loggerSetup: loggerSetup,
        );
      }),
    ); */
  });
}
