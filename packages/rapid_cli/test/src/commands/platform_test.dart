import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io/io.dart' hide Platform;
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/tool.dart';
import 'package:test/test.dart';

import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

// TODO(jtdLab): is it good to use global setup instead of setup fcts with records

void main() {
  late Platform platform; // TODO(jtdLab): better test all platforms
  late Bloc bloc;
  late BlocBuilder blocBuilder;
  late Cubit cubit;
  late CubitBuilder cubitBuilder;
  late DartFile platformFeaturePackageApplicationBarrelFile;
  late Directory platformFeaturePackageApplicationDir;
  late DartFile platformFeaturePackageBarrelFile;
  late PlatformFeaturePackage platformFeaturePackage;
  late PlatformFeaturePackageBuilder platformFeaturePackageBuilder;
  late PlatformFeaturesDirectory platformFeaturesDirectory;
  late PlatformLocalizationPackage platformLocalizationPackage;
  late NavigatorInterface navigatorInterface;
  late NavigatorInterfaceBuilder navigatorInterfaceBuilder;
  late DartFile platformNavigationPackageBarrelFile;
  late PlatformNavigationPackage platformNavigationPackage;
  late PlatformDirectory platformDirectory;
  late RapidProject project;
  late CommandGroup commandGroup;
  late RapidTool tool;

  setUpAll(registerFallbackValues);

  setUp(() {
    platform = randomPlatform();
    bloc = MockBloc();
    when(() => bloc.existsAny).thenReturn(false);
    blocBuilder = MockBlocBuilder();
    when(() => blocBuilder(name: any(named: 'name'))).thenReturn(bloc);
    cubit = MockCubit();
    when(() => cubit.existsAny).thenReturn(false);
    cubitBuilder = MockCubitBuilder();
    when(() => cubitBuilder(name: any(named: 'name'))).thenReturn(cubit);
    platformFeaturePackageApplicationBarrelFile =
        MockDartFile(existsSync: true);
    platformFeaturePackageApplicationDir = MockDirectory(existsSync: true);
    when(() => platformFeaturePackageApplicationDir.listSync()).thenReturn([
      FakeDartFile(),
    ]);
    when(() => platformFeaturePackageApplicationBarrelFile.containsStatements())
        .thenReturn(true);
    platformFeaturePackageBarrelFile = MockDartFile(existsSync: true);
    platformFeaturePackage = MockPlatformPageFeaturePackage(
      packageName: 'cool_page',
      path: 'cool_page_path',
    );
    when(() => platformFeaturePackage.existsSync()).thenReturn(true);
    when(() => platformFeaturePackage.bloc).thenReturn(blocBuilder.call);
    when(() => platformFeaturePackage.cubit).thenReturn(cubitBuilder.call);
    when(() => platformFeaturePackage.applicationBarrelFile)
        .thenReturn(platformFeaturePackageApplicationBarrelFile);
    when(() => platformFeaturePackage.applicationDir)
        .thenReturn(platformFeaturePackageApplicationDir);
    when(() => platformFeaturePackage.barrelFile)
        .thenReturn(platformFeaturePackageBarrelFile);
    platformFeaturePackageBuilder = MockPlatformFeaturePackageBuilder();
    when(
      () => platformFeaturePackageBuilder(name: any(named: 'name')),
    ).thenReturn(platformFeaturePackage);
    platformFeaturesDirectory = MockPlatformFeaturesDirectory(
      featurePackage: platformFeaturePackageBuilder.call,
    );
    platformLocalizationPackage = MockPlatformLocalizationPackage(
      packageName: 'platform_localization_package',
      path: 'platform_localization_package_path',
    );
    when(() => platformLocalizationPackage.supportedLanguages()).thenReturn({
      const Language(languageCode: 'en'),
      const Language(languageCode: 'fr'),
    });
    when(() => platformLocalizationPackage.defaultLanguage())
        .thenReturn(const Language(languageCode: 'en'));
    navigatorInterface = MockNavigatorInterface();
    when(() => navigatorInterface.existsAny).thenReturn(false);
    navigatorInterfaceBuilder = MockNavigatorInterfaceBuilder();
    when(() => navigatorInterfaceBuilder(name: any(named: 'name')))
        .thenReturn(navigatorInterface);
    platformNavigationPackageBarrelFile = MockDartFile();
    platformNavigationPackage = MockPlatformNavigationPackage(
      navigatorInterface: navigatorInterfaceBuilder.call,
      barrelFile: platformNavigationPackageBarrelFile,
    );
    platformDirectory = MockPlatformDirectory(
      localizationPackage: platformLocalizationPackage,
      featuresDirectory: platformFeaturesDirectory,
      navigationPackage: platformNavigationPackage,
    );
    project = MockRapidProject(
      path: 'project_path',
      appModule: MockAppModule(
        platformDirectory: ({required platform}) => platformDirectory,
      ),
    );
    when(() => project.platformIsActivated(any())).thenReturn(true);
    commandGroup = MockCommandGroup();
    when(() => commandGroup.isActive).thenReturn(false);
    tool = MockRapidTool();
    when(() => tool.loadGroup()).thenReturn(commandGroup);
  });

  group('platformAddFeatureFlow', () {
    late NavigatorImplementation navigatorImplementation;
    late PlatformFlowFeaturePackage platformFeaturePackage;
    late NoneIosRootPackage platformRootPackage;

    setUp(() {
      navigatorImplementation = MockNavigatorImplementation();
      when(() => navigatorImplementation.existsAny).thenReturn(false);
      platformFeaturePackage = MockPlatformFlowFeaturePackage(
        name: 'cool_flow',
        packageName: 'cool_flow',
        path: 'cool_flow_path',
        navigatorImplementation: navigatorImplementation,
      );
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      when(
        () => platformFeaturePackageBuilder.call<PlatformFlowFeaturePackage>(
          name: 'cool_flow',
        ),
      ).thenReturn(platformFeaturePackage);
      platformRootPackage = MockNoneIosRootPackage(
        packageName: 'none_ios_root_package',
        path: 'none_ios_root_package_path',
      );
      when(() => platformDirectory.rootPackage).thenReturn(platformRootPackage);
    });

    test(
        'throws PlatformNotActivatedException when the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureFlow(
          platform,
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
      when(() => platformFeaturePackage.existsSync()).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureFlow(
          platform,
          name: 'cool',
          description: 'Cool flow.',
          navigator: true,
        ),
        throwsA(isA<FeatureAlreadyExistsException>()),
      );
    });

    test(
      'adds a new flow feature to the platform',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformAddFeatureFlow(
          platform,
          name: 'cool',
          description: 'Cool flow.',
          navigator: false,
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating feature'),
          () => platformFeaturePackage.generate(description: 'Cool flow.'),
          () => platformRootPackage
              .registerFeaturePackage(platformFeaturePackage),
          progress.complete,
          () => logger.progress(
                'Running "melos bootstrap --scope none_ios_root_package,cool_flow"',
              ),
          () => manager.runMelosBootstrap(
                ['none_ios_root_package', 'cool_flow'],
                workingDirectory: 'project_path',
              ),
          progress.complete,
          () => logger
              .progress('Running code generation in none_ios_root_package'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'none_ios_root_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Flow Feature!'),
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'adds a navigator implementation to the flow feature when navigator is true',
      withMockEnv((manager) async {
        final (
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        ) = setupLogger();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformAddFeatureFlow(
          platform,
          name: 'cool',
          description: 'Cool flow.',
          navigator: true,
        );

        verifyInOrder([
          () => logger.progress('Creating navigator implementation'),
          () => navigatorImplementation.generate(),
          progress.complete,
          logger.progressGroup,
          () => progressGroup
              .progress('Running code generation in none_ios_root_package'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'none_ios_root_package_path',
              ),
          groupableProgress.complete,
          () => progressGroup.progress('Running code generation in cool_flow'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'cool_flow_path',
              ),
          groupableProgress.complete,
        ]);
      }),
    );

    test(
      'adds a navigator interface to the platform navigation package when navigator is true',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformAddFeatureFlow(
          platform,
          name: 'cool',
          description: 'Cool flow.',
          navigator: true,
        );

        verifyInOrder([
          () => logger.progress('Creating navigator interface'),
          () => navigatorInterface.generate(),
          () => platformNavigationPackageBarrelFile
              .addExport('src/i_cool_flow_navigator.dart'),
          progress.complete,
        ]);
      }),
    );
  });

  group('platformAddFeatureTabFlow', () {
    late NavigatorImplementation navigatorImplementation;
    late PlatformTabFlowFeaturePackage platformFeaturePackage;
    late NoneIosRootPackage platformRootPackage;

    setUp(() {
      navigatorImplementation = MockNavigatorImplementation();
      when(() => navigatorImplementation.existsAny).thenReturn(false);
      platformFeaturePackage = MockPlatformTabFlowFeaturePackage(
        name: 'cool_tab_flow',
        packageName: 'cool_tab_flow',
        path: 'cool_tab_flow_path',
        navigatorImplementation: navigatorImplementation,
      );
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      when(
        () => platformFeaturePackageBuilder.call<PlatformTabFlowFeaturePackage>(
          name: 'cool_tab_flow',
        ),
      ).thenReturn(platformFeaturePackage);
      platformRootPackage = MockNoneIosRootPackage(
        packageName: 'none_ios_root_package',
        path: 'none_ios_root_package_path',
      );
      when(() => platformDirectory.rootPackage).thenReturn(platformRootPackage);
      when(() => platformFeaturesDirectory.featurePackages()).thenReturn([
        FakePlatformPageFeaturePackage(name: 'home_page'),
      ]);
    });

    test(
        'throws PlatformNotActivatedException when the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureTabFlow(
          platform,
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
      when(() => platformFeaturePackage.existsSync()).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureTabFlow(
          platform,
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
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureTabFlow(
          platform,
          name: 'cool',
          description: 'Cool tab flow.',
          navigator: false,
          subFeatures: {'non_existing_page'},
        ),
        throwsA(isA<SubFeaturesNotFoundException>()),
      );
    });

    test(
      'adds a new tab flow feature to the platform',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformAddFeatureTabFlow(
          platform,
          name: 'cool',
          description: 'Cool tab flow.',
          navigator: false,
          subFeatures: {'home_page'},
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating feature'),
          () => platformFeaturePackage.generate(
                description: 'Cool tab flow.',
                subFeatures: {'home_page'},
              ),
          () => platformRootPackage
              .registerFeaturePackage(platformFeaturePackage),
          progress.complete,
          () => logger.progress(
                'Running "melos bootstrap --scope none_ios_root_package,cool_tab_flow"',
              ),
          () => manager.runMelosBootstrap(
                ['none_ios_root_package', 'cool_tab_flow'],
                workingDirectory: 'project_path',
              ),
          progress.complete,
          () => logger
              .progress('Running code generation in none_ios_root_package'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'none_ios_root_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Tab Flow Feature!'),
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'adds a navigator implementation to the tab flow feature when navigator is true',
      withMockEnv((manager) async {
        final (
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        ) = setupLogger();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformAddFeatureTabFlow(
          platform,
          name: 'cool',
          description: 'Cool tab flow.',
          navigator: true,
          subFeatures: {'home_page'},
        );

        verifyInOrder([
          () => logger.progress('Creating navigator implementation'),
          () => navigatorImplementation.generate(),
          progress.complete,
          logger.progressGroup,
          () => progressGroup
              .progress('Running code generation in none_ios_root_package'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'none_ios_root_package_path',
              ),
          groupableProgress.complete,
          () => progressGroup
              .progress('Running code generation in cool_tab_flow'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'cool_tab_flow_path',
              ),
          groupableProgress.complete,
        ]);
      }),
    );

    test(
      'adds a navigator interface to the platform navigation package when navigator is true',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformAddFeatureTabFlow(
          platform,
          name: 'cool',
          description: 'Cool tab flow.',
          navigator: true,
          subFeatures: {'home_page'},
        );

        verifyInOrder([
          () => logger.progress('Creating navigator interface'),
          () => navigatorInterface.generate(),
          () => platformNavigationPackageBarrelFile
              .addExport('src/i_cool_tab_flow_navigator.dart'),
          progress.complete,
        ]);
      }),
    );
  });

  group('platformAddFeaturePage', () {
    late NavigatorImplementation navigatorImplementation;
    late PlatformPageFeaturePackage platformFeaturePackage;
    late NoneIosRootPackage platformRootPackage;

    setUp(() {
      navigatorImplementation = MockNavigatorImplementation();
      when(() => navigatorImplementation.existsAny).thenReturn(false);
      platformFeaturePackage = MockPlatformPageFeaturePackage(
        name: 'cool_page',
        packageName: 'cool_page',
        path: 'cool_page_path',
        navigatorImplementation: navigatorImplementation,
      );
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      when(
        () => platformFeaturePackageBuilder.call<PlatformPageFeaturePackage>(
          name: 'cool_page',
        ),
      ).thenReturn(platformFeaturePackage);
      platformRootPackage = MockNoneIosRootPackage(
        packageName: 'none_ios_root_package',
        path: 'none_ios_root_package_path',
      );
      when(() => platformDirectory.rootPackage).thenReturn(platformRootPackage);
    });

    test(
        'throws PlatformNotActivatedException when the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeaturePage(
          platform,
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
      when(() => platformFeaturePackage.existsSync()).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeaturePage(
          platform,
          name: 'cool',
          description: 'Cool page.',
          navigator: true,
        ),
        throwsA(isA<FeatureAlreadyExistsException>()),
      );
    });

    test(
      'adds a new page feature to the platform',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformAddFeaturePage(
          platform,
          name: 'cool',
          description: 'Cool page.',
          navigator: false,
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating feature'),
          () => platformFeaturePackage.generate(description: 'Cool page.'),
          () => platformRootPackage
              .registerFeaturePackage(platformFeaturePackage),
          progress.complete,
          () => logger.progress(
                'Running "melos bootstrap --scope none_ios_root_package,cool_page"',
              ),
          () => manager.runMelosBootstrap(
                ['none_ios_root_package', 'cool_page'],
                workingDirectory: 'project_path',
              ),
          progress.complete,
          () => logger
              .progress('Running code generation in none_ios_root_package'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'none_ios_root_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Page Feature!'),
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'adds a navigator implementation to the page feature when navigator is true',
      withMockEnv((manager) async {
        final (
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        ) = setupLogger();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformAddFeaturePage(
          platform,
          name: 'cool',
          description: 'Cool page.',
          navigator: true,
        );

        verifyInOrder([
          () => logger.progress('Creating navigator implementation'),
          () => navigatorImplementation.generate(),
          progress.complete,
          logger.progressGroup,
          () => progressGroup
              .progress('Running code generation in none_ios_root_package'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'none_ios_root_package_path',
              ),
          groupableProgress.complete,
          () => progressGroup.progress('Running code generation in cool_page'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'cool_page_path',
              ),
          groupableProgress.complete,
        ]);
      }),
    );

    test(
      'adds a navigator interface to the platform navigation package when navigator is true',
      withMockEnv((_) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformAddFeaturePage(
          platform,
          name: 'cool',
          description: 'Cool page.',
          navigator: true,
        );

        verifyInOrder([
          () => logger.progress('Creating navigator interface'),
          () => navigatorInterface.generate(),
          () => platformNavigationPackageBarrelFile
              .addExport('src/i_cool_page_navigator.dart'),
          progress.complete,
        ]);
      }),
    );
  });

  group('platformAddFeatureWidget', () {
    late PlatformWidgetFeaturePackage platformFeaturePackage;
    late NoneIosRootPackage platformRootPackage;

    setUp(() {
      platformFeaturePackage = MockPlatformWidgetFeaturePackage(
        packageName: 'cool_widget',
        path: 'cool_widget_path',
      );
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      when(
        () => platformFeaturePackageBuilder.call<PlatformWidgetFeaturePackage>(
          name: 'cool_widget',
        ),
      ).thenReturn(platformFeaturePackage);
      platformRootPackage = MockNoneIosRootPackage(
        packageName: 'none_ios_root_package',
        path: 'none_ios_root_package_path',
      );
      when(() => platformDirectory.rootPackage).thenReturn(platformRootPackage);
    });

    test(
        'throws PlatformNotActivatedException when the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureWidget(
          platform,
          name: 'cool',
          description: 'Cool widget.',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureAlreadyExistsException when feature package already exists',
        () async {
      when(() => platformFeaturePackage.existsSync()).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddFeatureWidget(
          platform,
          name: 'cool',
          description: 'Cool widget.',
        ),
        throwsA(isA<FeatureAlreadyExistsException>()),
      );
    });

    test(
      'adds a new widget feature to the platform',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformAddFeatureWidget(
          platform,
          name: 'cool',
          description: 'Cool widget.',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating feature'),
          () => platformFeaturePackage.generate(description: 'Cool widget.'),
          () => platformRootPackage
              .registerFeaturePackage(platformFeaturePackage),
          progress.complete,
          () => logger.progress(
                'Running "melos bootstrap --scope none_ios_root_package,cool_widget"',
              ),
          () => manager.runMelosBootstrap(
                ['none_ios_root_package', 'cool_widget'],
                workingDirectory: 'project_path',
              ),
          progress.complete,
          () => logger
              .progress('Running code generation in none_ios_root_package'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'none_ios_root_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Widget Feature!'),
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });

  group('platformAddLanguage', () {
    late PlatformRootPackage platformRootPackage;

    setUp(() {
      when(() => platformLocalizationPackage.supportedLanguages()).thenReturn({
        const Language(languageCode: 'en'),
        const Language(languageCode: 'fr'),
        const Language(languageCode: 'de'),
      });
      platformRootPackage = MockNoneIosRootPackage(
        packageName: 'none_ios_root_package',
        path: 'none_ios_root_package_path',
      );
      when(() => platformDirectory.rootPackage).thenReturn(platformRootPackage);
    });

    test('throws LanguageAlreadyPresentException for an existing language',
        () async {
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddLanguage(
          platform,
          language: const Language(languageCode: 'fr'),
        ),
        throwsA(isA<LanguageAlreadyPresentException>()),
      );
    });

    test(
        'throws PlatformNotActivatedException if the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddLanguage(
          platform,
          language: const Language(languageCode: 'en'),
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
      'adds a new language',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.platformAddLanguage(
          platform,
          language: const Language(languageCode: 'es'),
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Adding language'),
          () => platformLocalizationPackage
              .addLanguage(const Language(languageCode: 'es')),
          progress.complete,
          () => logger.progress(
                'Running "flutter gen-l10n" in platform_localization_package',
              ),
          () => manager.runFlutterGenl10n(
                workingDirectory: 'platform_localization_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Language!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'adds language + fallback language',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.platformAddLanguage(
          platform,
          language: const Language(languageCode: 'zh', scriptCode: 'Hans'),
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Adding language'),
          () => platformLocalizationPackage.addLanguage(
                const Language(languageCode: 'zh', scriptCode: 'Hans'),
              ),
          progress.complete,
          () => logger.progress('Adding language'),
          () => platformLocalizationPackage
              .addLanguage(const Language(languageCode: 'zh')),
          progress.complete,
          () => logger.progress(
                'Running "flutter gen-l10n" in platform_localization_package',
              ),
          () => manager.runFlutterGenl10n(
                workingDirectory: 'platform_localization_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Language!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    group('given platform is iOS', () {
      setUp(() {
        platform = Platform.ios;
        platformRootPackage = MockIosRootPackage(
          packageName: 'ios_root_package',
          path: 'ios_root_package_path',
        );
        when(() => platformDirectory.rootPackage)
            .thenReturn(platformRootPackage);
      });

      test(
        'adds a new language to platform root package',
        withMockEnv((manager) async {
          final rapid = getRapid(project: project);

          await rapid.platformAddLanguage(
            platform,
            language: const Language(languageCode: 'zh'),
          );

          verifyInOrder([
            () => (platformRootPackage as IosRootPackage).addLanguage(
                  const Language(languageCode: 'zh'),
                ),
          ]);
        }),
      );

      test(
        'adds language + fallback language to platform root package',
        withMockEnv((manager) async {
          final rapid = getRapid(project: project);

          await rapid.platformAddLanguage(
            platform,
            language: const Language(languageCode: 'zh', scriptCode: 'Hans'),
          );

          verifyInOrder([
            () => (platformRootPackage as IosRootPackage).addLanguage(
                  const Language(languageCode: 'zh', scriptCode: 'Hans'),
                ),
            () => (platformRootPackage as IosRootPackage).addLanguage(
                  const Language(languageCode: 'zh'),
                ),
          ]);
        }),
      );
    });

    group('given platform is Mobile', () {
      setUp(() {
        platform = Platform.mobile;
        platformRootPackage = MockMobileRootPackage(
          packageName: 'mobile_root_package',
          path: 'mobile_root_package_path',
        );
        when(() => platformDirectory.rootPackage)
            .thenReturn(platformRootPackage);
      });

      test(
        'adds a new language to platform root package',
        withMockEnv((manager) async {
          final rapid = getRapid(project: project);

          await rapid.platformAddLanguage(
            platform,
            language: const Language(languageCode: 'zh'),
          );

          verifyInOrder([
            () => (platformRootPackage as MobileRootPackage).addLanguage(
                  const Language(languageCode: 'zh'),
                ),
          ]);
        }),
      );

      test(
        'adds language + fallback language to platform root package',
        withMockEnv((manager) async {
          final rapid = getRapid(project: project);

          await rapid.platformAddLanguage(
            platform,
            language: const Language(languageCode: 'zh', scriptCode: 'Hans'),
          );

          verifyInOrder([
            () => (platformRootPackage as MobileRootPackage).addLanguage(
                  const Language(languageCode: 'zh', scriptCode: 'Hans'),
                ),
            () => (platformRootPackage as MobileRootPackage).addLanguage(
                  const Language(languageCode: 'zh'),
                ),
          ]);
        }),
      );
    });
  });

  group('platformAddNavigator', () {
    late NavigatorImplementation navigatorImplementation;
    late PlatformPageFeaturePackage platformFeaturePackage;

    setUp(() {
      navigatorImplementation = MockNavigatorImplementation();
      when(() => navigatorImplementation.existsAny).thenReturn(false);
      platformFeaturePackage = MockPlatformPageFeaturePackage(
        name: 'cool_page',
        packageName: 'cool_page',
        path: 'cool_page_path',
        existsSync: true,
        navigatorImplementation: navigatorImplementation,
      );
      when(
        () => platformFeaturePackageBuilder(name: any(named: 'name')),
      ).thenReturn(platformFeaturePackage);
    });

    test(
        'throws PlatformNotActivatedException if the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddNavigator(
          platform,
          featureName: 'feature_a',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotRoutableException if feature is not routable',
        () async {
      final platformFeaturePackage =
          MockPlatformWidgetFeaturePackage(name: 'cool_widget');
      when(
        () => platformFeaturePackageBuilder(name: 'cool_widget'),
      ).thenReturn(platformFeaturePackage);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddNavigator(
          platform,
          featureName: 'cool_widget',
        ),
        throwsA(isA<FeatureNotRoutableException>()),
      );
    });

    test('throws FeatureNotFoundException if feature does not exist', () async {
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformAddNavigator(
          platform,
          featureName: 'cool_page',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test(
      'adds a navigator to a routable feature package',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformAddNavigator(
          platform,
          featureName: 'cool_page',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating navigator interface'),
          () => navigatorInterface.generate(),
          () => platformNavigationPackageBarrelFile
              .addExport('src/i_cool_page_navigator.dart'),
          progress.complete,
          () => logger.progress('Creating navigator implementation'),
          () => navigatorImplementation.generate(),
          progress.complete,
          () => logger.progress('Running code generation in cool_page'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'cool_page_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Navigator!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });

  group('platformFeatureAddBloc', () {
    test(
        'throws PlatformNotActivatedException if the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureAddBloc(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException if feature does not exist', () async {
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureAddBloc(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('throws BlocAlreadyExistsException if bloc already exists', () async {
      when(() => bloc.existsAny).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureAddBloc(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<BlocAlreadyExistsException>()),
      );
    });

    test(
      'adds a new bloc to an existing feature package',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();

        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformFeatureAddBloc(
          platform,
          name: 'Cool',
          featureName: 'cool_page',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating bloc'),
          () => bloc.generate(),
          () => platformFeaturePackageApplicationBarrelFile
              .addExport('cool_bloc.dart'),
          progress.complete,
          () => logger.progress('Running code generation in cool_page'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'cool_page_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Bloc!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'handles non existing application barrel file',
      withMockEnv((manager) async {
        when(() => platformFeaturePackageApplicationBarrelFile.existsSync())
            .thenReturn(false);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformFeatureAddBloc(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating bloc'),
          () => bloc.generate(),
          () => platformFeaturePackageApplicationBarrelFile.createSync(
                recursive: true,
              ),
          () => platformFeaturePackageApplicationBarrelFile
              .addExport('cool_bloc.dart'),
          () => platformFeaturePackageBarrelFile
              .addExport('src/application/application.dart'),
          progress.complete,
        ]);
      }),
    );
  });

  group('platformFeatureAddCubit', () {
    test(
        'throws PlatformNotActivatedException if the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureAddCubit(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException if feature does not exist', () async {
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureAddCubit(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('throws CubitAlreadyExistsException if cubit already exists',
        () async {
      when(() => cubit.existsAny).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureAddCubit(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<CubitAlreadyExistsException>()),
      );
    });

    test(
      'adds a new cubit to an existing feature package',
      withMockEnv((manager) async {
        when(() => cubit.existsAny).thenReturn(false);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();

        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformFeatureAddCubit(
          platform,
          name: 'Cool',
          featureName: 'cool_page',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating cubit'),
          () => cubit.generate(),
          () => platformFeaturePackageApplicationBarrelFile
              .addExport('cool_cubit.dart'),
          progress.complete,
          () => logger.progress('Running code generation in cool_page'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'cool_page_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Cubit!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'handles non existing application barrel file',
      withMockEnv((manager) async {
        when(() => platformFeaturePackageApplicationBarrelFile.existsSync())
            .thenReturn(false);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformFeatureAddCubit(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating cubit'),
          () => cubit.generate(),
          () => platformFeaturePackageApplicationBarrelFile.createSync(
                recursive: true,
              ),
          () => platformFeaturePackageApplicationBarrelFile
              .addExport('cool_cubit.dart'),
          () => platformFeaturePackageBarrelFile
              .addExport('src/application/application.dart'),
          progress.complete,
        ]);
      }),
    );
  });

  group('platformFeatureRemoveBloc', () {
    test(
        'throws PlatformNotActivatedException if the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureRemoveBloc(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException if feature does not exist', () async {
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureRemoveBloc(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('throws BlocAlreadyExistsException if bloc does not exist', () async {
      when(() => bloc.existsAny).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureRemoveBloc(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<BlocNotFoundException>()),
      );
    });

    test(
      'removes a bloc from an existing feature package',
      withMockEnv((manager) async {
        when(() => bloc.existsAny).thenReturn(true);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformFeatureRemoveBloc(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Removing bloc'),
          () => bloc.delete(),
          () => platformFeaturePackageApplicationBarrelFile
              .removeExport('cool_bloc.dart'),
          progress.complete,
          () => logger.progress('Running code generation in cool_page'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'cool_page_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Bloc!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'removes application barrel file if it does not contain any code',
      withMockEnv((manager) async {
        when(() => bloc.existsAny).thenReturn(true);
        when(
          () =>
              platformFeaturePackageApplicationBarrelFile.containsStatements(),
        ).thenReturn(false);
        final rapid = getRapid(project: project, tool: tool);

        await rapid.platformFeatureRemoveBloc(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        );

        verifyInOrder([
          () => platformFeaturePackageApplicationBarrelFile.deleteSync(
                recursive: true,
              ),
        ]);
      }),
    );

    test(
      'removes application dir if it is empty',
      withMockEnv((manager) async {
        when(() => bloc.existsAny).thenReturn(true);
        when(
          () =>
              platformFeaturePackageApplicationBarrelFile.containsStatements(),
        ).thenReturn(false);
        when(() => platformFeaturePackageApplicationDir.listSync())
            .thenReturn([]);
        final rapid = getRapid(project: project, tool: tool);

        await rapid.platformFeatureRemoveBloc(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        );

        verifyInOrder([
          () => platformFeaturePackageApplicationDir.deleteSync(
                recursive: true,
              ),
        ]);
      }),
    );
  });

  group('platformFeatureRemoveCubit', () {
    test(
        'throws PlatformNotActivatedException if the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureRemoveCubit(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException if feature does not exist', () async {
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureRemoveCubit(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('throws CubitNotFoundException if cubit does not exists', () async {
      when(() => cubit.existsAny).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformFeatureRemoveCubit(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        ),
        throwsA(isA<CubitNotFoundException>()),
      );
    });

    test(
      'removes a cubit from an existing feature package',
      withMockEnv((manager) async {
        when(() => cubit.existsAny).thenReturn(true);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();

        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformFeatureRemoveCubit(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Removing cubit'),
          () => cubit.delete(),
          () => platformFeaturePackageApplicationBarrelFile
              .removeExport('cool_cubit.dart'),
          progress.complete,
          () => logger.progress('Running code generation in cool_page'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'cool_page_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Cubit!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'removes application barrel file if it does not contain any code',
      withMockEnv((manager) async {
        when(() => cubit.existsAny).thenReturn(true);
        when(
          () =>
              platformFeaturePackageApplicationBarrelFile.containsStatements(),
        ).thenReturn(false);
        final rapid = getRapid(project: project, tool: tool);

        await rapid.platformFeatureRemoveCubit(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        );

        verifyInOrder([
          () => platformFeaturePackageApplicationBarrelFile.deleteSync(
                recursive: true,
              ),
        ]);
      }),
    );

    test(
      'removes application dir if it is empty',
      withMockEnv((manager) async {
        when(() => cubit.existsAny).thenReturn(true);
        when(
          () =>
              platformFeaturePackageApplicationBarrelFile.containsStatements(),
        ).thenReturn(false);
        when(() => platformFeaturePackageApplicationDir.listSync())
            .thenReturn([]);
        final rapid = getRapid(project: project, tool: tool);

        await rapid.platformFeatureRemoveCubit(
          platform,
          name: 'Cool',
          featureName: 'foo_bar',
        );

        verifyInOrder([
          () => platformFeaturePackageApplicationDir.deleteSync(
                recursive: true,
              ),
        ]);
      }),
    );
  });

  group('platformRemoveFeature', () {
    late PubspecYamlFile remainingFeaturePubspecFile;
    late PlatformFeaturePackage remainingPlatformFeaturePackage;
    late NavigatorImplementation navigatorImplementation;
    late PlatformPageFeaturePackage platformFeaturePackage;
    late PlatformRootPackage platformRootPackage;

    setUp(() {
      remainingFeaturePubspecFile = MockPubspecYamlFile();
      when(() => remainingFeaturePubspecFile.hasDependency(name: 'cool_page'))
          .thenReturn(true);
      remainingPlatformFeaturePackage = MockPlatformWidgetFeaturePackage(
        packageName: 'remaining_widget',
        path: 'remaining_widget_path',
        pubSpec: remainingFeaturePubspecFile,
      );
      navigatorImplementation = MockNavigatorImplementation();
      when(() => navigatorImplementation.existsAny).thenReturn(true);
      platformFeaturePackage = MockPlatformPageFeaturePackage(
        name: 'cool_page',
        packageName: 'cool_page',
        path: 'cool_page_path',
        existsSync: true,
        navigatorImplementation: navigatorImplementation,
      );
      when(
        () => platformFeaturePackageBuilder(name: any(named: 'name')),
      ).thenReturn(platformFeaturePackage);
      when(() => platformFeaturesDirectory.featurePackages()).thenReturn([
        platformFeaturePackage,
        remainingPlatformFeaturePackage,
      ]);
      platformRootPackage = MockNoneIosRootPackage(
        packageName: 'none_ios_root_package',
        path: 'none_ios_root_package_path',
      );
      when(() => platformDirectory.rootPackage).thenReturn(platformRootPackage);
    });

    test(
        'throws PlatformNotActivatedException if the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveFeature(
          platform,
          name: 'cool_page',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureNotFoundException when the feature package does not exist',
        () async {
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveFeature(
          platform,
          name: 'cool_page',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test(
      'removes a feature',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformRemoveFeature(
          platform,
          name: 'cool_page',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Deleting feature files'),
          () => platformRootPackage
              .unregisterFeaturePackage(platformFeaturePackage),
          () => remainingFeaturePubspecFile.removeDependency(
                name: 'cool_page',
              ),
          () => platformFeaturePackage.deleteSync(recursive: true),
          progress.complete,
          () => logger.progress(
                'Running "melos bootstrap --scope remaining_widget,none_ios_root_package"',
              ),
          () => manager.runMelosBootstrap(
                ['remaining_widget', 'none_ios_root_package'],
                workingDirectory: 'project_path',
              ),
          progress.complete,
          () => logger
              .progress('Running code generation in none_ios_root_package'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'none_ios_root_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Feature!'),
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'removes associated navigator interface from platform navigation package',
      withMockEnv((manager) async {
        when(() => navigatorInterface.existsAny).thenReturn(true);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();

        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformRemoveFeature(
          platform,
          name: 'cool_widget',
        );

        verifyInOrder([
          () => logger.progress('Deleting navigator interface'),
          () => navigatorInterface.delete(),
          () => platformNavigationPackageBarrelFile
              .removeExport('src/i_cool_page_navigator.dart'),
          progress.complete,
        ]);
      }),
    );
  });

  group('platformRemoveLanguage', () {
    late PlatformRootPackage platformRootPackage;

    setUp(() {
      when(() => platformLocalizationPackage.supportedLanguages()).thenReturn({
        const Language(languageCode: 'en'),
        const Language(languageCode: 'zh'),
        const Language(languageCode: 'zh', scriptCode: 'Hans'),
        const Language(languageCode: 'de'),
      });
      platformRootPackage = MockNoneIosRootPackage(
        packageName: 'none_ios_root_package',
        path: 'none_ios_root_package_path',
      );
      when(() => platformDirectory.rootPackage).thenReturn(platformRootPackage);
    });

    test(
        'throws PlatformNotActivatedException if the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveLanguage(
          platform,
          language: const Language(languageCode: 'en'),
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws LanguageNotFoundException for an unsupported language',
        () async {
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveLanguage(
          platform,
          language: const Language(languageCode: 'es'),
        ),
        throwsA(isA<LanguageNotFoundException>()),
      );
    });

    test('throws CantRemoveDefaultLanguageException for the default language',
        () async {
      when(() => platformLocalizationPackage.defaultLanguage())
          .thenReturn(const Language(languageCode: 'en'));
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveLanguage(
          platform,
          language: const Language(languageCode: 'en'),
        ),
        throwsA(isA<CantRemoveDefaultLanguageException>()),
      );
    });

    test(
      'removes a supported language',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.platformRemoveLanguage(
          platform,
          language: const Language(languageCode: 'zh', scriptCode: 'Hans'),
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Removing language'),
          () => platformLocalizationPackage.removeLanguage(
                const Language(languageCode: 'zh', scriptCode: 'Hans'),
              ),
          progress.complete,
          () => logger.progress(
                'Running "flutter gen-l10n" in platform_localization_package',
              ),
          () => manager.runFlutterGenl10n(
                workingDirectory: 'platform_localization_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Language!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'removes all language with same language code when language is fallback language',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.platformRemoveLanguage(
          platform,
          language: const Language(languageCode: 'zh'),
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Removing language'),
          () => platformLocalizationPackage
              .removeLanguage(const Language(languageCode: 'zh')),
          progress.complete,
          () => logger.progress('Removing language'),
          () => platformLocalizationPackage.removeLanguage(
                const Language(languageCode: 'zh', scriptCode: 'Hans'),
              ),
          progress.complete,
          () => logger.progress(
                'Running "flutter gen-l10n" in platform_localization_package',
              ),
          () => manager.runFlutterGenl10n(
                workingDirectory: 'platform_localization_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Language!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    group('given platform is iOS', () {
      setUp(() {
        platform = Platform.ios;
        platformRootPackage = MockIosRootPackage(
          packageName: 'ios_root_package',
          path: 'ios_root_package_path',
        );
        when(() => platformDirectory.rootPackage)
            .thenReturn(platformRootPackage);
      });

      test(
        'removes a supported language from platform root package',
        withMockEnv((manager) async {
          final rapid = getRapid(project: project);

          await rapid.platformRemoveLanguage(
            platform,
            language: const Language(languageCode: 'zh', scriptCode: 'Hans'),
          );

          verifyInOrder([
            () => (platformRootPackage as IosRootPackage).removeLanguage(
                  const Language(languageCode: 'zh', scriptCode: 'Hans'),
                ),
          ]);
        }),
      );

      test(
        'removes all language with same language code when language is fallback language '
        'from platform root package',
        withMockEnv((manager) async {
          final rapid = getRapid(project: project);

          await rapid.platformRemoveLanguage(
            platform,
            language: const Language(languageCode: 'zh'),
          );

          verifyInOrder([
            () => (platformRootPackage as IosRootPackage).removeLanguage(
                  const Language(languageCode: 'zh'),
                ),
            () => (platformRootPackage as IosRootPackage).removeLanguage(
                  const Language(languageCode: 'zh', scriptCode: 'Hans'),
                ),
          ]);
        }),
      );
    });

    group('given platform is Mobile', () {
      setUp(() {
        platform = Platform.mobile;
        platformRootPackage = MockMobileRootPackage(
          packageName: 'mobile_root_package',
          path: 'mobile_root_package_path',
        );
        when(() => platformDirectory.rootPackage)
            .thenReturn(platformRootPackage);
      });

      test(
        'removes a supported language from platform root package',
        withMockEnv((manager) async {
          final rapid = getRapid(project: project);

          await rapid.platformRemoveLanguage(
            platform,
            language: const Language(languageCode: 'zh', scriptCode: 'Hans'),
          );

          verifyInOrder([
            () => (platformRootPackage as MobileRootPackage).removeLanguage(
                  const Language(languageCode: 'zh', scriptCode: 'Hans'),
                ),
          ]);
        }),
      );

      test(
        'removes all language with same language code when language is fallback language '
        'from platform root package',
        withMockEnv((manager) async {
          final rapid = getRapid(project: project);

          await rapid.platformRemoveLanguage(
            platform,
            language: const Language(languageCode: 'zh'),
          );

          verifyInOrder([
            () => (platformRootPackage as MobileRootPackage).removeLanguage(
                  const Language(languageCode: 'zh'),
                ),
            () => (platformRootPackage as MobileRootPackage).removeLanguage(
                  const Language(languageCode: 'zh', scriptCode: 'Hans'),
                ),
          ]);
        }),
      );
    });
  });

  group('platformRemoveNavigator', () {
    late NavigatorImplementation navigatorImplementation;
    late PlatformPageFeaturePackage platformFeaturePackage;

    setUp(() {
      navigatorImplementation = MockNavigatorImplementation();
      when(() => navigatorImplementation.existsAny).thenReturn(true);
      platformFeaturePackage = MockPlatformPageFeaturePackage(
        name: 'cool_page',
        packageName: 'cool_page',
        path: 'cool_page_path',
        existsSync: true,
        navigatorImplementation: navigatorImplementation,
      );
      when(
        () => platformFeaturePackageBuilder(name: any(named: 'name')),
      ).thenReturn(platformFeaturePackage);
    });

    test(
        'throws PlatformNotActivatedException if the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveNavigator(
          platform,
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
      when(
        () => platformFeaturePackageBuilder(name: 'cool_widget'),
      ).thenReturn(platformFeaturePackage);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveNavigator(
          platform,
          featureName: 'cool_widget',
        ),
        throwsA(isA<FeatureNotRoutableException>()),
      );
    });

    test('throws FeatureNotFoundException if feature does not exist', () async {
      when(() => platformFeaturePackage.existsSync()).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformRemoveNavigator(
          platform,
          featureName: 'non_existing',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test(
      'removes navigator of a routable feature package',
      withMockEnv((manager) async {
        when(() => navigatorInterface.existsAny).thenReturn(true);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.platformRemoveNavigator(
          platform,
          featureName: 'cool_page',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Deleting navigator interface'),
          () => navigatorInterface.delete(),
          () => platformNavigationPackageBarrelFile
              .removeExport('src/i_cool_page_navigator.dart'),
          progress.complete,
          () => logger.progress('Deleting navigator implementation'),
          () => navigatorImplementation.delete(),
          progress.complete,
          () => logger.progress('Running code generation in cool_page'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'cool_page_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Navigator!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });

  group('platformSetDefaultLanguage', () {
    test(
        'throws PlatformNotActivatedException if the platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformSetDefaultLanguage(
          platform,
          language: const Language(languageCode: 'en'),
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws LanguageNotFoundException for an unsupported language',
        () async {
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformSetDefaultLanguage(
          platform,
          language: const Language(languageCode: 'de'),
        ),
        throwsA(isA<LanguageNotFoundException>()),
      );
    });

    test(
        'throws LanguageIsAlreadyDefaultLanguageException for an already default language',
        () async {
      final rapid = getRapid(project: project);

      expect(
        () => rapid.platformSetDefaultLanguage(
          platform,
          language: const Language(languageCode: 'en'),
        ),
        throwsA(isA<LanguageIsAlreadyDefaultLanguageException>()),
      );
    });

    test(
      'sets default language',
      withMockEnv((manager) async {
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.platformSetDefaultLanguage(
          platform,
          language: const Language(languageCode: 'fr'),
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Setting default language'),
          () => platformLocalizationPackage.setDefaultLanguage(
                const Language(languageCode: 'fr'),
              ),
          progress.complete,
          () => logger.progress(
                'Running "flutter gen-l10n" in platform_localization_package',
              ),
          () => manager.runFlutterGenl10n(
                workingDirectory: 'platform_localization_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Set Default Language!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });
}
