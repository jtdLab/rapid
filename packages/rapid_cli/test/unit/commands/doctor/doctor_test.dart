import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/doctor/doctor.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'dart:io';

import '../../common.dart';
import '../../mocks.dart';

const expectedUsage = [
  'Show information about an existing Rapid project.\n'
      '\n'
      'Usage: rapid doctor\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('doctor', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;
    late PlatformDirectoryBuilder platformDirectoryBuilder;
    late PlatformDirectory platformDirectoryAndroid;
    late List<PlatformCustomFeaturePackage> featuresAndroid;
    late PlatformDirectory platformDirectoryMacos;
    late List<PlatformCustomFeaturePackage> featuresMacos;
    late PlatformCustomFeaturePackage feature1Macos;
    const feature1MacosPath = 'bar/bam/baz';
    late String feature1MacosDefaultLanguage;
    late Set<String> feature1MacosSupportedLanguages;
    const feature1MacosName = 'my_macos_feature_one';
    const feature1MacosPackageName = 'feat_macos_one';
    late PlatformCustomFeaturePackage feature2Macos;
    const feature2MacosPath = 'foo/bar/baz';
    late String feature2MacosDefaultLanguage;
    late Set<String> feature2MacosSupportedLanguages;
    const feature2MacosName = 'my_macos_feature_two';
    const feature2MacosPackageName = 'feat_macos_two';
    late PlatformDirectory platformDirectoryWeb;
    late List<PlatformCustomFeaturePackage> featuresWeb;
    late PlatformCustomFeaturePackage feature1Web;
    const feature1WebPath = 'foo/bom/baz';
    const feature1WebDefaultLanguage = 'fr';
    const feature1WebSupportedLanguages = {'fr'};
    const feature1WebName = 'my_web_feature_one';
    const feature1WebPackageName = 'feat_web_one';

    late DoctorCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();
      final progress = MockProgress();
      progressLogs = <String>[];
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);

      project = MockProject();
      platformDirectoryBuilder = MockPlatformDirectoryBuilder();
      platformDirectoryAndroid = MockPlatformDirectory();
      when(() => platformDirectoryAndroid.platform)
          .thenReturn(Platform.android);
      featuresAndroid = [];
      when(() => platformDirectoryAndroid.customFeaturePackages())
          .thenReturn(featuresAndroid);
      platformDirectoryMacos = MockPlatformDirectory();
      feature1Macos = MockPlatformCustomFeaturePackage();
      feature1MacosDefaultLanguage = 'de';
      feature1MacosSupportedLanguages = {'de'};
      when(() => feature1Macos.packageName())
          .thenReturn(feature1MacosPackageName);
      when(() => feature1Macos.path).thenReturn(feature1MacosPath);
      when(() => feature1Macos.name).thenReturn(feature1MacosName);
      when(() => feature1Macos.defaultLanguage())
          .thenReturn(feature1MacosDefaultLanguage);
      when(() => feature1Macos.supportedLanguages())
          .thenReturn(feature1MacosSupportedLanguages);
      feature2Macos = MockPlatformCustomFeaturePackage();
      feature2MacosDefaultLanguage = 'de';
      feature2MacosSupportedLanguages = {'de'};
      when(() => feature2Macos.packageName())
          .thenReturn(feature2MacosPackageName);
      when(() => feature2Macos.path).thenReturn(feature2MacosPath);
      when(() => feature2Macos.name).thenReturn(feature2MacosName);
      when(() => feature2Macos.defaultLanguage())
          .thenReturn(feature2MacosDefaultLanguage);
      when(() => feature2Macos.supportedLanguages())
          .thenReturn(feature2MacosSupportedLanguages);
      featuresMacos = [feature1Macos, feature2Macos];
      when(() => platformDirectoryMacos.platform).thenReturn(Platform.macos);
      when(() => platformDirectoryMacos.customFeaturePackages())
          .thenReturn(featuresMacos);
      when(() => platformDirectoryMacos.allFeaturesHaveSameLanguages())
          .thenReturn(true);
      when(() => platformDirectoryMacos.allFeaturesHaveSameDefaultLanguage())
          .thenReturn(true);
      platformDirectoryWeb = MockPlatformDirectory();
      feature1Web = MockPlatformCustomFeaturePackage();
      when(() => feature1Web.packageName()).thenReturn(feature1WebPackageName);
      when(() => feature1Web.path).thenReturn(feature1WebPath);
      when(() => feature1Web.name).thenReturn(feature1WebName);
      when(() => feature1Web.defaultLanguage())
          .thenReturn(feature1WebDefaultLanguage);
      when(() => feature1Web.supportedLanguages())
          .thenReturn(feature1WebSupportedLanguages);
      featuresWeb = [feature1Web];
      when(() => platformDirectoryWeb.platform).thenReturn(Platform.web);
      when(() => platformDirectoryWeb.customFeaturePackages())
          .thenReturn(featuresWeb);
      when(() => platformDirectoryWeb.allFeaturesHaveSameLanguages())
          .thenReturn(true);
      when(() => platformDirectoryWeb.allFeaturesHaveSameDefaultLanguage())
          .thenReturn(true);
      when(() => project.existsAll()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.android))
          .thenReturn(true);
      when(() => project.platformIsActivated(Platform.ios)).thenReturn(false);
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(false);
      when(() => project.platformIsActivated(Platform.macos)).thenReturn(true);
      when(() => project.platformIsActivated(Platform.web)).thenReturn(true);
      when(() => project.platformIsActivated(Platform.windows))
          .thenReturn(false);
      when(() => platformDirectoryBuilder(platform: Platform.android))
          .thenReturn(platformDirectoryAndroid);
      when(() => platformDirectoryBuilder(platform: Platform.ios))
          .thenReturn(MockPlatformDirectory());
      when(() => platformDirectoryBuilder(platform: Platform.linux))
          .thenReturn(MockPlatformDirectory());
      when(() => platformDirectoryBuilder(platform: Platform.macos))
          .thenReturn(platformDirectoryMacos);
      when(() => platformDirectoryBuilder(platform: Platform.web))
          .thenReturn(platformDirectoryWeb);
      when(() => platformDirectoryBuilder(platform: Platform.windows))
          .thenReturn(MockPlatformDirectory());
      when(() => project.platformDirectory)
          .thenReturn(platformDirectoryBuilder);

      command = DoctorCommand(
        logger: logger,
        project: project,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(['doctor', '--help']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(['doctor', '-h']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = DoctorCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => platformDirectoryAndroid.customFeaturePackages()).called(1);
      verify(() => platformDirectoryMacos.customFeaturePackages()).called(1);
      verify(() => platformDirectoryWeb.customFeaturePackages()).called(1);
      verify(() => logger.info('[✓] macOS (2 feature(s))')).called(1);
      verify(
        () => logger.info('''

    # | Name                 | Package Name   | Languages | Default Language | Location   
    --|----------------------|----------------|-----------|------------------|------------
    1 | $feature1MacosName | $feature1MacosPackageName | de        | $feature1MacosDefaultLanguage               | $feature1MacosPath
    2 | $feature2MacosName | $feature2MacosPackageName | de        | $feature2MacosDefaultLanguage               | $feature2MacosPath'''),
      ).called(1);
      verify(() => logger.info('[✓] Web (1 feature(s))')).called(1);
      verify(
        () => logger.info('''

    # | Name               | Package Name | Languages | Default Language | Location   
    --|--------------------|--------------|-----------|------------------|------------
    1 | $feature1WebName | $feature1WebPackageName | fr        | fr               | $feature1WebPath'''),
      ).called(1);
      verify(() => logger.info('No issues found.')).called(1);
      verify(() => logger.info('')).called(2);
      expect(result, ExitCode.success.code);
    });

    test(
        'completes successfully with correct output when a platform has issues',
        () async {
      // Arrange
      feature1MacosDefaultLanguage = 'de';
      when(() => feature1Macos.defaultLanguage())
          .thenReturn(feature1MacosDefaultLanguage);
      feature1MacosSupportedLanguages = {'de', 'en', 'fr'};
      when(() => feature1Macos.supportedLanguages())
          .thenReturn(feature1MacosSupportedLanguages);
      feature2MacosDefaultLanguage = 'en';
      when(() => feature2Macos.defaultLanguage())
          .thenReturn(feature2MacosDefaultLanguage);
      feature2MacosSupportedLanguages = {'de', 'en'};
      when(() => feature2Macos.supportedLanguages())
          .thenReturn(feature2MacosSupportedLanguages);
      when(() => platformDirectoryMacos.allFeaturesHaveSameLanguages())
          .thenReturn(false);
      when(() => platformDirectoryMacos.allFeaturesHaveSameDefaultLanguage())
          .thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => platformDirectoryAndroid.customFeaturePackages()).called(1);
      verify(() => platformDirectoryMacos.customFeaturePackages()).called(1);
      verify(() => platformDirectoryWeb.customFeaturePackages()).called(1);
      verify(() => logger.info('[!] macOS (2 feature(s))')).called(1);
      verify(
        () => logger.info('''

    # | Name                 | Package Name   | Languages  | Default Language | Location   
    --|----------------------|----------------|------------|------------------|------------
    1 | $feature1MacosName | $feature1MacosPackageName | de, en, fr | $feature1MacosDefaultLanguage               | $feature1MacosPath
    2 | $feature2MacosName | $feature2MacosPackageName | de, en     | $feature2MacosDefaultLanguage               | $feature2MacosPath'''),
      ).called(1);
      verify(
        () => logger.info(
          '    ✗ Some features do not support the same languages.',
        ),
      ).called(1);
      verify(
        () => logger.info(
          '    ✗ Some features do not have the same default language.',
        ),
      ).called(1);
      verify(() => logger.info('[✓] Web (1 feature(s))')).called(1);
      verify(
        () => logger.info('''

    # | Name               | Package Name | Languages | Default Language | Location   
    --|--------------------|--------------|-----------|------------------|------------
    1 | $feature1WebName | $feature1WebPackageName | fr        | fr               | $feature1WebPath'''),
      ).called(1);
      verify(() => logger.info('! Found 2 issue(s) on 1 platform(s).'))
          .called(1);
      verify(() => logger.info('')).called(3);
      expect(result, ExitCode.success.code);
    });

    test(
        'completes successfully with correct output when no platform has features',
        () async {
      // Arrange
      when(() => platformDirectoryAndroid.customFeaturePackages())
          .thenReturn([]);

      when(() => platformDirectoryMacos.customFeaturePackages()).thenReturn([]);
      when(() => platformDirectoryWeb.customFeaturePackages()).thenReturn([]);

      // Act
      final result = await command.run();

      // Act
      verify(() => logger.info('No issues found.')).called(1);
      verifyNever(() => logger.info(''));
      expect(result, ExitCode.success.code);
    });

    test('exits with 66 project does not exist', () async {
      // Arrange
      when(() => project.existsAll()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'This command should be run from the root of an existing Rapid project.',
        ),
      ).called(1);
      expect(result, ExitCode.noInput.code);
    });
  });
}
