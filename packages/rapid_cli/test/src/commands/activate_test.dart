import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/process.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/tool.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

// TODO refactor using global setup and share some logic with create

typedef _RapidToolSetup = ({
  CommandGroup commandGroup,
  RapidTool tool,
});

typedef _ProjectSetup<T extends PlatformRootPackage> = ({
  InfrastructurePackage nonDefaultInfrastructurePackage,
  T platformRootPackage,
  PlatformLocalizationPackage platformLocalizationPackage,
  PlatformNavigationPackage platformNavigationPackage,
  PlatformAppFeaturePackage platformAppFeaturePackage,
  PlatformPageFeaturePackage platformHomePageFeaturePackage,
  PlatformUiPackage platformUiPackage,
  RapidProject project,
});

_RapidToolSetup _setupTool() {
  final commandGroup = MockCommandGroup();
  when(() => commandGroup.isActive).thenReturn(false);
  final tool = MockRapidTool();
  when(() => tool.loadGroup()).thenReturn(commandGroup);

  return (commandGroup: commandGroup, tool: tool);
}

_ProjectSetup<T> _setupProjectWithPlatform<T extends PlatformRootPackage>() {
  final nonDefaultInfrastructurePackage = MockInfrastructurePackage(
    packageName: 'non_default_infrastructure_package',
    path: 'non_default_infrastructure_package_path',
    isDefault: false,
  );
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
    path: 'project_path',
    appModule: MockAppModule(
      infrastructureDirectory: MockInfrastructureDirectory(
        infrastructurePackages: [
          MockInfrastructurePackage(isDefault: true),
          nonDefaultInfrastructurePackage,
        ],
      ),
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
      platformUiPackage: ({required platform}) => platformUiPackage,
    ),
  );

  return (
    nonDefaultInfrastructurePackage: nonDefaultInfrastructurePackage,
    platformRootPackage: platformRootPackage,
    platformLocalizationPackage: platformLocalizationPackage,
    platformNavigationPackage: platformNavigationPackage,
    platformAppFeaturePackage: platformAppFeaturePackage,
    platformHomePageFeaturePackage: platformHomePageFeaturePackage,
    platformUiPackage: platformUiPackage,
    project: project,
  );
}

void _verifyActivatePlatform<T extends PlatformRootPackage>(
  Platform platform, {
  required ProcessManager manager,
  required _ProjectSetup<T> projectSetup,
  required _RapidToolSetup toolSetup,
  required LoggerSetup loggerSetup,
  bool commandGroupIsActive = false,
}) {
  final (
    nonDefaultInfrastructurePackage: nonDefaultInfrastructurePackage,
    platformRootPackage: platformRootPackage,
    platformLocalizationPackage: platformLocalizationPackage,
    platformNavigationPackage: platformNavigationPackage,
    platformAppFeaturePackage: platformAppFeaturePackage,
    platformHomePageFeaturePackage: platformHomePageFeaturePackage,
    platformUiPackage: platformUiPackage,
    project: _,
  ) = projectSetup;
  final (commandGroup: _, tool: tool) = toolSetup;
  final (
    progress: progress,
    groupableProgress: groupableProgress,
    progressGroup: progressGroup,
    logger: logger,
  ) = loggerSetup;

  verifyInOrder([
    () => logger.newLine(),
    () => logger.info('🚀 Activating ${platform.prettyName}'),
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
    () => platformRootPackage
        .registerInfrastructurePackage(nonDefaultInfrastructurePackage),
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
    ...switch (commandGroupIsActive) {
      true => [
          () => tool.markAsNeedCodeGen(package: platformRootPackage),
        ],
      false => [
          () => logger
              .progress('Running code generation in platform_root_package'),
          () =>
              manager.runFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'platform_root_package_path',
              ),
          () => progress.complete(),
        ],
    },
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
    () => manager.runDartFormatFix(workingDirectory: 'project_path'),
    () => progress.complete(),
    () => logger.newLine(),
    () => logger.commandSuccess('Activated ${platform.prettyName}!'),
  ]);
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('activateAndroid', () {
    test(
      'throws PlatformAlreadyActivatedException when Android is already activated',
      () async {
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.android))
            .thenReturn(true);
        final rapid = getRapid(project: project);

        expect(
          () async => rapid.activateAndroid(
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'activates Android',
      withMockEnv(
        (manager) async {
          final projectSetup = _setupProjectWithPlatform<NoneIosRootPackage>();
          final toolSetup = _setupTool();
          final loggerSetup = setupLogger();
          final rapid = getRapid(
            project: projectSetup.project,
            tool: toolSetup.tool,
            logger: loggerSetup.logger,
          );

          await rapid.activateAndroid(
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          );

          _verifyActivatePlatform(
            Platform.android,
            manager: manager,
            projectSetup: projectSetup,
            toolSetup: toolSetup,
            loggerSetup: loggerSetup,
          );
        },
      ),
    );
  });

  group('activateIos', () {
    test(
      'throws PlatformAlreadyActivatedException when iOS is already activated',
      () async {
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.ios)).thenReturn(true);
        final rapid = getRapid(project: project);

        expect(
          () async => rapid.activateIos(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'activates iOS',
      withMockEnv(
        (manager) async {
          final projectSetup = _setupProjectWithPlatform<IosRootPackage>();
          final toolSetup = _setupTool();
          final loggerSetup = setupLogger();
          final rapid = getRapid(
            project: projectSetup.project,
            tool: toolSetup.tool,
            logger: loggerSetup.logger,
          );

          await rapid.activateIos(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          );

          _verifyActivatePlatform(
            Platform.ios,
            manager: manager,
            projectSetup: projectSetup,
            toolSetup: toolSetup,
            loggerSetup: loggerSetup,
          );
        },
      ),
    );
  });

  group('activateLinux', () {
    test(
      'throws PlatformAlreadyActivatedException when Linux is already activated',
      () async {
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.linux))
            .thenReturn(true);
        final rapid = getRapid(project: project);

        expect(
          () async => rapid.activateLinux(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'activates Linux',
      withMockEnv(
        (manager) async {
          final projectSetup = _setupProjectWithPlatform<NoneIosRootPackage>();
          final toolSetup = _setupTool();
          final loggerSetup = setupLogger();
          final rapid = getRapid(
            project: projectSetup.project,
            tool: toolSetup.tool,
            logger: loggerSetup.logger,
          );

          await rapid.activateLinux(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          );

          _verifyActivatePlatform(
            Platform.linux,
            manager: manager,
            projectSetup: projectSetup,
            toolSetup: toolSetup,
            loggerSetup: loggerSetup,
          );
        },
      ),
    );
  });

  group('activateMacos', () {
    test(
      'throws PlatformAlreadyActivatedException when macOS is already activated',
      () async {
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.macos))
            .thenReturn(true);
        final rapid = getRapid(project: project);

        expect(
          () async => rapid.activateMacos(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'activates macOS',
      withMockEnv(
        (manager) async {
          final projectSetup = _setupProjectWithPlatform<MacosRootPackage>();
          final toolSetup = _setupTool();
          final loggerSetup = setupLogger();
          final rapid = getRapid(
            project: projectSetup.project,
            tool: toolSetup.tool,
            logger: loggerSetup.logger,
          );

          await rapid.activateMacos(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          );

          _verifyActivatePlatform(
            Platform.macos,
            manager: manager,
            projectSetup: projectSetup,
            toolSetup: toolSetup,
            loggerSetup: loggerSetup,
          );
        },
      ),
    );
  });

  group('activateWeb', () {
    test(
      'throws PlatformAlreadyActivatedException when Web is already activated',
      () async {
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.web)).thenReturn(true);
        final rapid = getRapid(project: project);

        expect(
          () async => rapid.activateWeb(
            description: 'Some desc.',
            language: Language(languageCode: 'fr'),
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'activates Web',
      withMockEnv(
        (manager) async {
          final projectSetup = _setupProjectWithPlatform<NoneIosRootPackage>();
          final toolSetup = _setupTool();
          final loggerSetup = setupLogger();
          final rapid = getRapid(
            project: projectSetup.project,
            tool: toolSetup.tool,
            logger: loggerSetup.logger,
          );

          await rapid.activateWeb(
            description: 'Some desc.',
            language: Language(languageCode: 'fr'),
          );

          _verifyActivatePlatform(
            Platform.web,
            manager: manager,
            projectSetup: projectSetup,
            toolSetup: toolSetup,
            loggerSetup: loggerSetup,
          );
        },
      ),
    );
  });

  group('activateWindows', () {
    test(
      'throws PlatformAlreadyActivatedException when Windows is already activated',
      () async {
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.windows))
            .thenReturn(true);
        final rapid = getRapid(project: project);

        expect(
          () async => rapid.activateWindows(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'activates Windows',
      withMockEnv(
        (manager) async {
          final projectSetup = _setupProjectWithPlatform<NoneIosRootPackage>();
          final toolSetup = _setupTool();
          final loggerSetup = setupLogger();
          final rapid = getRapid(
            project: projectSetup.project,
            tool: toolSetup.tool,
            logger: loggerSetup.logger,
          );

          await rapid.activateWindows(
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          );

          _verifyActivatePlatform(
            Platform.windows,
            manager: manager,
            projectSetup: projectSetup,
            toolSetup: toolSetup,
            loggerSetup: loggerSetup,
          );
        },
      ),
    );
  });

  group('activateMobile', () {
    test(
      'throws PlatformAlreadyActivatedException when Mobile is already activated',
      () async {
        final project = MockRapidProject();
        when(() => project.platformIsActivated(Platform.mobile))
            .thenReturn(true);
        final rapid = getRapid(project: project);

        expect(
          () async => rapid.activateMobile(
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          ),
          throwsA(isA<PlatformAlreadyActivatedException>()),
        );
      },
    );

    test(
      'activates Mobile',
      withMockEnv(
        (manager) async {
          final projectSetup = _setupProjectWithPlatform<MobileRootPackage>();
          final toolSetup = _setupTool();
          final loggerSetup = setupLogger();
          final rapid = getRapid(
            project: projectSetup.project,
            tool: toolSetup.tool,
            logger: loggerSetup.logger,
          );

          await rapid.activateMobile(
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
          );

          _verifyActivatePlatform(
            Platform.mobile,
            manager: manager,
            projectSetup: projectSetup,
            toolSetup: toolSetup,
            loggerSetup: loggerSetup,
          );
        },
      ),
    );
  });
}
