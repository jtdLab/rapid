import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io.dart' hide Platform;
import 'package:rapid_cli/src/logging.dart';
import 'package:rapid_cli/src/process.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project_config.dart';
import 'package:rapid_cli/src/tool.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../invocations.dart';
import '../mock_env.dart';
import '../mock_fs.dart';
import '../mocks.dart';
import '../utils.dart';

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

(
  Progress progress,
  GroupableProgress groupableProgress,
  ProgressGroup progressGroup,
  RapidLogger logger
) setupLogger() {
  final progress = MockProgress();
  final groupableProgress = MockGroupableProgress();
  final progressGroup = MockProgressGroup(progress: groupableProgress);
  final logger =
      MockRapidLogger(progress: progress, progressGroup: progressGroup);

  return (progress, groupableProgress, progressGroup, logger);
}

(
  RootPackage rootPackage,
  DiPackage diPackage,
  DomainPackage defaultDomainPackage,
  InfrastructurePackage defaultInfrastructurePackage,
  LoggingPackage loggingPackage,
  UiPackage uiPackage,
  RapidProject project,
) setupProject() {
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
    rootPackage,
    diPackage,
    defaultDomainPackage,
    defaultInfrastructurePackage,
    loggingPackage,
    uiPackage,
    project,
  );
}

(
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
) setupProjectWithPlatform<T extends PlatformRootPackage>() {
  final (
    rootPackage,
    diPackage,
    defaultDomainPackage,
    defaultInfrastructurePackage,
    loggingPackage,
    uiPackage,
    _,
  ) = setupProject();
  final T platformRootPackage = switch (T) {
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
    rootPackage,
    diPackage,
    defaultDomainPackage,
    defaultInfrastructurePackage,
    loggingPackage,
    uiPackage,
    platformRootPackage,
    platformLocalizationPackage,
    platformNavigationPackage,
    platformAppFeaturePackage,
    platformHomePageFeaturePackage,
    platformUiPackage,
    project,
  );
}

void verifyCreateProjectAndActivatePlatform(
  Platform platform, {
  required ProcessManager manager,
  required RootPackage rootPackage,
  required DiPackage diPackage,
  required DomainPackage defaultDomainPackage,
  required InfrastructurePackage defaultInfrastructurePackage,
  required LoggingPackage loggingPackage,
  required UiPackage uiPackage,
  required PlatformRootPackage platformRootPackage,
  required PlatformLocalizationPackage platformLocalizationPackage,
  required PlatformNavigationPackage platformNavigationPackage,
  required PlatformAppFeaturePackage platformAppFeaturePackage,
  required PlatformPageFeaturePackage platformHomePageFeaturePackage,
  required PlatformUiPackage platformUiPackage,
  required RapidProject project,
  required MockRapidProjectBuilder projectBuilder,
  required Progress progress,
  required GroupableProgress groupableProgress,
  required ProgressGroup progressGroup,
  required RapidLogger logger,
}) {
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
    () => progress.complete(),
    () => logger.progressGroup(null),
    () => progressGroup.progress('Running "flutter pub get" in root_package'),
    () => manager.runFlutterPubGet(workingDirectory: 'root_package_path'),
    () => groupableProgress.complete(),
    () => progressGroup.progress('Running "flutter pub get" in di_package'),
    () => manager.runFlutterPubGet(workingDirectory: 'di_package_path'),
    () => groupableProgress.complete(),
    () => progressGroup.progress('Running "flutter pub get" in domain_package'),
    () => manager.runFlutterPubGet(workingDirectory: 'domain_package_path'),
    () => groupableProgress.complete(),
    () => progressGroup
        .progress('Running "flutter pub get" in infrastructure_package'),
    () => manager.runFlutterPubGet(
        workingDirectory: 'infrastructure_package_path'),
    () => groupableProgress.complete(),
    () =>
        progressGroup.progress('Running "flutter pub get" in logging_package'),
    () => manager.runFlutterPubGet(workingDirectory: 'logging_package_path'),
    () => groupableProgress.complete(),
    () => progressGroup.progress('Running "flutter pub get" in ui_package'),
    () => manager.runFlutterPubGet(workingDirectory: 'ui_package_path'),
    () => groupableProgress.complete(),
    () => logger.newLine(),
    () => logger.log('🚀 Activating ${platform.prettyName}'),
    () => logger.progress('Generating ${platform.prettyName} packages'),
    () => platformAppFeaturePackage.generate(),
    () => platformHomePageFeaturePackage.generate(),
    () => platformLocalizationPackage.generate(
          defaultLanguage: Language(languageCode: 'fr'),
        ),
    () => platformNavigationPackage.generate(),
    switch (platform) {
      Platform.android => () =>
          (platformRootPackage as NoneIosRootPackage).generate(
            orgName: 'test.example',
            description: 'Some desc.',
          ),
      Platform.ios => () => (platformRootPackage as IosRootPackage).generate(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
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
            language: Language(languageCode: 'fr'),
          ),
    },
    () => platformUiPackage.generate(),
    () => progress.complete(),
    () => logger.progressGroup(null),
    () => progressGroup
        .progress('Running "flutter pub get" in platform_app_feature_package'),
    () => manager.runFlutterPubGet(
        workingDirectory: 'platform_app_feature_package_path'),
    () => groupableProgress.complete(),
    () => progressGroup.progress(
        'Running "flutter pub get" in platform_home_page_feature_package'),
    () => manager.runFlutterPubGet(
        workingDirectory: 'platform_home_page_feature_package_path'),
    () => groupableProgress.complete(),
    () => progressGroup
        .progress('Running "flutter pub get" in platform_localization_package'),
    () => manager.runFlutterPubGet(
        workingDirectory: 'platform_localization_package_path'),
    () => groupableProgress.complete(),
    () => progressGroup
        .progress('Running "flutter pub get" in platform_navigation_package'),
    () => manager.runFlutterPubGet(
        workingDirectory: 'platform_navigation_package_path'),
    () => groupableProgress.complete(),
    () => progressGroup
        .progress('Running "flutter pub get" in platform_root_package'),
    () => manager.runFlutterPubGet(
        workingDirectory: 'platform_root_package_path'),
    () => groupableProgress.complete(),
    () => progressGroup
        .progress('Running "flutter pub get" in platform_ui_package'),
    () =>
        manager.runFlutterPubGet(workingDirectory: 'platform_ui_package_path'),
    () => groupableProgress.complete(),
    () => logger.progress(
        'Running "flutter gen-l10n" in platform_localization_package'),
    () => manager.runFlutterGenl10n(
        workingDirectory: 'platform_localization_package_path'),
    () => progress.complete(),
    ...switch (platform) {
      Platform.android => [
          () => logger.progress('Running "flutter config --enable-android"'),
          () => manager.runFlutterConfigEnablePlatform(platform),
          () => progress.complete(),
        ],
      Platform.ios => [
          () => logger.progress('Running "flutter config --enable-ios"'),
          () => manager.runFlutterConfigEnablePlatform(platform),
          () => progress.complete(),
        ],
      Platform.linux => [
          () => logger
              .progress('Running "flutter config --enable-linux-desktop"'),
          () => manager.runFlutterConfigEnablePlatform(platform),
          () => progress.complete(),
        ],
      Platform.macos => [
          () => logger
              .progress('Running "flutter config --enable-macos-desktop"'),
          () => manager.runFlutterConfigEnablePlatform(platform),
          () => progress.complete(),
        ],
      Platform.web => [
          () => logger.progress('Running "flutter config --enable-web"'),
          () => manager.runFlutterConfigEnablePlatform(platform),
          () => progress.complete(),
        ],
      Platform.windows => [
          () => logger
              .progress('Running "flutter config --enable-windows-desktop"'),
          () => manager.runFlutterConfigEnablePlatform(platform),
          () => progress.complete(),
        ],
      Platform.mobile => [
          () => logger.progress('Running "flutter config --enable-android"'),
          () => manager.runFlutterConfigEnablePlatform(Platform.android),
          () => progress.complete(),
          () => logger.progress('Running "flutter config --enable-ios"'),
          () => manager.runFlutterConfigEnablePlatform(Platform.ios),
          () => progress.complete(),
        ],
    },
    () => logger.newLine(),
    () => logger.progress('Running "dart format . --fix" in project'),
    () => manager.runDartFormatFix(workingDirectory: 'root_package_path'),
    () => progress.complete(),
    () => logger.newLine(),
    () => logger.commandSuccess('Created Project!'),
  ]);
  verifyNoMoreInteractions(manager);
  verifyNoMoreInteractions(logger);
  verifyNoMoreInteractions(progress);
  verifyNoMoreInteractions(progressGroup);
  verifyNoMoreInteractions(groupableProgress);
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
        File(p.join(outputDir, 'foo')).createSync(recursive: true);
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
      }),
    );

    test(
      'creates project and activates no platforms',
      withMockEnv((manager) async {
        final (
          rootPackage,
          diPackage,
          defaultDomainPackage,
          defaultInfrastructurePackage,
          loggingPackage,
          uiPackage,
          project,
        ) = setupProject();
        final projectBuilder = MockRapidProjectBuilder(project: project);
        final (_, groupableProgress, progressGroup, logger) = setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
          platforms: {},
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
          () => logger.progressGroup(null),
          () => progressGroup
              .progress('Running "flutter pub get" in root_package'),
          () => manager.runFlutterPubGet(workingDirectory: 'root_package_path'),
          () => groupableProgress.complete(),
          () =>
              progressGroup.progress('Running "flutter pub get" in di_package'),
          () => manager.runFlutterPubGet(workingDirectory: 'di_package_path'),
          () => groupableProgress.complete(),
          () => progressGroup
              .progress('Running "flutter pub get" in domain_package'),
          () =>
              manager.runFlutterPubGet(workingDirectory: 'domain_package_path'),
          () => groupableProgress.complete(),
          () => progressGroup
              .progress('Running "flutter pub get" in infrastructure_package'),
          () => manager.runFlutterPubGet(
              workingDirectory: 'infrastructure_package_path'),
          () => groupableProgress.complete(),
          () => progressGroup
              .progress('Running "flutter pub get" in logging_package'),
          () => manager.runFlutterPubGet(
              workingDirectory: 'logging_package_path'),
          () => groupableProgress.complete(),
          () =>
              progressGroup.progress('Running "flutter pub get" in ui_package'),
          () => manager.runFlutterPubGet(workingDirectory: 'ui_package_path'),
          () => groupableProgress.complete(),
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
      withMockEnv((manager) async {
        final (
          rootPackage,
          diPackage,
          defaultDomainPackage,
          defaultInfrastructurePackage,
          loggingPackage,
          uiPackage,
          platformRootPackage,
          platformLocalizationPackage,
          platformNavigationPackage,
          platformAppFeaturePackage,
          platformHomePageFeaturePackage,
          platformUiPackage,
          project,
        ) = setupProjectWithPlatform<NoneIosRootPackage>();
        final projectBuilder = MockRapidProjectBuilder(project: project);
        final (progress, groupableProgress, progressGroup, logger) =
            setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
          platforms: {Platform.android},
        );

        verifyCreateProjectAndActivatePlatform(
          Platform.android,
          manager: manager,
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
          projectBuilder: projectBuilder,
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        );
      }),
    );

    test(
      'creates project and activates iOS',
      withMockEnv((manager) async {
        final (
          rootPackage,
          diPackage,
          defaultDomainPackage,
          defaultInfrastructurePackage,
          loggingPackage,
          uiPackage,
          platformRootPackage,
          platformLocalizationPackage,
          platformNavigationPackage,
          platformAppFeaturePackage,
          platformHomePageFeaturePackage,
          platformUiPackage,
          project,
        ) = setupProjectWithPlatform<IosRootPackage>();
        final projectBuilder = MockRapidProjectBuilder(project: project);
        final (progress, groupableProgress, progressGroup, logger) =
            setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
          platforms: {Platform.ios},
        );

        verifyCreateProjectAndActivatePlatform(
          Platform.ios,
          manager: manager,
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
          projectBuilder: projectBuilder,
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        );
      }),
    );

    test(
      'creates project and activates Linux',
      withMockEnv((manager) async {
        final (
          rootPackage,
          diPackage,
          defaultDomainPackage,
          defaultInfrastructurePackage,
          loggingPackage,
          uiPackage,
          platformRootPackage,
          platformLocalizationPackage,
          platformNavigationPackage,
          platformAppFeaturePackage,
          platformHomePageFeaturePackage,
          platformUiPackage,
          project,
        ) = setupProjectWithPlatform<NoneIosRootPackage>();
        final projectBuilder = MockRapidProjectBuilder(project: project);
        final (progress, groupableProgress, progressGroup, logger) =
            setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
          platforms: {Platform.linux},
        );

        verifyCreateProjectAndActivatePlatform(
          Platform.linux,
          manager: manager,
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
          projectBuilder: projectBuilder,
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        );
      }),
    );

    test(
      'creates project and activates macOS',
      withMockEnv((manager) async {
        final (
          rootPackage,
          diPackage,
          defaultDomainPackage,
          defaultInfrastructurePackage,
          loggingPackage,
          uiPackage,
          platformRootPackage,
          platformLocalizationPackage,
          platformNavigationPackage,
          platformAppFeaturePackage,
          platformHomePageFeaturePackage,
          platformUiPackage,
          project,
        ) = setupProjectWithPlatform<MacosRootPackage>();
        final projectBuilder = MockRapidProjectBuilder(project: project);
        final (progress, groupableProgress, progressGroup, logger) =
            setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
          platforms: {Platform.macos},
        );

        verifyCreateProjectAndActivatePlatform(
          Platform.macos,
          manager: manager,
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
          projectBuilder: projectBuilder,
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        );
      }),
    );

    test(
      'creates project and activates Web',
      withMockEnv((manager) async {
        final (
          rootPackage,
          diPackage,
          defaultDomainPackage,
          defaultInfrastructurePackage,
          loggingPackage,
          uiPackage,
          platformRootPackage,
          platformLocalizationPackage,
          platformNavigationPackage,
          platformAppFeaturePackage,
          platformHomePageFeaturePackage,
          platformUiPackage,
          project,
        ) = setupProjectWithPlatform<NoneIosRootPackage>();
        final projectBuilder = MockRapidProjectBuilder(project: project);
        final (progress, groupableProgress, progressGroup, logger) =
            setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
          platforms: {Platform.web},
        );

        verifyCreateProjectAndActivatePlatform(
          Platform.web,
          manager: manager,
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
          projectBuilder: projectBuilder,
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        );
      }),
    );

    test(
      'creates project and activates Windows',
      withMockEnv((manager) async {
        final (
          rootPackage,
          diPackage,
          defaultDomainPackage,
          defaultInfrastructurePackage,
          loggingPackage,
          uiPackage,
          platformRootPackage,
          platformLocalizationPackage,
          platformNavigationPackage,
          platformAppFeaturePackage,
          platformHomePageFeaturePackage,
          platformUiPackage,
          project,
        ) = setupProjectWithPlatform<NoneIosRootPackage>();
        final projectBuilder = MockRapidProjectBuilder(project: project);
        final (progress, groupableProgress, progressGroup, logger) =
            setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
          platforms: {Platform.windows},
        );

        verifyCreateProjectAndActivatePlatform(
          Platform.windows,
          manager: manager,
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
          projectBuilder: projectBuilder,
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        );
      }),
    );

    test(
      'creates project and activates Mobile',
      withMockEnv((manager) async {
        final (
          rootPackage,
          diPackage,
          defaultDomainPackage,
          defaultInfrastructurePackage,
          loggingPackage,
          uiPackage,
          platformRootPackage,
          platformLocalizationPackage,
          platformNavigationPackage,
          platformAppFeaturePackage,
          platformHomePageFeaturePackage,
          platformUiPackage,
          project,
        ) = setupProjectWithPlatform<MobileRootPackage>();
        final projectBuilder = MockRapidProjectBuilder(project: project);
        final (progress, groupableProgress, progressGroup, logger) =
            setupLogger();
        final rapid = _getRapid(
          projectBuilder: projectBuilder,
          logger: logger,
        );

        await rapid.create(
          projectName: 'test_app',
          outputDir: 'some/path',
          description: 'Some desc.',
          orgName: 'test.example',
          language: Language(languageCode: 'fr'),
          platforms: {Platform.mobile},
        );

        verifyCreateProjectAndActivatePlatform(
          Platform.mobile,
          manager: manager,
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
          projectBuilder: projectBuilder,
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        );
      }),
    );

    // TODO: case for all platforms
  });
}
