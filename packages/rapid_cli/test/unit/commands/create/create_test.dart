import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/create/create.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'dart:io';

import '../../common.dart';
import '../../mocks.dart';

const expectedUsage = [
  'Create a new Rapid project.\n'
      '\n'
      'Usage: rapid create <project name> [arguments]\n'
      '-h, --help          Print this usage information.\n'
      '\n'
      '\n'
      '-o, --output-dir    The directory where to generate the new project\n'
      '                    (defaults to ".")\n'
      '    --desc          The description of the new project.\n'
      '                    (defaults to "A Rapid app.")\n'
      '    --org-name      The organization of the new project.\n'
      '                    (defaults to "com.example")\n'
      '    --example       Wheter the new project contains example features and their tests.\n'
      '\n'
      '\n'
      '    --android       Wheter the new project supports the Android platform.\n'
      '    --ios           Wheter the new project supports the iOS platform.\n'
      '    --linux         Wheter the new project supports the Linux platform.\n'
      '    --macos         Wheter the new project supports the macOS platform.\n'
      '    --web           Wheter the new project supports the Web platform.\n'
      '    --windows       Wheter the new project supports the Windows platform.\n'
      '    --mobile        Wheter the new project supports the Android and iOS platforms.\n'
      '    --desktop       Wheter the new project supports the Linux, macOS and Windows platforms.\n'
      '    --all           Wheter the new project supports all platforms.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('create', () {
    final cwd = Directory.current;

    late Logger logger;

    late FlutterInstalledCommand flutterInstalled;

    late MelosInstalledCommand melosInstalled;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableAndroid;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableIos;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableLinux;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableMacos;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableWeb;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableWindows;

    late ProjectBuilder projectBuilder;
    late Project project;

    late ArgResults argResults;
    late String outputDir;
    late String projectName;

    late CreateCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();

      flutterInstalled = MockFlutterInstalledCommand();
      when(() => flutterInstalled(logger: logger))
          .thenAnswer((_) async => true);

      melosInstalled = MockMelosInstalledCommand();
      when(() => melosInstalled(logger: logger)).thenAnswer((_) async => true);

      flutterConfigEnableAndroid = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableAndroid(logger: logger))
          .thenAnswer((_) async {});

      flutterConfigEnableIos = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableIos(logger: logger))
          .thenAnswer((_) async {});

      flutterConfigEnableWeb = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableWeb(logger: logger))
          .thenAnswer((_) async {});

      flutterConfigEnableLinux = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableLinux(logger: logger))
          .thenAnswer((_) async {});

      flutterConfigEnableMacos = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableMacos(logger: logger))
          .thenAnswer((_) async {});

      flutterConfigEnableWindows = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableWindows(logger: logger))
          .thenAnswer((_) async {});

      projectBuilder = MockProjectBuilder();
      project = MockProject();
      when(() => project.isEmpty).thenReturn(true);
      when(
        () => project.create(
          projectName: any(named: 'projectName'),
          description: any(named: 'description'),
          orgName: any(named: 'orgName'),
          example: any(named: 'example'),
          android: any(named: 'android'),
          ios: any(named: 'ios'),
          linux: any(named: 'linux'),
          macos: any(named: 'macos'),
          web: any(named: 'web'),
          windows: any(named: 'windows'),
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => projectBuilder(path: any(named: 'path'))).thenReturn(project);

      argResults = MockArgResults();
      projectName = 'test_app';
      outputDir = '.';
      when(() => argResults.rest).thenReturn([projectName]);
      when(() => argResults['output-dir']).thenReturn(outputDir);

      command = CreateCommand(
        logger: logger,
        flutterInstalled: flutterInstalled,
        melosInstalled: melosInstalled,
        flutterConfigEnableAndroid: flutterConfigEnableAndroid,
        flutterConfigEnableIos: flutterConfigEnableIos,
        flutterConfigEnableLinux: flutterConfigEnableLinux,
        flutterConfigEnableMacos: flutterConfigEnableMacos,
        flutterConfigEnableWeb: flutterConfigEnableWeb,
        flutterConfigEnableWindows: flutterConfigEnableWindows,
        project: projectBuilder,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('c is a valid alias', () {
      // Arrange
      final command = CreateCommand();

      // Act + Assert
      expect(command.aliases, contains('c'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['create', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['create', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = CreateCommand();

      // Assert
      expect(command, isNotNull);
    });

    test(
      'throws UsageException when project name is missing',
      withRunner((commandRunner, logger, printLogs) async {
        // Arrange
        const expectedErrorMessage =
            'No option specified for the project name.';

        // Act
        final result = await commandRunner.run(
          ['create'],
        );

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when project name is invalid',
      withRunner((commandRunner, logger, printLogs) async {
        // Arrange
        const projectName = 'My App';
        const expectedErrorMessage =
            '"$projectName" is not a valid package name.\n\n'
            'See https://dart.dev/tools/pub/pubspec#name for more information.';

        // Act
        final result = await commandRunner.run(
          ['create', projectName],
        );

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when multiple project names are provided',
      withRunner((commandRunner, logger, printLogs) async {
        // Assert
        const expectedErrorMessage = 'Multiple project names specified.';

        // Act
        final result = await commandRunner.run(
          ['create', 'my_project1', 'my_project2'],
        );

        // Arrange
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          example: false,
          android: false,
          ios: false,
          linux: false,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --desc', () async {
      // Arrange
      final description = 'My cool description.';
      when(() => argResults['desc']).thenReturn(description);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: description,
          orgName: 'com.example',
          example: false,
          android: false,
          ios: false,
          linux: false,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --android', () async {
      // Arrange
      when(() => argResults['android']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableAndroid(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          example: false,
          android: true,
          ios: false,
          linux: false,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --ios', () async {
      // Arrange
      when(() => argResults['ios']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableIos(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          example: false,
          android: false,
          ios: true,
          linux: false,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --linux', () async {
      // Arrange
      when(() => argResults['linux']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableLinux(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          example: false,
          android: false,
          ios: false,
          linux: true,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --macos', () async {
      // Arrange
      when(() => argResults['macos']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableMacos(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          example: false,
          android: false,
          ios: false,
          linux: false,
          macos: true,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --web', () async {
      // Arrange
      when(() => argResults['web']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableWeb(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          example: false,
          android: false,
          ios: false,
          linux: false,
          macos: false,
          web: true,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --windows', () async {
      // Arrange
      when(() => argResults['windows']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableWindows(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          example: false,
          android: false,
          ios: false,
          linux: false,
          macos: false,
          web: false,
          windows: true,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test(
        'completes successfully with correct output w/ --android --ios --linux --macos --web --windows',
        () async {
      // Arrange
      when(() => argResults['android']).thenReturn(true);
      when(() => argResults['ios']).thenReturn(true);
      when(() => argResults['linux']).thenReturn(true);
      when(() => argResults['macos']).thenReturn(true);
      when(() => argResults['web']).thenReturn(true);
      when(() => argResults['windows']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableAndroid(logger: logger)).called(1);
      verify(() => flutterConfigEnableIos(logger: logger)).called(1);
      verify(() => flutterConfigEnableLinux(logger: logger)).called(1);
      verify(() => flutterConfigEnableMacos(logger: logger)).called(1);
      verify(() => flutterConfigEnableWeb(logger: logger)).called(1);
      verify(() => flutterConfigEnableWindows(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          example: false,
          android: true,
          ios: true,
          linux: true,
          macos: true,
          web: true,
          windows: true,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --mobile', () async {
      // Arrange
      when(() => argResults['mobile']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableAndroid(logger: logger)).called(1);
      verify(() => flutterConfigEnableIos(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          example: false,
          android: true,
          ios: true,
          linux: false,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --desktop', () async {
      // Arrange
      when(() => argResults['desktop']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableLinux(logger: logger)).called(1);
      verify(() => flutterConfigEnableMacos(logger: logger)).called(1);
      verify(() => flutterConfigEnableWindows(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          example: false,
          android: false,
          ios: false,
          linux: true,
          macos: true,
          web: false,
          windows: true,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --all', () async {
      // Arrange
      when(() => argResults['all']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableAndroid(logger: logger)).called(1);
      verify(() => flutterConfigEnableIos(logger: logger)).called(1);
      verify(() => flutterConfigEnableLinux(logger: logger)).called(1);
      verify(() => flutterConfigEnableMacos(logger: logger)).called(1);
      verify(() => flutterConfigEnableWeb(logger: logger)).called(1);
      verify(() => flutterConfigEnableWindows(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          example: false,
          android: true,
          ios: true,
          linux: true,
          macos: true,
          web: true,
          windows: true,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('exits with 69 when flutter is not installed', () async {
      // Arrange
      when(() => flutterInstalled(logger: logger))
          .thenAnswer((_) async => false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Flutter not installed.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.unavailable.code);
    });

    test('exits with 69 when melos is not installed', () async {
      // Arrange
      when(() => melosInstalled(logger: logger)).thenAnswer((_) async => false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Melos not installed.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.unavailable.code);
    });

    test('exits with 78 when output dir is not empty', () async {
      // Arrange
      when(() => project.isEmpty).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Output directory must be empty.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    // TODO testing this way good?
    group('org-name', () {
      group('--org', () {
        test(
          'is a valid alias',
          withRunner((commandRunner, logger, printLogs) async {
            // Arrange
            const orgName = 'com.my.org';

            // Act
            final result = await commandRunner.run(
              ['create', 'my_project', '--org-name', orgName],
            );

            // Assert
            expect(result, equals(ExitCode.success.code));
          }),
          timeout: const Timeout(Duration(seconds: 60)),
        );
      });

      group('invalid --org-name', () {
        void Function() verifyOrgNameIsInvalid(String orgName) =>
            withRunner((commandRunner, logger, printLogs) async {
              // Act
              final result = await commandRunner.run(
                ['create', 'my_project', '--org-name', orgName],
              );

              // Assert
              expect(result, equals(ExitCode.usage.code));
              verify(
                () => logger.err(
                  '"$orgName" is not a valid org name.\n\n'
                  'A valid org name has at least 2 parts separated by "."\n'
                  'Each part must start with a letter and only include '
                  'alphanumeric characters (A-Z, a-z, 0-9), underscores (_), '
                  'and hyphens (-)\n'
                  '(ex. com.example)',
                ),
              ).called(1);
              verify(() => logger.info('')).called(1);
            });

        test(
          'valid prefix but invalid suffix',
          verifyOrgNameIsInvalid('some.good.prefix.bad@@suffix'),
        );

        test(
          'invalid characters present',
          verifyOrgNameIsInvalid('bad%.org@.#name'),
        );

        test('no delimiters', verifyOrgNameIsInvalid('My Org'));

        test(
          'segment starts with a non-letter',
          verifyOrgNameIsInvalid('bad.org.1name'),
        );

        test('less than 2 domains', verifyOrgNameIsInvalid('badorgname'));
      });

      group('valid --org-name', () {
        void Function() verifyOrgNameIsValid(String orgName) => () async {
              // Arrange
              when(() => argResults['org-name']).thenReturn(orgName);

              // Act
              final result = await command.run();

              // Assert
              expect(result, equals(ExitCode.success.code));
              verify(
                () => project.create(
                  projectName: projectName,
                  description: 'A Rapid app.',
                  orgName: orgName,
                  example: false,
                  android: false,
                  ios: false,
                  linux: false,
                  macos: false,
                  web: false,
                  windows: false,
                  logger: logger,
                ),
              ).called(1);
            };

        test(
          'alphanumeric with three parts',
          verifyOrgNameIsValid('com.example.app'),
        );

        test(
          'less than three parts',
          verifyOrgNameIsValid('com.example'),
        );

        test(
          'containing a hyphen',
          verifyOrgNameIsValid('com.example.bad-app'),
        );

        test(
          'more than three parts',
          verifyOrgNameIsValid('com.example.app.identifier'),
        );

        test(
          'single char parts',
          verifyOrgNameIsValid('c.e.a'),
        );

        test(
          'containing an underscore',
          verifyOrgNameIsValid('com.example.bad_app'),
        );
      });
    });
  });
}
