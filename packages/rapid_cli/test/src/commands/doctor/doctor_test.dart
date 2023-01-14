import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/doctor/doctor.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/feature.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../helpers/helpers.dart';

const expectedUsage = [
  'Show information about an existing Rapid project.\n'
      '\n'
      'Usage: rapid doctor\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProject extends Mock implements Project {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockPlatformDirectory extends Mock implements PlatformDirectory {}

class _MockFeature extends Mock implements Feature {}

class _MockPubspecFile extends Mock implements PubspecFile {}

void main() {
  group('doctor', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;
    late MelosFile melosFile;
    const projectName = 'my_project';
    late PlatformDirectory platformDirectoryAndroid;
    late List<Feature> featuresAndroid;
    late PlatformDirectory platformDirectoryMacos;
    late List<Feature> featuresMacos;
    late Feature feature1Macos;
    const feature1MacosPath = 'bar/bam/baz';
    late String feature1MacosDefaultLanguage;
    late Set<String> feature1MacosSupportedLanguages;
    const feature1MacosName = 'my_macos_feature_one';
    late PubspecFile feature1MacosPubspecFile;
    const feature1MacosPackageName = 'feat_macos_one';
    late Feature feature2Macos;
    const feature2MacosPath = 'foo/bar/baz';
    late String feature2MacosDefaultLanguage;
    late Set<String> feature2MacosSupportedLanguages;
    const feature2MacosName = 'my_macos_feature_two';
    late PubspecFile feature2MacosPubspecFile;
    const feature2MacosPackageName = 'feat_macos_two';
    late PlatformDirectory platformDirectoryWeb;
    late List<Feature> featuresWeb;
    late Feature feature1Web;
    const feature1WebPath = 'foo/bom/baz';
    const feature1WebDefaultLanguage = 'fr';
    const feature1WebSupportedLanguages = {'fr'};
    const feature1WebName = 'my_web_feature_one';
    late PubspecFile feature1WebPubspecFile;
    const feature1WebPackageName = 'feat_web_one';

    late DoctorCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();
      final progress = _MockProgress();
      progressLogs = <String>[];
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);

      project = _MockProject();
      melosFile = _MockMelosFile();
      when(() => melosFile.exists()).thenReturn(true);
      when(() => melosFile.name()).thenReturn(projectName);
      platformDirectoryAndroid = _MockPlatformDirectory();
      when(() => platformDirectoryAndroid.platform)
          .thenReturn(Platform.android);
      featuresAndroid = [];
      when(() => platformDirectoryAndroid.getFeatures(
          exclude: any(named: 'exclude'))).thenReturn(featuresAndroid);
      platformDirectoryMacos = _MockPlatformDirectory();
      feature1Macos = _MockFeature();
      feature1MacosDefaultLanguage = 'de';
      feature1MacosSupportedLanguages = {'de'};
      feature1MacosPubspecFile = _MockPubspecFile();
      when(() => feature1MacosPubspecFile.name())
          .thenReturn(feature1MacosPackageName);
      when(() => feature1Macos.pubspecFile)
          .thenReturn(feature1MacosPubspecFile);
      when(() => feature1Macos.path).thenReturn(feature1MacosPath);
      when(() => feature1Macos.name).thenReturn(feature1MacosName);
      when(() => feature1Macos.defaultLanguage())
          .thenReturn(feature1MacosDefaultLanguage);
      when(() => feature1Macos.supportedLanguages())
          .thenReturn(feature1MacosSupportedLanguages);
      feature2Macos = _MockFeature();
      feature2MacosDefaultLanguage = 'de';
      feature2MacosSupportedLanguages = {'de'};
      feature2MacosPubspecFile = _MockPubspecFile();
      when(() => feature2MacosPubspecFile.name())
          .thenReturn(feature2MacosPackageName);
      when(() => feature2Macos.pubspecFile)
          .thenReturn(feature2MacosPubspecFile);
      when(() => feature2Macos.path).thenReturn(feature2MacosPath);
      when(() => feature2Macos.name).thenReturn(feature2MacosName);
      when(() => feature2Macos.defaultLanguage())
          .thenReturn(feature2MacosDefaultLanguage);
      when(() => feature2Macos.supportedLanguages())
          .thenReturn(feature2MacosSupportedLanguages);
      featuresMacos = [feature1Macos, feature2Macos];
      when(() => platformDirectoryMacos.platform).thenReturn(Platform.macos);
      when(() => platformDirectoryMacos.getFeatures(
          exclude: any(named: 'exclude'))).thenReturn(featuresMacos);
      platformDirectoryWeb = _MockPlatformDirectory();
      feature1Web = _MockFeature();
      feature1WebPubspecFile = _MockPubspecFile();
      when(() => feature1WebPubspecFile.name())
          .thenReturn(feature1WebPackageName);
      when(() => feature1Web.pubspecFile).thenReturn(feature1WebPubspecFile);
      when(() => feature1Web.path).thenReturn(feature1WebPath);
      when(() => feature1Web.name).thenReturn(feature1WebName);
      when(() => feature1Web.defaultLanguage())
          .thenReturn(feature1WebDefaultLanguage);
      when(() => feature1Web.supportedLanguages())
          .thenReturn(feature1WebSupportedLanguages);
      featuresWeb = [feature1Web];
      when(() => platformDirectoryWeb.platform).thenReturn(Platform.web);
      when(() =>
              platformDirectoryWeb.getFeatures(exclude: any(named: 'exclude')))
          .thenReturn(featuresWeb);
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.isActivated(Platform.android)).thenReturn(true);
      when(() => project.isActivated(Platform.ios)).thenReturn(false);
      when(() => project.isActivated(Platform.linux)).thenReturn(false);
      when(() => project.isActivated(Platform.macos)).thenReturn(true);
      when(() => project.isActivated(Platform.web)).thenReturn(true);
      when(() => project.isActivated(Platform.windows)).thenReturn(false);
      when(() => project.platformDirectory(Platform.android))
          .thenReturn(platformDirectoryAndroid);
      when(() => project.platformDirectory(Platform.ios))
          .thenReturn(_MockPlatformDirectory());
      when(() => project.platformDirectory(Platform.linux))
          .thenReturn(_MockPlatformDirectory());
      when(() => project.platformDirectory(Platform.macos))
          .thenReturn(platformDirectoryMacos);
      when(() => project.platformDirectory(Platform.web))
          .thenReturn(platformDirectoryWeb);
      when(() => project.platformDirectory(Platform.windows))
          .thenReturn(_MockPlatformDirectory());

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
      verify(() => project.isActivated(Platform.android)).called(1);
      verify(() => project.isActivated(Platform.ios)).called(1);
      verify(() => project.isActivated(Platform.linux)).called(1);
      verify(() => project.isActivated(Platform.macos)).called(1);
      verify(() => project.isActivated(Platform.web)).called(1);
      verify(() => project.isActivated(Platform.windows)).called(1);
      verify(() => project.platformDirectory(Platform.android)).called(1);
      verify(() => project.platformDirectory(Platform.macos)).called(1);
      verify(() => project.platformDirectory(Platform.web)).called(1);
      verify(() =>
              platformDirectoryAndroid.getFeatures(exclude: {'app', 'routing'}))
          .called(1);
      verify(() =>
              platformDirectoryMacos.getFeatures(exclude: {'app', 'routing'}))
          .called(1);
      verify(() =>
              platformDirectoryWeb.getFeatures(exclude: {'app', 'routing'}))
          .called(1);
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

      // Act
      final result = await command.run();

      // Assert
      verify(() => project.isActivated(Platform.android)).called(1);
      verify(() => project.isActivated(Platform.ios)).called(1);
      verify(() => project.isActivated(Platform.linux)).called(1);
      verify(() => project.isActivated(Platform.macos)).called(1);
      verify(() => project.isActivated(Platform.web)).called(1);
      verify(() => project.isActivated(Platform.windows)).called(1);
      verify(() => project.platformDirectory(Platform.android)).called(1);
      verify(() => project.platformDirectory(Platform.macos)).called(1);
      verify(() => project.platformDirectory(Platform.web)).called(1);
      verify(() =>
              platformDirectoryAndroid.getFeatures(exclude: {'app', 'routing'}))
          .called(1);
      verify(() =>
              platformDirectoryMacos.getFeatures(exclude: {'app', 'routing'}))
          .called(1);
      verify(() =>
              platformDirectoryWeb.getFeatures(exclude: {'app', 'routing'}))
          .called(1);
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

    test('exits with 66 when melos.yaml does not exist', () async {
      // Arrange
      when(() => melosFile.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('''
 Could not find a melos.yaml.
 This command should be run from the root of your Rapid project.''')).called(1);
      expect(result, ExitCode.noInput.code);
    });
  });
}
