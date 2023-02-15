import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/app_package.dart';
import 'package:rapid_cli/src/project/di_package/di_package.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/logging_package/logging_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_ui_package/platform_ui_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project/ui_package/ui_package.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';

const melosWithName = '''
name: foo_bar
''';

const melosWithoutName = '''
some: value
''';

extension on Platform {
  String get prettyName {
    switch (this) {
      case Platform.android:
        return 'Android';
      case Platform.ios:
        return 'iOS';
      case Platform.web:
        return 'Web';
      case Platform.linux:
        return 'Linux';
      case Platform.macos:
        return 'macOS';
      case Platform.windows:
        return 'Windows';
    }
  }
}

Project _getProject({
  String path = '.',
  MelosFile? melosFile,
  AppPackage? appPackage,
  DiPackage? diPackage,
  DomainPackage? domainPackage,
  InfrastructurePackage? infrastructurePackage,
  LoggingPackage? loggingPackage,
  PlatformDirectoryBuilder? platformDirectory,
  UiPackage? uiPackage,
  PlatformUiPackageBuilder? platformUiPackage,
  MelosBootstrapCommand? melosBootstrap,
  FlutterPubGetCommand? flutterPubGet,
  FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  DartFormatFixCommand? dartFormatFix,
  GeneratorBuilder? generator,
}) {
  return Project(
    path: path,
    melosFile: melosFile,
    appPackage: appPackage,
    diPackage: diPackage,
    domainPackage: domainPackage,
    infrastructurePackage: infrastructurePackage,
    loggingPackage: loggingPackage,
    platformDirectory: platformDirectory,
    uiPackage: uiPackage,
    platformUiPackage: platformUiPackage,
    melosBootstrap: melosBootstrap,
    flutterPubGet: flutterPubGet,
    flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    dartFormatFix: dartFormatFix,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

MelosFile _getMelosFile({Project? project}) {
  return MelosFile(
    project: project ?? getProject(),
  );
}

void main() {
  group('Project', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
      registerFallbackValue(FakeLogger());
      registerFallbackValue(Platform.android);
      registerFallbackValue(FakePlatformCustomFeaturePackage());
    });

    test('.path', () {
      // Arrange
      final project = _getProject(path: 'project/path');

      // Act + Assert
      expect(project.path, 'project/path');
    });

    test('.melosFile', () {
      // Arrange
      final project = _getProject();

      // Act + Assert
      expect(
        project.melosFile,
        isA<MelosFile>().having(
          (melosFile) => melosFile.project,
          'project',
          project,
        ),
      );
    });

    test('.appPackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.appPackage,
        isA<AppPackage>().having(
          (appPackage) => appPackage.project,
          'project',
          project,
        ),
      );
    });

    test('.diPackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.diPackage,
        isA<DiPackage>().having(
          (diPackage) => diPackage.project,
          'project',
          project,
        ),
      );
    });

    test('.domainPackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.domainPackage,
        isA<DomainPackage>().having(
          (domainPackage) => domainPackage.project,
          'project',
          project,
        ),
      );
    });

    test('.infrastructurePackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.infrastructurePackage,
        isA<InfrastructurePackage>().having(
          (infrastructurePackage) => infrastructurePackage.project,
          'project',
          project,
        ),
      );
    });

    test('.loggingPackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.loggingPackage,
        isA<LoggingPackage>().having(
          (loggingPackage) => loggingPackage.project,
          'project',
          project,
        ),
      );
    });

    test('.platformDirectory', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.platformDirectory,
        isA<PlatformDirectoryBuilder>().having(
          (platformDirectory) => platformDirectory(platform: Platform.android),
          'returns',
          isA<PlatformDirectory>()
              .having(
                (platformDirectory) => platformDirectory.platform,
                'platform',
                Platform.android,
              )
              .having(
                (platformDirectory) => platformDirectory.project,
                'project',
                project,
              ),
        ),
      );
    });

    test('.uiPackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.uiPackage,
        isA<UiPackage>().having(
          (uiPackage) => uiPackage.project,
          'project',
          project,
        ),
      );
    });

    test('.platformUiPackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.platformUiPackage,
        isA<PlatformUiPackageBuilder>().having(
          (platformUiPackage) => platformUiPackage(platform: Platform.android),
          'returns',
          isA<PlatformUiPackage>()
              .having(
                (platformUiPackage) => platformUiPackage.platform,
                'platform',
                Platform.android,
              )
              .having(
                (platformUiPackage) => platformUiPackage.project,
                'project',
                project,
              ),
        ),
      );
    });

    test('.name()', () {
      // Arrange
      final melosFile = getMelosFile();
      when(() => melosFile.readName()).thenReturn('my_project');
      final project = _getProject(melosFile: melosFile);

      // Act + Assert
      expect(project.name(), 'my_project');
    });

    group('.existsAll()', () {
      test(
          'returns true when melos file, app package, di package, domain package '
          'infrastructure package, logging package and ui package exist', () {
        // Arrange
        final melosFile = getMelosFile();
        when(() => melosFile.exists()).thenReturn(true);
        final appPackage = getAppPackage();
        when(() => appPackage.exists()).thenReturn(true);
        final diPackage = getDiPackage();
        when(() => diPackage.exists()).thenReturn(true);
        final domainPackage = getDomainPackage();
        when(() => domainPackage.exists()).thenReturn(true);
        final infrastructurePackage = getInfrastructurePackage();
        when(() => infrastructurePackage.exists()).thenReturn(true);
        final loggingPackage = getLoggingPackage();
        when(() => loggingPackage.exists()).thenReturn(true);
        final uiPackage = getUiPackage();
        when(() => uiPackage.exists()).thenReturn(true);
        final project = _getProject(
          melosFile: melosFile,
          appPackage: appPackage,
          diPackage: diPackage,
          domainPackage: domainPackage,
          infrastructurePackage: infrastructurePackage,
          loggingPackage: loggingPackage,
          uiPackage: uiPackage,
        );

        // Act + Assert
        expect(project.existsAll(), true);
      });

      test('returns false when melos file does not exist', () {
        // Arrange
        final melosFile = getMelosFile();
        when(() => melosFile.exists()).thenReturn(false);
        final project = _getProject(melosFile: melosFile);

        // Act + Assert
        expect(project.existsAll(), false);
      });

      test('returns false when app package does not exist', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.exists()).thenReturn(false);
        final project = _getProject(appPackage: appPackage);

        // Act + Assert
        expect(project.existsAll(), false);
      });

      test('returns false when di package does not exist', () {
        // Arrange
        final diPackage = getDiPackage();
        when(() => diPackage.exists()).thenReturn(false);
        final project = _getProject(diPackage: diPackage);

        // Act + Assert
        expect(project.existsAll(), false);
      });

      test('returns false when domain package does not exist', () {
        // Arrange
        final domainPackage = getDomainPackage();
        when(() => domainPackage.exists()).thenReturn(false);
        final project = _getProject(domainPackage: domainPackage);

        // Act + Assert
        expect(project.existsAll(), false);
      });

      test('returns false when infrastructure package does not exist', () {
        // Arrange
        final infrastructurePackage = getInfrastructurePackage();
        when(() => infrastructurePackage.exists()).thenReturn(false);
        final project =
            _getProject(infrastructurePackage: infrastructurePackage);

        // Act + Assert
        expect(project.existsAll(), false);
      });

      test('returns false when logging package does not exist', () {
        // Arrange
        final loggingPackage = getLoggingPackage();
        when(() => loggingPackage.exists()).thenReturn(false);
        final project = _getProject(loggingPackage: loggingPackage);

        // Act + Assert
        expect(project.existsAll(), false);
      });

      test('returns false when ui package does not exist', () {
        // Arrange
        final uiPackage = getUiPackage();
        when(() => uiPackage.exists()).thenReturn(false);
        final project = _getProject(uiPackage: uiPackage);

        // Act + Assert
        expect(project.existsAll(), false);
      });
    });

    group('.existsAny()', () {
      test('returns true when melos file does exist', () {
        // Arrange
        final melosFile = getMelosFile();
        when(() => melosFile.exists()).thenReturn(true);
        final project = _getProject(melosFile: melosFile);

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test('returns true when app package does exist', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.exists()).thenReturn(true);
        final project = _getProject(appPackage: appPackage);

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test('returns true when di package does exist', () {
        // Arrange
        final diPackage = getDiPackage();
        when(() => diPackage.exists()).thenReturn(true);
        final project = _getProject(
          melosFile: getMelosFile(),
          diPackage: diPackage,
        );

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test('returns true when domain package does exist', () {
        // Arrange
        final domainPackage = getDomainPackage();
        when(() => domainPackage.exists()).thenReturn(true);
        final project = _getProject(
          melosFile: getMelosFile(),
          domainPackage: domainPackage,
        );

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test('returns true when infrastructure package does exist', () {
        // Arrange
        final infrastructurePackage = getInfrastructurePackage();
        when(() => infrastructurePackage.exists()).thenReturn(true);
        final project = _getProject(
          melosFile: getMelosFile(),
          infrastructurePackage: infrastructurePackage,
        );

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test('returns true when logging package does exist', () {
        // Arrange
        final loggingPackage = getLoggingPackage();
        when(() => loggingPackage.exists()).thenReturn(true);
        final project = _getProject(
          melosFile: getMelosFile(),
          loggingPackage: loggingPackage,
        );

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test('returns true when ui package does exist', () {
        // Arrange
        final uiPackage = getUiPackage();
        when(() => uiPackage.exists()).thenReturn(true);
        final project = _getProject(
          melosFile: getMelosFile(),
          uiPackage: uiPackage,
        );

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test(
          'returns false when melos file, app package, di package, domain package '
          'infrastructure package, logging package and ui package do not exist',
          () {
        // Arrange
        final melosFile = getMelosFile();
        when(() => melosFile.exists()).thenReturn(false);
        final appPackage = getAppPackage();
        when(() => appPackage.exists()).thenReturn(false);
        final diPackage = getDiPackage();
        when(() => diPackage.exists()).thenReturn(false);
        final domainPackage = getDomainPackage();
        when(() => domainPackage.exists()).thenReturn(false);
        final infrastructurePackage = getInfrastructurePackage();
        when(() => infrastructurePackage.exists()).thenReturn(false);
        final loggingPackage = getLoggingPackage();
        when(() => loggingPackage.exists()).thenReturn(false);
        final uiPackage = getUiPackage();
        when(() => uiPackage.exists()).thenReturn(false);
        final project = _getProject(
          melosFile: melosFile,
          appPackage: appPackage,
          diPackage: diPackage,
          domainPackage: domainPackage,
          infrastructurePackage: infrastructurePackage,
          loggingPackage: loggingPackage,
          uiPackage: uiPackage,
        );

        // Act + Assert
        expect(project.existsAny(), false);
      });
    });

    group('.platformIsActivated()', () {
      test('returns true when platform directory and platform ui package exist',
          () {
        // Arrange
        final platformDirectory = getPlatformDirectory();
        when(() => platformDirectory.exists()).thenReturn(true);
        final platformUiPackage = getPlatformUiPackage();
        when(() => platformUiPackage.exists()).thenReturn(true);
        final project = _getProject(
          platformDirectory: ({required Platform platform}) =>
              platformDirectory,
          platformUiPackage: ({required Platform platform}) =>
              platformUiPackage,
        );

        // Act + Assert
        expect(project.platformIsActivated(Platform.android), true);
      });

      test('returns false when platform directory does not exist', () {
        // Arrange
        final platformDirectory = getPlatformDirectory();
        when(() => platformDirectory.exists()).thenReturn(false);
        final project = _getProject(
          melosFile: getMelosFile(),
          platformDirectory: ({required Platform platform}) =>
              platformDirectory,
        );

        // Act + Assert
        expect(project.platformIsActivated(Platform.android), false);
      });

      test('returns false when platform ui package does not exist', () {
        // Arrange

        final platformUiPackage = getPlatformUiPackage();
        when(() => platformUiPackage.exists()).thenReturn(false);
        final project = _getProject(
          melosFile: getMelosFile(),
          platformUiPackage: ({required Platform platform}) =>
              platformUiPackage,
        );

        // Act + Assert
        expect(project.platformIsActivated(Platform.android), false);
      });
    });

    group('.create()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final appPackage = getAppPackage();
        final diPackage = getDiPackage();
        final domainPackage = getDomainPackage();
        final infrastructurePackage = getInfrastructurePackage();
        final loggingPackage = getLoggingPackage();
        final appFeaturePackage = getPlatformAppFeaturePackage();
        final routingFeaturePackage = getPlatformRoutingFeaturePackage();
        final homePageFeaturePackage = getPlatformCustomFeaturePackage();
        final platformDirectory = getPlatformDirectory();
        when(() => platformDirectory.appFeaturePackage)
            .thenReturn(appFeaturePackage);
        when(() => platformDirectory.routingFeaturePackage)
            .thenReturn(routingFeaturePackage);
        when(() => platformDirectory.customFeaturePackage(name: 'home_page'))
            .thenReturn(homePageFeaturePackage);
        final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
        when(
          () => platformDirectoryBuilder(platform: any(named: 'platform')),
        ).thenReturn(platformDirectory);
        final platformUiPackage = getPlatformUiPackage();
        final platformUiPackageBuilder = getPlatfromUiPackageBuilder();
        when(
          () => platformUiPackageBuilder(platform: any(named: 'platform')),
        ).thenReturn(platformUiPackage);
        final uiPackage = getUiPackage();
        final melosBootstrap = getMelosBootstrap();
        final dartFormatFix = getDartFormatFix();
        final generator = getMasonGenerator();
        final project = _getProject(
          appPackage: appPackage,
          diPackage: diPackage,
          domainPackage: domainPackage,
          infrastructurePackage: infrastructurePackage,
          loggingPackage: loggingPackage,
          platformDirectory: platformDirectoryBuilder,
          uiPackage: uiPackage,
          platformUiPackage: platformUiPackageBuilder,
          melosBootstrap: melosBootstrap,
          dartFormatFix: dartFormatFix,
          generator: (_) async => generator,
        );

        // Act
        final progress = MockProgress();
        final logger = MockLogger();
        when(() => logger.progress(any())).thenReturn(progress);
        await project.create(
          projectName: 'my_project',
          description: 'my desc',
          orgName: 'my.org',
          language: 'de',
          example: false,
          android: true,
          ios: true,
          linux: true,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        );

        // Assert
        verify(() => logger.progress('Generating project files')).called(1);
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '.',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': 'my_project',
            },
            logger: logger,
          ),
        ).called(1);
        verify(
          () => appPackage.create(
            description: 'my desc',
            orgName: 'my.org',
            android: true,
            ios: true,
            linux: true,
            macos: false,
            web: false,
            windows: false,
            logger: logger,
          ),
        ).called(1);
        verify(
          () => diPackage.create(
            android: true,
            ios: true,
            linux: true,
            macos: false,
            web: false,
            windows: false,
            logger: logger,
          ),
        ).called(1);
        verify(() => domainPackage.create(logger: logger)).called(1);
        verify(() => infrastructurePackage.create(logger: logger)).called(1);
        verify(() => loggingPackage.create(logger: logger)).called(1);
        verify(() => uiPackage.create(logger: logger)).called(1);
        verify(() => platformDirectoryBuilder(platform: Platform.android))
            .called(1);
        verify(() => platformDirectoryBuilder(platform: Platform.ios))
            .called(1);
        verify(() => platformDirectoryBuilder(platform: Platform.linux))
            .called(1);
        verify(
          () => appFeaturePackage.create(
            defaultLanguage: 'de',
            languages: {'de'},
            logger: logger,
          ),
        ).called(3);
        verify(() => routingFeaturePackage.create(logger: logger)).called(3);
        verify(
          () => homePageFeaturePackage.create(
            defaultLanguage: 'de',
            languages: {'de'},
            logger: logger,
          ),
        ).called(3);
        verify(() => platformUiPackageBuilder(platform: Platform.android))
            .called(1);
        verify(() => platformUiPackageBuilder(platform: Platform.ios))
            .called(1);
        verify(() => platformUiPackageBuilder(platform: Platform.linux))
            .called(1);
        verify(() => platformUiPackage.create(logger: logger)).called(3);
        verify(() => progress.complete()).called(1);
        verify(() => melosBootstrap(cwd: '.', logger: logger)).called(1);
        verify(() => dartFormatFix(cwd: '.', logger: logger)).called(1);
      });

      test('completes successfully with correct output (2)', () async {
        // Arrange
        final appPackage = getAppPackage();
        final diPackage = getDiPackage();
        final domainPackage = getDomainPackage();
        final infrastructurePackage = getInfrastructurePackage();
        final loggingPackage = getLoggingPackage();
        final appFeaturePackage = getPlatformAppFeaturePackage();
        final routingFeaturePackage = getPlatformRoutingFeaturePackage();
        final homePageFeaturePackage = getPlatformCustomFeaturePackage();
        final platformDirectory = getPlatformDirectory();
        when(() => platformDirectory.appFeaturePackage)
            .thenReturn(appFeaturePackage);
        when(() => platformDirectory.routingFeaturePackage)
            .thenReturn(routingFeaturePackage);
        when(() => platformDirectory.customFeaturePackage(name: 'home_page'))
            .thenReturn(homePageFeaturePackage);
        final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
        when(
          () => platformDirectoryBuilder(platform: any(named: 'platform')),
        ).thenReturn(platformDirectory);
        final platformUiPackage = getPlatformUiPackage();
        final platformUiPackageBuilder = getPlatfromUiPackageBuilder();
        when(
          () => platformUiPackageBuilder(platform: any(named: 'platform')),
        ).thenReturn(platformUiPackage);
        final uiPackage = getUiPackage();
        final melosBootstrap = getMelosBootstrap();
        final dartFormatFix = getDartFormatFix();
        final generator = getMasonGenerator();
        final project = _getProject(
          appPackage: appPackage,
          diPackage: diPackage,
          domainPackage: domainPackage,
          infrastructurePackage: infrastructurePackage,
          loggingPackage: loggingPackage,
          platformDirectory: platformDirectoryBuilder,
          uiPackage: uiPackage,
          platformUiPackage: platformUiPackageBuilder,
          melosBootstrap: melosBootstrap,
          dartFormatFix: dartFormatFix,
          generator: (_) async => generator,
        );

        // Act
        final progress = MockProgress();
        final logger = MockLogger();
        when(() => logger.progress(any())).thenReturn(progress);
        await project.create(
          projectName: 'my_project',
          description: 'my desc',
          orgName: 'my.org',
          language: 'de',
          example: false,
          android: false,
          ios: false,
          linux: false,
          macos: true,
          web: true,
          windows: true,
          logger: logger,
        );

        // Assert
        verify(() => logger.progress('Generating project files')).called(1);
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '.',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': 'my_project',
            },
            logger: logger,
          ),
        ).called(1);
        verify(
          () => appPackage.create(
            description: 'my desc',
            orgName: 'my.org',
            android: false,
            ios: false,
            linux: false,
            macos: true,
            web: true,
            windows: true,
            logger: logger,
          ),
        ).called(1);
        verify(
          () => diPackage.create(
            android: false,
            ios: false,
            linux: false,
            macos: true,
            web: true,
            windows: true,
            logger: logger,
          ),
        ).called(1);
        verify(() => domainPackage.create(logger: logger)).called(1);
        verify(() => infrastructurePackage.create(logger: logger)).called(1);
        verify(() => loggingPackage.create(logger: logger)).called(1);
        verify(() => uiPackage.create(logger: logger)).called(1);
        verify(() => platformDirectoryBuilder(platform: Platform.macos))
            .called(1);
        verify(() => platformDirectoryBuilder(platform: Platform.web))
            .called(1);
        verify(() => platformDirectoryBuilder(platform: Platform.windows))
            .called(1);
        verify(
          () => appFeaturePackage.create(
            logger: logger,
            defaultLanguage: 'de',
            languages: {'de'},
          ),
        ).called(3);
        verify(() => routingFeaturePackage.create(logger: logger)).called(3);
        verify(
          () => homePageFeaturePackage.create(
            logger: logger,
            defaultLanguage: 'de',
            languages: {'de'},
          ),
        ).called(3);
        verify(() => platformUiPackageBuilder(platform: Platform.macos))
            .called(1);
        verify(() => platformUiPackageBuilder(platform: Platform.web))
            .called(1);
        verify(() => platformUiPackageBuilder(platform: Platform.windows))
            .called(1);
        verify(() => platformUiPackage.create(logger: logger)).called(3);
        verify(() => progress.complete()).called(1);
        verify(() => melosBootstrap(cwd: '.', logger: logger)).called(1);
        verify(() => dartFormatFix(cwd: '.', logger: logger)).called(1);
      });
    });

    group('.addPlatform()', () {
      group('completes successfully with correct output', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final appPackage = getAppPackage();
          when(() => appPackage.packageName()).thenReturn('app_package');
          final diPackage = getDiPackage();
          when(() => diPackage.path).thenReturn('di_package/path');
          when(() => diPackage.packageName()).thenReturn('di_package');
          final appFeaturePackage = getPlatformAppFeaturePackage();
          when(() => appFeaturePackage.packageName())
              .thenReturn('app_feature_package');
          final routingFeaturePackage = getPlatformRoutingFeaturePackage();
          when(() => routingFeaturePackage.packageName())
              .thenReturn('routing_feature_package');
          final homePageFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => homePageFeaturePackage.packageName())
              .thenReturn('home_page_feature_package');
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.appFeaturePackage)
              .thenReturn(appFeaturePackage);
          when(() => platformDirectory.routingFeaturePackage)
              .thenReturn(routingFeaturePackage);
          when(() => platformDirectory.customFeaturePackage(name: 'home_page'))
              .thenReturn(homePageFeaturePackage);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.packageName())
              .thenReturn('platform_ui_package');
          final platformUiPackageBuilder = getPlatfromUiPackageBuilder();
          when(
            () => platformUiPackageBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformUiPackage);
          final melosBootstrap = getMelosBootstrap();
          final flutterPubGet = getFlutterPubGet();
          final flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
              getFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs();
          final dartFormatFix = getDartFormatFix();
          final project = _getProject(
            appPackage: appPackage,
            diPackage: diPackage,
            platformDirectory: platformDirectoryBuilder,
            platformUiPackage: platformUiPackageBuilder,
            melosBootstrap: melosBootstrap,
            flutterPubGet: flutterPubGet,
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
                flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
            dartFormatFix: dartFormatFix,
          );

          // Act
          final progress = MockProgress();
          final logger = MockLogger();
          when(() => logger.progress(any())).thenReturn(progress);
          await project.addPlatform(
            platform,
            description: 'my desc',
            orgName: 'my.org',
            language: 'de',
            logger: logger,
          );

          // Assert
          verify(
            () => logger.progress('Generating ${platform.prettyName} files'),
          ).called(1);
          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
          verify(
            () => appFeaturePackage.create(
              defaultLanguage: 'de',
              languages: {'de'},
              logger: logger,
            ),
          ).called(1);
          verify(() => routingFeaturePackage.create(logger: logger)).called(1);
          verify(
            () => homePageFeaturePackage.create(
              defaultLanguage: 'de',
              languages: {'de'},
              logger: logger,
            ),
          ).called(1);
          verify(() => platformUiPackageBuilder(platform: platform)).called(1);
          verify(() => platformUiPackage.create(logger: logger)).called(1);
          verify(() => progress.complete()).called(1);
          verify(
            () => appPackage.addPlatform(
              platform,
              description: 'my desc',
              orgName: 'my.org',
              logger: logger,
            ),
          ).called(1);
          verify(
            () => diPackage.registerCustomFeaturePackage(
              homePageFeaturePackage,
              logger: logger,
            ),
          ).called(1);
          verify(
            () => melosBootstrap(
              cwd: '.',
              logger: logger,
              scope: [
                'app_package',
                'di_package',
                'platform_ui_package',
                'app_feature_package',
                'routing_feature_package',
                'home_page_feature_package',
              ],
            ),
          ).called(1);
          verify(
            () => flutterPubGet(cwd: 'di_package/path', logger: logger),
          ).called(1);
          verify(
            () => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: 'di_package/path',
              logger: logger,
            ),
          ).called(1);
          verify(() => dartFormatFix(cwd: '.', logger: logger)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });

    group('.removePlatform()', () {
      group('completes successfully with correct output', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final appPackage = getAppPackage();
          when(() => appPackage.packageName()).thenReturn('app_package');
          final diPackage = getDiPackage();
          when(() => diPackage.path).thenReturn('di_package/path');
          when(() => diPackage.packageName()).thenReturn('di_package');
          final customFeaturesPackages = [getPlatformCustomFeaturePackage()];
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackages())
              .thenReturn(customFeaturesPackages);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final platformUiPackage = getPlatformUiPackage();
          final platformUiPackageBuilder = getPlatfromUiPackageBuilder();
          when(
            () => platformUiPackageBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformUiPackage);
          final melosBootstrap = getMelosBootstrap();
          final flutterPubGet = getFlutterPubGet();
          final flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
              getFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs();
          final dartFormatFix = getDartFormatFix();
          final project = _getProject(
            appPackage: appPackage,
            diPackage: diPackage,
            platformDirectory: platformDirectoryBuilder,
            platformUiPackage: platformUiPackageBuilder,
            melosBootstrap: melosBootstrap,
            flutterPubGet: flutterPubGet,
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
                flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
            dartFormatFix: dartFormatFix,
          );

          // Act
          final progress = MockProgress();
          final logger = MockLogger();
          when(() => logger.progress(any())).thenReturn(progress);
          await project.removePlatform(
            platform,
            logger: logger,
          );

          // Assert
          verify(() => logger.progress('Deleting ${platform.prettyName} files'))
              .called(1);
          verify(
            () => appPackage.removePlatform(platform, logger: logger),
          ).called(1);
          verify(
            () => platformUiPackageBuilder(platform: platform),
          ).called(1);
          verify(() => platformUiPackage.delete(logger: logger)).called(1);
          verify(
            () => platformDirectoryBuilder(platform: platform),
          ).called(1);
          verify(
            () => diPackage.unregisterCustomFeaturePackages(
              customFeaturesPackages,
              logger: logger,
            ),
          ).called(1);
          verify(() => platformDirectory.delete(logger: logger)).called(1);
          verify(() => progress.complete()).called(1);
          verify(
            () => melosBootstrap(
              cwd: '.',
              logger: logger,
              scope: [
                'app_package',
                'di_package',
              ],
            ),
          ).called(1);
          verify(
            () => flutterPubGet(cwd: 'di_package/path', logger: logger),
          ).called(1);
          verify(
            () => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: 'di_package/path',
              logger: logger,
            ),
          ).called(1);
          verify(() => dartFormatFix(cwd: '.', logger: logger)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });

    group('.addFeature()', () {
      group('completes successfully with correct output', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final diPackage = getDiPackage();
          when(() => diPackage.path).thenReturn('di_package/path');
          when(() => diPackage.packageName()).thenReturn('di_package');
          final appFeaturePackage = getPlatformAppFeaturePackage();
          when(() => appFeaturePackage.packageName())
              .thenReturn('app_feature_package');
          when(() => appFeaturePackage.defaultLanguage()).thenReturn('de');
          when(() => appFeaturePackage.supportedLanguages())
              .thenReturn({'en', 'fr', 'de'});
          final routingFeaturePackage = getPlatformRoutingFeaturePackage();
          when(() => routingFeaturePackage.packageName())
              .thenReturn('routing_feature_package');
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.packageName())
              .thenReturn('my_feature_package');
          when(() => customFeaturePackage.exists()).thenReturn(false);
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.appFeaturePackage)
              .thenReturn(appFeaturePackage);
          when(() => platformDirectory.routingFeaturePackage)
              .thenReturn(routingFeaturePackage);
          when(() => platformDirectory.customFeaturePackage(name: 'my_feature'))
              .thenReturn(customFeaturePackage);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final melosBootstrap = getMelosBootstrap();
          final flutterPubGet = getFlutterPubGet();
          final flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
              getFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs();
          final dartFormatFix = getDartFormatFix();
          final project = _getProject(
            diPackage: diPackage,
            platformDirectory: platformDirectoryBuilder,
            melosBootstrap: melosBootstrap,
            flutterPubGet: flutterPubGet,
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
                flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
            dartFormatFix: dartFormatFix,
          );

          // Act
          final logger = MockLogger();
          await project.addFeature(
            name: 'my_feature',
            description: 'my desc',
            routing: true,
            platform: platform,
            logger: logger,
          );

          // Assert
          verify(
            () => platformDirectoryBuilder(platform: platform),
          ).called(1);
          verify(
            () => platformDirectory.customFeaturePackage(name: 'my_feature'),
          ).called(1);
          verify(
            () => customFeaturePackage.create(
              description: 'my desc',
              defaultLanguage: 'de',
              languages: {'en', 'fr', 'de'},
              logger: logger,
            ),
          ).called(1);
          verify(
            () => appFeaturePackage.registerCustomFeaturePackage(
              customFeaturePackage,
              logger: logger,
            ),
          ).called(1);
          verify(
            () => routingFeaturePackage.registerCustomFeaturePackage(
              customFeaturePackage,
              logger: logger,
            ),
          ).called(1);
          verify(
            () => diPackage.registerCustomFeaturePackage(
              customFeaturePackage,
              logger: logger,
            ),
          ).called(1);
          verify(
            () => melosBootstrap(
              cwd: '.',
              logger: logger,
              scope: [
                'my_feature_package',
                'di_package',
                'app_feature_package',
                'routing_feature_package',
              ],
            ),
          ).called(1);
          verify(
            () => flutterPubGet(cwd: 'di_package/path', logger: logger),
          ).called(1);
          verify(
            () => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: 'di_package/path',
              logger: logger,
            ),
          ).called(1);
          verify(() => dartFormatFix(cwd: '.', logger: logger)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group('completes successfully with correct output without routing', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final diPackage = getDiPackage();
          when(() => diPackage.path).thenReturn('di_package/path');
          when(() => diPackage.packageName()).thenReturn('di_package');
          final appFeaturePackage = getPlatformAppFeaturePackage();
          when(() => appFeaturePackage.packageName())
              .thenReturn('app_feature_package');
          when(() => appFeaturePackage.defaultLanguage()).thenReturn('de');
          when(() => appFeaturePackage.supportedLanguages())
              .thenReturn({'en', 'fr', 'de'});
          final routingFeaturePackage = getPlatformRoutingFeaturePackage();
          when(() => routingFeaturePackage.packageName())
              .thenReturn('routing_feature_package');
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.packageName())
              .thenReturn('my_feature_package');
          when(() => customFeaturePackage.exists()).thenReturn(false);
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.appFeaturePackage)
              .thenReturn(appFeaturePackage);
          when(() => platformDirectory.routingFeaturePackage)
              .thenReturn(routingFeaturePackage);
          when(() => platformDirectory.customFeaturePackage(name: 'my_feature'))
              .thenReturn(customFeaturePackage);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final melosBootstrap = getMelosBootstrap();
          final flutterPubGet = getFlutterPubGet();
          final flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
              getFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs();
          final dartFormatFix = getDartFormatFix();
          final project = _getProject(
            diPackage: diPackage,
            platformDirectory: platformDirectoryBuilder,
            melosBootstrap: melosBootstrap,
            flutterPubGet: flutterPubGet,
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
                flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
            dartFormatFix: dartFormatFix,
          );

          // Act
          final logger = MockLogger();
          await project.addFeature(
            name: 'my_feature',
            description: 'my desc',
            routing: false,
            platform: platform,
            logger: logger,
          );

          // Assert
          verify(
            () => platformDirectoryBuilder(platform: platform),
          ).called(1);
          verify(
            () => platformDirectory.customFeaturePackage(name: 'my_feature'),
          ).called(1);
          verify(
            () => customFeaturePackage.create(
              defaultLanguage: 'de',
              languages: {'en', 'fr', 'de'},
              description: 'my desc',
              logger: logger,
            ),
          ).called(1);
          verify(
            () => appFeaturePackage.registerCustomFeaturePackage(
              customFeaturePackage,
              logger: logger,
            ),
          ).called(1);
          verifyNever(
            () => routingFeaturePackage.registerCustomFeaturePackage(
              customFeaturePackage,
              logger: logger,
            ),
          );
          verify(
            () => diPackage.registerCustomFeaturePackage(
              customFeaturePackage,
              logger: logger,
            ),
          ).called(1);
          verify(
            () => melosBootstrap(
              cwd: '.',
              logger: logger,
              scope: [
                'my_feature_package',
                'di_package',
                'app_feature_package',
              ],
            ),
          ).called(1);
          verify(
            () => flutterPubGet(cwd: 'di_package/path', logger: logger),
          ).called(1);
          verify(
            () => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: 'di_package/path',
              logger: logger,
            ),
          ).called(1);
          verify(() => dartFormatFix(cwd: '.', logger: logger)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group('throws FeatureAlreadyExists when feature already exists', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.exists()).thenReturn(true);
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackage(name: 'my_feature'))
              .thenReturn(customFeaturePackage);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.addFeature(
              name: 'my_feature',
              description: 'my desc',
              routing: false,
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<FeatureAlreadyExists>()),
          );
          verify(
            () => platformDirectoryBuilder(platform: platform),
          ).called(1);
          verify(
            () => platformDirectory.customFeaturePackage(name: 'my_feature'),
          ).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });

    group('.removeFeature()', () {
      group('completes successfully with correct output', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final appPackage = getAppPackage();
          when(() => appPackage.packageName()).thenReturn('app_package');
          final diPackage = getDiPackage();
          when(() => diPackage.path).thenReturn('di_package/path');
          when(() => diPackage.packageName()).thenReturn('di_package');
          final appFeaturePackagePubspec = getPubspecFile();
          final appFeaturePackage = getPlatformAppFeaturePackage();
          when(() => appFeaturePackage.packageName())
              .thenReturn('app_feature_package');
          when(() => appFeaturePackage.pubspecFile)
              .thenReturn(appFeaturePackagePubspec);
          final routingFeaturePackagePubspec = getPubspecFile();
          final routingFeaturePackage = getPlatformRoutingFeaturePackage();
          when(() => routingFeaturePackage.packageName())
              .thenReturn('routing_feature_package');
          when(() => routingFeaturePackage.pubspecFile)
              .thenReturn(routingFeaturePackagePubspec);
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.packageName())
              .thenReturn('my_feature_package');
          when(() => customFeaturePackage.exists()).thenReturn(true);
          final otherFeaturePackagePubspecFile = getPubspecFile();
          final otherFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => otherFeaturePackage.packageName())
              .thenReturn('my_other_feature_package');
          when(() => otherFeaturePackage.pubspecFile)
              .thenReturn(otherFeaturePackagePubspecFile);
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.appFeaturePackage)
              .thenReturn(appFeaturePackage);
          when(() => platformDirectory.routingFeaturePackage)
              .thenReturn(routingFeaturePackage);
          when(() => platformDirectory.customFeaturePackage(name: 'my_feature'))
              .thenReturn(customFeaturePackage);
          when(() => platformDirectory.customFeaturePackages())
              .thenReturn([customFeaturePackage, otherFeaturePackage]);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.packageName())
              .thenReturn('platform_ui_package');
          final platformUiPackageBuilder = getPlatfromUiPackageBuilder();
          when(
            () => platformUiPackageBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformUiPackage);
          final melosBootstrap = getMelosBootstrap();
          final flutterPubGet = getFlutterPubGet();
          final flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
              getFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs();
          final dartFormatFix = getDartFormatFix();
          final project = _getProject(
            appPackage: appPackage,
            diPackage: diPackage,
            platformDirectory: platformDirectoryBuilder,
            platformUiPackage: platformUiPackageBuilder,
            melosBootstrap: melosBootstrap,
            flutterPubGet: flutterPubGet,
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
                flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
            dartFormatFix: dartFormatFix,
          );

          // Act
          final logger = MockLogger();
          await project.removeFeature(
            name: 'my_feature',
            platform: platform,
            logger: logger,
          );

          // Assert
          verify(
            () => platformDirectoryBuilder(platform: platform),
          ).called(1);
          verify(
            () => platformDirectory.customFeaturePackage(name: 'my_feature'),
          ).called(1);
          verify(
            () => diPackage.unregisterCustomFeaturePackages(
              [customFeaturePackage],
              logger: logger,
            ),
          ).called(1);
          verify(
            () => appFeaturePackage.unregisterCustomFeaturePackage(
              customFeaturePackage,
              logger: logger,
            ),
          ).called(1);
          verify(
            () => routingFeaturePackage.unregisterCustomFeaturePackage(
              customFeaturePackage,
              logger: logger,
            ),
          ).called(1);
          verify(
            () => appFeaturePackagePubspec.removeDependency(
              'my_feature_package',
            ),
          ).called(1);
          verify(
            () => routingFeaturePackagePubspec.removeDependency(
              'my_feature_package',
            ),
          ).called(1);
          verify(
            () => otherFeaturePackagePubspecFile.removeDependency(
              'my_feature_package',
            ),
          ).called(1);
          verify(() => customFeaturePackage.delete(logger: logger)).called(1);
          verify(
            () => melosBootstrap(
              cwd: '.',
              logger: logger,
              scope: [
                'di_package',
                'app_feature_package',
                'routing_feature_package',
                'my_other_feature_package',
              ],
            ),
          ).called(1);
          verify(
            () => flutterPubGet(cwd: 'di_package/path', logger: logger),
          ).called(1);
          verify(
            () => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: 'di_package/path',
              logger: logger,
            ),
          ).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group('throws FeatureDoesNotExist when feature does not exist', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.exists()).thenReturn(false);
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackage(name: 'my_feature'))
              .thenReturn(customFeaturePackage);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.removeFeature(
              name: 'my_feature',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<FeatureDoesNotExist>()),
          );
          verify(
            () => platformDirectoryBuilder(platform: platform),
          ).called(1);
          verify(
            () => platformDirectory.customFeaturePackage(name: 'my_feature'),
          ).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });

    group('.addLanguage()', () {
      group('completes successfully with correct output', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final appFeaturePackage = getPlatformAppFeaturePackage();
          final customFeature1 = getPlatformCustomFeaturePackage();
          when(() => customFeature1.supportsLanguage(any())).thenReturn(false);
          final customFeature2 = getPlatformCustomFeaturePackage();
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.appFeaturePackage)
              .thenReturn(appFeaturePackage);
          when(() => platformDirectory.customFeaturePackages()).thenReturn(
            [customFeature1, customFeature2],
          );
          when(() => platformDirectory.allFeaturesHaveSameLanguages())
              .thenReturn(true);
          when(() => platformDirectory.allFeaturesHaveSameDefaultLanguage())
              .thenReturn(true);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final dartFormatFix = getDartFormatFix();
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
            dartFormatFix: dartFormatFix,
          );

          // Act
          final logger = FakeLogger();
          await project.addLanguage(
            'de',
            platform: platform,
            logger: logger,
          );

          // Assert
          verify(
            () => platformDirectoryBuilder(platform: platform),
          ).called(1);
          verify(
            () => appFeaturePackage.addLanguage(language: 'de', logger: logger),
          ).called(1);
          verify(
            () => customFeature1.addLanguage(language: 'de', logger: logger),
          ).called(1);
          verify(
            () => customFeature2.addLanguage(language: 'de', logger: logger),
          ).called(1);
          verify(() => dartFormatFix(logger: logger)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group('throws NoFeaturesFound when no features exist', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackages()).thenReturn([]);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.addLanguage(
              'de',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<NoFeaturesFound>()),
          );
          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group(
          'throws FeaturesHaveDiffrentLanguages when some features have diffrent languages',
          () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final customFeature1 = getPlatformCustomFeaturePackage();
          when(() => customFeature1.supportsLanguage(any())).thenReturn(false);
          final customFeature2 = getPlatformCustomFeaturePackage();
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackages()).thenReturn(
            [customFeature1, customFeature2],
          );
          when(() => platformDirectory.allFeaturesHaveSameLanguages())
              .thenReturn(false);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.addLanguage(
              'de',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<FeaturesHaveDiffrentLanguages>()),
          );
          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group(
          'throws FeaturesHaveDiffrentDefaultLanguage when some features have diffrent default languages',
          () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final customFeature1 = getPlatformCustomFeaturePackage();
          when(() => customFeature1.supportsLanguage(any())).thenReturn(false);
          final customFeature2 = getPlatformCustomFeaturePackage();
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackages()).thenReturn(
            [customFeature1, customFeature2],
          );
          when(() => platformDirectory.allFeaturesHaveSameLanguages())
              .thenReturn(true);
          when(() => platformDirectory.allFeaturesHaveSameDefaultLanguage())
              .thenReturn(false);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.addLanguage(
              'de',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<FeaturesHaveDiffrentDefaultLanguage>()),
          );
          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group(
          'throws FeaturesAlreadySupportLanguage when all features already support the language',
          () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final customFeature1 = getPlatformCustomFeaturePackage();
          when(() => customFeature1.supportsLanguage(any())).thenReturn(true);
          final customFeature2 = getPlatformCustomFeaturePackage();
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackages()).thenReturn(
            [customFeature1, customFeature2],
          );
          when(() => platformDirectory.allFeaturesHaveSameLanguages())
              .thenReturn(true);
          when(() => platformDirectory.allFeaturesHaveSameDefaultLanguage())
              .thenReturn(true);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.addLanguage(
              'de',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<FeaturesAlreadySupportLanguage>()),
          );
          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });

    group('.removeLanguage()', () {
      group('completes successfully with correct output', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final customFeature1 = getPlatformCustomFeaturePackage();
          when(() => customFeature1.supportsLanguage(any())).thenReturn(true);
          when(() => customFeature1.defaultLanguage()).thenReturn('fr');
          final customFeature2 = getPlatformCustomFeaturePackage();
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackages()).thenReturn(
            [customFeature1, customFeature2],
          );
          when(() => platformDirectory.allFeaturesHaveSameLanguages())
              .thenReturn(true);
          when(() => platformDirectory.allFeaturesHaveSameDefaultLanguage())
              .thenReturn(true);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final dartFormatFix = getDartFormatFix();
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
            dartFormatFix: dartFormatFix,
          );

          // Act
          final logger = FakeLogger();
          await project.removeLanguage(
            'de',
            platform: platform,
            logger: logger,
          );

          // Assert
          verify(
            () => platformDirectoryBuilder(platform: platform),
          ).called(1);
          verify(
            () => customFeature1.removeLanguage(language: 'de', logger: logger),
          ).called(1);
          verify(
            () => customFeature2.removeLanguage(language: 'de', logger: logger),
          ).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group('throws NoFeaturesFound when no features exist', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackages()).thenReturn([]);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.removeLanguage(
              'de',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<NoFeaturesFound>()),
          );
          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group(
          'throws FeaturesHaveDiffrentLanguages when some features have diffrent languages',
          () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final customFeature1 = getPlatformCustomFeaturePackage();
          when(() => customFeature1.supportsLanguage(any())).thenReturn(false);
          final customFeature2 = getPlatformCustomFeaturePackage();
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackages()).thenReturn(
            [customFeature1, customFeature2],
          );
          when(() => platformDirectory.allFeaturesHaveSameLanguages())
              .thenReturn(false);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.removeLanguage(
              'de',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<FeaturesHaveDiffrentLanguages>()),
          );
          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group(
          'throws FeaturesHaveDiffrentDefaultLanguage when some features have diffrent default languages',
          () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final customFeature1 = getPlatformCustomFeaturePackage();
          when(() => customFeature1.supportsLanguage(any())).thenReturn(false);
          final customFeature2 = getPlatformCustomFeaturePackage();
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackages()).thenReturn(
            [customFeature1, customFeature2],
          );
          when(() => platformDirectory.allFeaturesHaveSameLanguages())
              .thenReturn(true);
          when(() => platformDirectory.allFeaturesHaveSameDefaultLanguage())
              .thenReturn(false);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.removeLanguage(
              'de',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<FeaturesHaveDiffrentDefaultLanguage>()),
          );
          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group(
          'throws FeaturesDoNotSupportLanguage when the features do not support the language',
          () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final customFeature1 = getPlatformCustomFeaturePackage();
          when(() => customFeature1.supportsLanguage(any())).thenReturn(false);
          final customFeature2 = getPlatformCustomFeaturePackage();
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackages()).thenReturn(
            [customFeature1, customFeature2],
          );
          when(() => platformDirectory.allFeaturesHaveSameLanguages())
              .thenReturn(true);
          when(() => platformDirectory.allFeaturesHaveSameDefaultLanguage())
              .thenReturn(true);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.removeLanguage(
              'de',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<FeaturesDoNotSupportLanguage>()),
          );
          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group(
          'throws UnableToRemoveDefaultLanguage when the language is the default language',
          () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final customFeature1 = getPlatformCustomFeaturePackage();
          when(() => customFeature1.supportsLanguage(any())).thenReturn(true);
          when(() => customFeature1.defaultLanguage()).thenReturn('de');
          final customFeature2 = getPlatformCustomFeaturePackage();
          final platformDirectory = getPlatformDirectory();
          when(() => platformDirectory.customFeaturePackages()).thenReturn(
            [customFeature1, customFeature2],
          );
          when(() => platformDirectory.allFeaturesHaveSameLanguages())
              .thenReturn(true);
          when(() => platformDirectory.allFeaturesHaveSameDefaultLanguage())
              .thenReturn(true);
          final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.removeLanguage(
              'de',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<UnableToRemoveDefaultLanguage>()),
          );
          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });

    group('.addEntity()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final entity = getEntity();
        when(() => entity.existsAny()).thenReturn(false);
        final domainPackage = getDomainPackage();
        when(() => domainPackage.entity(name: 'FooBar', dir: 'entity/path'))
            .thenReturn(entity);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act
        final logger = MockLogger();
        await project.addEntity(
          name: 'FooBar',
          outputDir: 'entity/path',
          logger: logger,
        );

        // Assert
        verify(
          () => domainPackage.entity(name: 'FooBar', dir: 'entity/path'),
        ).called(1);
        verify(() => entity.create(logger: logger)).called(1);
      });

      test('throws EntityAlreadyExists when entity already exists', () async {
        // Arrange
        final entity = getEntity();
        when(() => entity.existsAny()).thenReturn(true);
        final domainPackage = getDomainPackage();
        when(() => domainPackage.entity(name: 'FooBar', dir: 'entity/path'))
            .thenReturn(entity);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act + Assert
        expect(
          project.addEntity(
            name: 'FooBar',
            outputDir: 'entity/path',
            logger: FakeLogger(),
          ),
          throwsA(isA<EntityAlreadyExists>()),
        );
      });
    });

    group('.removeEntity()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final entity = getEntity();
        when(() => entity.existsAny()).thenReturn(true);
        final domainPackage = getDomainPackage();
        when(() => domainPackage.entity(name: 'FooBar', dir: 'entity/path'))
            .thenReturn(entity);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act
        final logger = MockLogger();
        await project.removeEntity(
          name: 'FooBar',
          dir: 'entity/path',
          logger: logger,
        );

        // Assert
        verify(
          () => domainPackage.entity(name: 'FooBar', dir: 'entity/path'),
        ).called(1);
        verify(() => entity.delete(logger: logger)).called(1);
      });

      test('throws EntityDoesNotExist when entity does not exist', () async {
        // Arrange
        final entity = getEntity();
        when(() => entity.existsAny()).thenReturn(false);
        final domainPackage = getDomainPackage();
        when(() => domainPackage.entity(name: 'FooBar', dir: 'entity/path'))
            .thenReturn(entity);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act + Assert
        expect(
          project.removeEntity(
            name: 'FooBar',
            dir: 'entity/path',
            logger: FakeLogger(),
          ),
          throwsA(isA<EntityDoesNotExist>()),
        );
      });
    });

    group('.addServiceInterface()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final serviceInterface = getServiceInterface();
        when(() => serviceInterface.existsAny()).thenReturn(false);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.serviceInterface(
            name: 'FooBar',
            dir: 'entity/path',
          ),
        ).thenReturn(serviceInterface);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act
        final logger = MockLogger();
        await project.addServiceInterface(
          name: 'FooBar',
          outputDir: 'entity/path',
          logger: logger,
        );

        // Assert
        verify(
          () => domainPackage.serviceInterface(
            name: 'FooBar',
            dir: 'entity/path',
          ),
        ).called(1);
        verify(() => serviceInterface.create(logger: logger)).called(1);
      });

      test(
          'throws ServiceInterfaceAlreadyExists when service interface already exists',
          () async {
        // Arrange
        final serviceInterface = getServiceInterface();
        when(() => serviceInterface.existsAny()).thenReturn(true);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.serviceInterface(
            name: 'FooBar',
            dir: 'service_interface/path',
          ),
        ).thenReturn(serviceInterface);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act + Assert
        expect(
          project.addServiceInterface(
            name: 'FooBar',
            outputDir: 'service_interface/path',
            logger: FakeLogger(),
          ),
          throwsA(isA<ServiceInterfaceAlreadyExists>()),
        );
      });
    });

    group('.removeServiceInterface()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final serviceInterface = getServiceInterface();
        when(() => serviceInterface.existsAny()).thenReturn(true);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.serviceInterface(
            name: 'FooBar',
            dir: 'entity/path',
          ),
        ).thenReturn(serviceInterface);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act
        final logger = MockLogger();
        await project.removeServiceInterface(
          name: 'FooBar',
          dir: 'entity/path',
          logger: logger,
        );

        // Assert
        verify(
          () => domainPackage.serviceInterface(
            name: 'FooBar',
            dir: 'entity/path',
          ),
        ).called(1);
        verify(() => serviceInterface.delete(logger: logger)).called(1);
      });

      test(
          'throws ServiceInterfaceDoesNotExist when service interface does no exist',
          () async {
        // Arrange
        final serviceInterface = getServiceInterface();
        when(() => serviceInterface.existsAny()).thenReturn(false);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.serviceInterface(
            name: 'FooBar',
            dir: 'service_interface/path',
          ),
        ).thenReturn(serviceInterface);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act + Assert
        expect(
          project.removeServiceInterface(
            name: 'FooBar',
            dir: 'service_interface/path',
            logger: FakeLogger(),
          ),
          throwsA(isA<ServiceInterfaceDoesNotExist>()),
        );
      });
    });

    group('.addValueObject()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final valueObject = getValueObject();
        when(() => valueObject.existsAny()).thenReturn(false);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.valueObject(
            name: 'FooBar',
            dir: 'value_object/path',
          ),
        ).thenReturn(valueObject);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act
        final logger = MockLogger();
        await project.addValueObject(
          name: 'FooBar',
          outputDir: 'value_object/path',
          type: 'String',
          generics: '',
          logger: logger,
        );

        // Assert
        verify(
          () => domainPackage.valueObject(
            name: 'FooBar',
            dir: 'value_object/path',
          ),
        ).called(1);
        verify(
          () => valueObject.create(
            logger: logger,
            type: 'String',
            generics: '',
          ),
        ).called(1);
      });

      test('throws ValueObjectAlreadyExists when value object already exists',
          () async {
        // Arrange
        final valueObject = getValueObject();
        when(() => valueObject.existsAny()).thenReturn(true);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.valueObject(
            name: 'FooBar',
            dir: 'value_object/path',
          ),
        ).thenReturn(valueObject);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act + Assert
        expect(
          project.addValueObject(
            name: 'FooBar',
            outputDir: 'value_object/path',
            type: 'String',
            generics: '',
            logger: FakeLogger(),
          ),
          throwsA(isA<ValueObjectAlreadyExists>()),
        );
      });
    });

    group('.removeValueObject()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final valueObject = getValueObject();
        when(() => valueObject.existsAny()).thenReturn(true);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.valueObject(
            name: 'FooBar',
            dir: 'value_object/path',
          ),
        ).thenReturn(valueObject);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act
        final logger = MockLogger();
        await project.removeValueObject(
          name: 'FooBar',
          dir: 'value_object/path',
          logger: logger,
        );

        // Assert
        verify(
          () => domainPackage.valueObject(
            name: 'FooBar',
            dir: 'value_object/path',
          ),
        ).called(1);
        verify(() => valueObject.delete(logger: logger)).called(1);
      });

      test('throws ValueObjectDoesNotExist when value object does not exist',
          () async {
        // Arrange
        final valueObject = getValueObject();
        when(() => valueObject.existsAny()).thenReturn(false);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.valueObject(
            name: 'FooBar',
            dir: 'value_object/path',
          ),
        ).thenReturn(valueObject);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act + Assert
        expect(
          project.removeValueObject(
            name: 'FooBar',
            dir: 'value_object/path',
            logger: FakeLogger(),
          ),
          throwsA(isA<ValueObjectDoesNotExist>()),
        );
      });
    });

    group('.addDataTransferObject()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final entity = getEntity();
        when(() => entity.existsAny()).thenReturn(true);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.entity(
            name: 'FooBar',
            dir: 'data_transfer_object/path',
          ),
        ).thenReturn(entity);
        final dataTransferObject = getDataTransferObject();
        when(() => dataTransferObject.existsAny()).thenReturn(false);
        final infrastructurePackage = getInfrastructurePackage();
        when(
          () => infrastructurePackage.dataTransferObject(
            entityName: 'FooBar',
            dir: 'data_transfer_object/path',
          ),
        ).thenReturn(dataTransferObject);
        final project = _getProject(
          domainPackage: domainPackage,
          infrastructurePackage: infrastructurePackage,
        );

        // Act
        final logger = FakeLogger();
        await project.addDataTransferObject(
          entityName: 'FooBar',
          outputDir: 'data_transfer_object/path',
          logger: logger,
        );

        // Assert
        verify(
          () => domainPackage.entity(
            name: 'FooBar',
            dir: 'data_transfer_object/path',
          ),
        ).called(1);
        verify(
          () => infrastructurePackage.dataTransferObject(
            entityName: 'FooBar',
            dir: 'data_transfer_object/path',
          ),
        ).called(1);
        verify(() => dataTransferObject.create(logger: logger)).called(1);
      });

      test('throws EntityDoesNotExist when related entity does not exist',
          () async {
        // Arrange
        final entity = getEntity();
        when(() => entity.existsAny()).thenReturn(false);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.entity(
            name: 'FooBar',
            dir: 'data_transfer_object/path',
          ),
        ).thenReturn(entity);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act + Assert
        expect(
          project.addDataTransferObject(
            entityName: 'FooBar',
            outputDir: 'data_transfer_object/path',
            logger: FakeLogger(),
          ),
          throwsA(isA<EntityDoesNotExist>()),
        );
      });

      test(
          'throws DataTransferObjectAlreadyExists when the data transfer object already exists',
          () async {
        // Arrange
        final entity = getEntity();
        when(() => entity.existsAny()).thenReturn(true);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.entity(
            name: 'FooBar',
            dir: 'data_transfer_object/path',
          ),
        ).thenReturn(entity);
        final dataTransferObject = getDataTransferObject();
        when(() => dataTransferObject.existsAny()).thenReturn(true);
        final infrastructurePackage = getInfrastructurePackage();
        when(
          () => infrastructurePackage.dataTransferObject(
            entityName: 'FooBar',
            dir: 'data_transfer_object/path',
          ),
        ).thenReturn(dataTransferObject);
        final project = _getProject(
          domainPackage: domainPackage,
          infrastructurePackage: infrastructurePackage,
        );

        // Act + Assert
        expect(
          project.addDataTransferObject(
            entityName: 'FooBar',
            outputDir: 'data_transfer_object/path',
            logger: FakeLogger(),
          ),
          throwsA(isA<DataTransferObjectAlreadyExists>()),
        );
      });
    });

    group('.removeDataTransferObject()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final dataTransferObject = getDataTransferObject();
        when(() => dataTransferObject.existsAny()).thenReturn(true);
        final infrastructurePackage = getInfrastructurePackage();
        when(
          () => infrastructurePackage.dataTransferObject(
            entityName: 'FooBar',
            dir: 'data_transfer_object/path',
          ),
        ).thenReturn(dataTransferObject);
        final project = _getProject(
          infrastructurePackage: infrastructurePackage,
        );

        // Act
        final logger = FakeLogger();
        await project.removeDataTransferObject(
          name: 'FooBar',
          dir: 'data_transfer_object/path',
          logger: logger,
        );

        // Assert
        verify(
          () => infrastructurePackage.dataTransferObject(
            entityName: 'FooBar',
            dir: 'data_transfer_object/path',
          ),
        ).called(1);
        verify(() => dataTransferObject.delete(logger: logger)).called(1);
      });

      test(
          'throws DataTransferObjectDoesNotExist when the value object does not exist',
          () async {
        // Arrange
        final dataTransferObject = getDataTransferObject();
        when(() => dataTransferObject.existsAny()).thenReturn(false);
        final infrastructurePackage = getInfrastructurePackage();
        when(
          () => infrastructurePackage.dataTransferObject(
            entityName: 'FooBar',
            dir: 'data_transfer_object/path',
          ),
        ).thenReturn(dataTransferObject);
        final project = _getProject(
          infrastructurePackage: infrastructurePackage,
        );

        // Act
        expect(
          project.removeDataTransferObject(
            name: 'FooBar',
            dir: 'data_transfer_object/path',
            logger: FakeLogger(),
          ),
          throwsA(isA<DataTransferObjectDoesNotExist>()),
        );
      });
    });

    group('.addServiceImplementation()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final serviceInterface = getServiceInterface();
        when(() => serviceInterface.existsAny()).thenReturn(true);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.serviceInterface(
            name: 'FooBar',
            dir: 'service_implementation/path',
          ),
        ).thenReturn(serviceInterface);
        final serviceImplementation = getServiceImplementation();
        when(() => serviceImplementation.existsAny()).thenReturn(false);
        final infrastructurePackage = getInfrastructurePackage();
        when(
          () => infrastructurePackage.serviceImplementation(
            name: 'Fake',
            serviceName: 'FooBar',
            dir: 'service_implementation/path',
          ),
        ).thenReturn(serviceImplementation);
        final project = _getProject(
          domainPackage: domainPackage,
          infrastructurePackage: infrastructurePackage,
        );

        // Act
        final logger = FakeLogger();
        await project.addServiceImplementation(
          name: 'Fake',
          serviceName: 'FooBar',
          outputDir: 'service_implementation/path',
          logger: logger,
        );

        // Assert
        verify(
          () => domainPackage.serviceInterface(
            name: 'FooBar',
            dir: 'service_implementation/path',
          ),
        ).called(1);
        verify(
          () => infrastructurePackage.serviceImplementation(
            name: 'Fake',
            serviceName: 'FooBar',
            dir: 'service_implementation/path',
          ),
        ).called(1);
        verify(() => serviceImplementation.create(logger: logger)).called(1);
      });

      test(
          'throws ServiceInterfaceDoesNotExist when related service interface does not exist',
          () async {
        // Arrange
        final serviceInterface = getServiceInterface();
        when(() => serviceInterface.existsAny()).thenReturn(false);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.serviceInterface(
            name: 'FooBar',
            dir: 'service_implementation/path',
          ),
        ).thenReturn(serviceInterface);
        final project = _getProject(
          domainPackage: domainPackage,
        );

        // Act + Assert
        expect(
          project.addServiceImplementation(
            name: 'Fake',
            serviceName: 'FooBar',
            outputDir: 'service_implementation/path',
            logger: FakeLogger(),
          ),
          throwsA(isA<ServiceInterfaceDoesNotExist>()),
        );
      });

      test(
          'throws ServiceImplementationAlreadyExists when the service implementation already exists',
          () async {
        // Arrange
        final serviceInterface = getServiceInterface();
        when(() => serviceInterface.existsAny()).thenReturn(true);
        final domainPackage = getDomainPackage();
        when(
          () => domainPackage.serviceInterface(
            name: 'FooBar',
            dir: 'service_implementation/path',
          ),
        ).thenReturn(serviceInterface);
        final serviceImplementation = getServiceImplementation();
        when(() => serviceImplementation.existsAny()).thenReturn(true);
        final infrastructurePackage = getInfrastructurePackage();
        when(
          () => infrastructurePackage.serviceImplementation(
            name: 'Fake',
            serviceName: 'FooBar',
            dir: 'service_implementation/path',
          ),
        ).thenReturn(serviceImplementation);
        final project = _getProject(
          domainPackage: domainPackage,
          infrastructurePackage: infrastructurePackage,
        );

        // Act + Assert
        expect(
          project.addServiceImplementation(
            name: 'Fake',
            serviceName: 'FooBar',
            outputDir: 'service_implementation/path',
            logger: FakeLogger(),
          ),
          throwsA(isA<ServiceImplementationAlreadyExists>()),
        );
      });
    });

    group('.removeServiceImplementation()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final serviceImplementation = getServiceImplementation();
        when(() => serviceImplementation.existsAny()).thenReturn(true);
        final infrastructurePackage = getInfrastructurePackage();
        when(
          () => infrastructurePackage.serviceImplementation(
            name: 'Fake',
            serviceName: 'FooBar',
            dir: 'service_implementation/path',
          ),
        ).thenReturn(serviceImplementation);
        final project = _getProject(
          infrastructurePackage: infrastructurePackage,
        );

        // Act
        final logger = FakeLogger();
        await project.removeServiceImplementation(
          name: 'Fake',
          serviceName: 'FooBar',
          dir: 'service_implementation/path',
          logger: logger,
        );

        // Assert
        verify(
          () => infrastructurePackage.serviceImplementation(
            name: 'Fake',
            serviceName: 'FooBar',
            dir: 'service_implementation/path',
          ),
        ).called(1);
        verify(() => serviceImplementation.delete(logger: logger)).called(1);
      });

      test(
          'throws ServiceImplementationDoesNotExist when the service implementation does not exist',
          () async {
        // Arrange
        final serviceImplementation = getServiceImplementation();
        when(() => serviceImplementation.existsAny()).thenReturn(false);
        final infrastructurePackage = getInfrastructurePackage();
        when(
          () => infrastructurePackage.serviceImplementation(
            name: 'Fake',
            serviceName: 'FooBar',
            dir: 'service_implementation/path',
          ),
        ).thenReturn(serviceImplementation);
        final project = _getProject(
          infrastructurePackage: infrastructurePackage,
        );

        // Act
        expect(
          project.removeServiceImplementation(
            name: 'Fake',
            serviceName: 'FooBar',
            dir: 'service_implementation/path',
            logger: FakeLogger(),
          ),
          throwsA(isA<ServiceImplementationDoesNotExist>()),
        );
      });
    });

    group('.addBloc()', () {
      group('completes successfully with correct output', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final bloc = getBloc();
          when(() => bloc.existsAny()).thenReturn(false);
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.path).thenReturn('my_feature/path');
          when(() => customFeaturePackage.exists()).thenReturn(true);
          when(() => customFeaturePackage.bloc(name: any(named: 'name')))
              .thenReturn(bloc);
          final platformDirectory = getPlatformDirectory();
          when(
            () => platformDirectory.customFeaturePackage(
              name: any(named: 'name'),
            ),
          ).thenReturn(customFeaturePackage);
          final platformDirectoryBuilder = getPlatformDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
              getFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs();
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
                flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
          );

          // Act
          final logger = MockLogger();
          await project.addBloc(
            name: 'FooBar',
            featureName: 'my_feature',
            platform: platform,
            logger: logger,
          );

          // Assert
          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
          verify(() =>
                  platformDirectory.customFeaturePackage(name: 'my_feature'))
              .called(1);
          verify(() => customFeaturePackage.bloc(name: 'FooBar')).called(1);
          verify(() => bloc.create(logger: logger)).called(1);
          verify(
            () => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: 'my_feature/path',
              logger: logger,
            ),
          ).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group(
          'throws FeatureDoesNotExist when the related feature does not exists',
          () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.exists()).thenReturn(false);
          final platformDirectory = getPlatformDirectory();
          when(
            () => platformDirectory.customFeaturePackage(
              name: any(named: 'name'),
            ),
          ).thenReturn(customFeaturePackage);
          final platformDirectoryBuilder = getPlatformDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.addBloc(
              name: 'FooBar',
              featureName: 'my_feature',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<FeatureDoesNotExist>()),
          );

          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
          verify(() =>
                  platformDirectory.customFeaturePackage(name: 'my_feature'))
              .called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group('throws BlocAlreadyExists when bloc already exists', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final bloc = getBloc();
          when(() => bloc.existsAny()).thenReturn(true);
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.exists()).thenReturn(true);
          when(() => customFeaturePackage.bloc(name: any(named: 'name')))
              .thenReturn(bloc);
          final platformDirectory = getPlatformDirectory();
          when(
            () => platformDirectory.customFeaturePackage(
              name: any(named: 'name'),
            ),
          ).thenReturn(customFeaturePackage);
          final platformDirectoryBuilder = getPlatformDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.addBloc(
              name: 'FooBar',
              featureName: 'my_feature',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<BlocAlreadyExists>()),
          );

          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
          verify(() =>
                  platformDirectory.customFeaturePackage(name: 'my_feature'))
              .called(1);
          verify(() => customFeaturePackage.bloc(name: 'FooBar')).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });

    group('.addCubit()', () {
      group('completes successfully with correct output', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final cubit = getCubit();
          when(() => cubit.existsAny()).thenReturn(false);
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.path).thenReturn('my_feature/path');
          when(() => customFeaturePackage.exists()).thenReturn(true);
          when(() => customFeaturePackage.cubit(name: any(named: 'name')))
              .thenReturn(cubit);
          final platformDirectory = getPlatformDirectory();
          when(
            () => platformDirectory.customFeaturePackage(
              name: any(named: 'name'),
            ),
          ).thenReturn(customFeaturePackage);
          final platformDirectoryBuilder = getPlatformDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
              getFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs();
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
                flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
          );

          // Act
          final logger = MockLogger();
          await project.addCubit(
            name: 'FooBar',
            featureName: 'my_feature',
            platform: platform,
            logger: logger,
          );

          // Assert
          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
          verify(() =>
                  platformDirectory.customFeaturePackage(name: 'my_feature'))
              .called(1);
          verify(() => customFeaturePackage.cubit(name: 'FooBar')).called(1);
          verify(() => cubit.create(logger: logger)).called(1);
          verify(
            () => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: 'my_feature/path',
              logger: logger,
            ),
          ).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group(
          'throws FeatureDoesNotExist when the related feature does not exists',
          () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.exists()).thenReturn(false);
          final platformDirectory = getPlatformDirectory();
          when(
            () => platformDirectory.customFeaturePackage(
              name: any(named: 'name'),
            ),
          ).thenReturn(customFeaturePackage);
          final platformDirectoryBuilder = getPlatformDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.addCubit(
              name: 'FooBar',
              featureName: 'my_feature',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<FeatureDoesNotExist>()),
          );

          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
          verify(() =>
                  platformDirectory.customFeaturePackage(name: 'my_feature'))
              .called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group('throws CubitAlreadyExists when bloc already exists', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final cubit = getCubit();
          when(() => cubit.existsAny()).thenReturn(true);
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.exists()).thenReturn(true);
          when(() => customFeaturePackage.cubit(name: any(named: 'name')))
              .thenReturn(cubit);
          final platformDirectory = getPlatformDirectory();
          when(
            () => platformDirectory.customFeaturePackage(
              name: any(named: 'name'),
            ),
          ).thenReturn(customFeaturePackage);
          final platformDirectoryBuilder = getPlatformDirectoryBuilder();
          when(
            () => platformDirectoryBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformDirectory);
          final project = _getProject(
            platformDirectory: platformDirectoryBuilder,
          );

          // Act + Assert
          expect(
            project.addCubit(
              name: 'FooBar',
              featureName: 'my_feature',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<CubitAlreadyExists>()),
          );

          verify(() => platformDirectoryBuilder(platform: platform)).called(1);
          verify(() =>
                  platformDirectory.customFeaturePackage(name: 'my_feature'))
              .called(1);
          verify(() => customFeaturePackage.cubit(name: 'FooBar')).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });

    group('.addWidget()', () {
      group('completes successfully with correct output', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final widget = getWidget();
          when(() => widget.existsAny()).thenReturn(false);
          final platformUiPackage = getPlatformUiPackage();
          when(
            () => platformUiPackage.widget(
              name: 'FooBar',
              dir: 'widget/path',
            ),
          ).thenReturn(widget);
          final platformUiPackageBuilder = getPlatformUiPackageBuilder();
          when(
            () => platformUiPackageBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformUiPackage);
          final project = _getProject(
            platformUiPackage: platformUiPackageBuilder,
          );

          // Act
          final logger = MockLogger();
          await project.addWidget(
            name: 'FooBar',
            outputDir: 'widget/path',
            platform: platform,
            logger: logger,
          );

          // Assert
          verify(() => platformUiPackageBuilder(platform: platform)).called(1);
          verify(
            () => platformUiPackage.widget(
              name: 'FooBar',
              dir: 'widget/path',
            ),
          ).called(1);
          verify(() => widget.create(logger: logger)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group('throws WidgetAlreadyExists when widget already exists', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final widget = getWidget();
          when(() => widget.existsAny()).thenReturn(true);
          final platformUiPackage = getPlatformUiPackage();
          when(
            () => platformUiPackage.widget(
              name: 'FooBar',
              dir: 'widget/path',
            ),
          ).thenReturn(widget);
          final platformUiPackageBuilder = getPlatformUiPackageBuilder();
          when(
            () => platformUiPackageBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformUiPackage);
          final project = _getProject(
            platformUiPackage: platformUiPackageBuilder,
          );

          // Act + Assert
          expect(
            project.addWidget(
              name: 'FooBar',
              outputDir: 'widget/path',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<WidgetAlreadyExists>()),
          );
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });

    group('.removeWidget()', () {
      group('completes successfully with correct output', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final widget = getWidget();
          when(() => widget.existsAny()).thenReturn(true);
          final platformUiPackage = getPlatformUiPackage();
          when(
            () => platformUiPackage.widget(
              name: 'FooBar',
              dir: 'widget/path',
            ),
          ).thenReturn(widget);
          final platformUiPackageBuilder = getPlatformUiPackageBuilder();
          when(
            () => platformUiPackageBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformUiPackage);
          final project = _getProject(
            platformUiPackage: platformUiPackageBuilder,
          );

          // Act
          final logger = MockLogger();
          await project.removeWidget(
            name: 'FooBar',
            dir: 'widget/path',
            platform: platform,
            logger: logger,
          );

          // Assert
          verify(() => platformUiPackageBuilder(platform: platform)).called(1);
          verify(
            () => platformUiPackage.widget(
              name: 'FooBar',
              dir: 'widget/path',
            ),
          ).called(1);
          verify(() => widget.delete(logger: logger)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group('throws WidgetDoesNotExist when widget does not exist', () {
        Future<void> performTest(Platform platform) async {
          // Arrange
          final widget = getWidget();
          when(() => widget.existsAny()).thenReturn(false);
          final platformUiPackage = getPlatformUiPackage();
          when(
            () => platformUiPackage.widget(
              name: 'FooBar',
              dir: 'widget/path',
            ),
          ).thenReturn(widget);
          final platformUiPackageBuilder = getPlatformUiPackageBuilder();
          when(
            () => platformUiPackageBuilder(platform: any(named: 'platform')),
          ).thenReturn(platformUiPackage);
          final project = _getProject(
            platformUiPackage: platformUiPackageBuilder,
          );

          // Act + Assert
          expect(
            project.removeWidget(
              name: 'FooBar',
              dir: 'widget/path',
              platform: platform,
              logger: FakeLogger(),
            ),
            throwsA(isA<WidgetDoesNotExist>()),
          );
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });
  });

  group('MelosFile', () {
    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      final melosFile = _getMelosFile(project: project);

      // Act + Assert
      expect(melosFile.path, 'project/path/melos.yaml');
    });

    test('.project', () {
      // Arrange
      final project = getProject();
      final melosFile = _getMelosFile(
        project: project,
      );

      // Act + Assert
      expect(melosFile.project, project);
    });

    group('.exists', () {
      test(
        'returns true when the file exists',
        withTempDir(() {
          // Arrange
          final melosFile = _getMelosFile();
          File(melosFile.path).createSync(recursive: true);

          // Act + Assert
          expect(melosFile.exists(), true);
        }),
      );

      test(
        'returns false when the file does not exists',
        withTempDir(() {
          // Arrange
          final melosFile = _getMelosFile();

          // Act + Assert
          expect(melosFile.exists(), false);
        }),
      );
    });

    group('.name', () {
      test(
        'returns name',
        withTempDir(() {
          // Arrange
          final melosFile = _getMelosFile();
          File(melosFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(melosWithName);

          // Act + Assert
          expect(melosFile.readName(), 'foo_bar');
        }),
      );

      test(
        'throws read name failure when name is not present',
        withTempDir(() {
          // Arrange
          final melosFile = _getMelosFile();
          File(melosFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(melosWithoutName);

          // Act + Assert
          expect(
            () => melosFile.readName(),
            throwsA(isA<ReadNameFailure>()),
          );
        }),
      );
    });
  });
}
