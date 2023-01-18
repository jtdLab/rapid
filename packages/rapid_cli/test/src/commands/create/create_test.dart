import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/create/create.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../helpers/helpers.dart';

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
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class _FlutterInstalledCommand {
  Future<bool> call({required Logger logger});
}

abstract class _FlutterConfigEnablePlatformCommand {
  Future<void> call({required Logger logger});
}

abstract class _MelosBootstrapCommand {
  Future<void> call({String cwd, required Logger logger});
}

abstract class _FormatFixCommand {
  Future<void> call({String cwd, required Logger logger});
}

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockFlutterInstalledCommand extends Mock
    implements _FlutterInstalledCommand {}

class _MockFlutterConfigEnablePlatformCommand extends Mock
    implements _FlutterConfigEnablePlatformCommand {}

class _MockMelosBootstrapCommand extends Mock
    implements _MelosBootstrapCommand {}

class _MockFlutterFormatFixCommand extends Mock implements _FormatFixCommand {}

class _MockMasonGenerator extends Mock implements MasonGenerator {}

class _MockArgResults extends Mock implements ArgResults {}

class _FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

void main() {
  group('create', () {
    final cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;
    late Progress progress;

    late FlutterInstalledCommand flutterInstalled;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableAndroid;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableIos;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableLinux;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableMacos;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableWeb;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableWindows;

    late MelosBootstrapCommand melosBootstrap;

    late FlutterFormatFixCommand flutterFormatFix;

    late MasonGenerator generator;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );

    late ArgResults argResults;
    late String outputDir;
    late String projectName;

    late CreateCommand command;

    setUpAll(() {
      registerFallbackValue(_FakeDirectoryGeneratorTarget());
    });

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();
      progress = _MockProgress();
      progressLogs = <String>[];
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);

      flutterInstalled = _MockFlutterInstalledCommand();
      when(() => flutterInstalled(logger: logger))
          .thenAnswer((_) async => true);

      flutterConfigEnableAndroid = _MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableAndroid(logger: logger))
          .thenAnswer((_) async {});

      flutterConfigEnableIos = _MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableIos(logger: logger))
          .thenAnswer((_) async {});

      flutterConfigEnableWeb = _MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableWeb(logger: logger))
          .thenAnswer((_) async {});

      flutterConfigEnableLinux = _MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableLinux(logger: logger))
          .thenAnswer((_) async {});

      flutterConfigEnableMacos = _MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableMacos(logger: logger))
          .thenAnswer((_) async {});

      flutterConfigEnableWindows = _MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableWindows(logger: logger))
          .thenAnswer((_) async {});

      melosBootstrap = _MockMelosBootstrapCommand();
      when(() => melosBootstrap(cwd: any(named: 'cwd'), logger: logger))
          .thenAnswer((_) async {});

      flutterFormatFix = _MockFlutterFormatFixCommand();
      when(() => flutterFormatFix(cwd: any(named: 'cwd'), logger: logger))
          .thenAnswer((_) async {});

      generator = _MockMasonGenerator();
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles);

      argResults = _MockArgResults();
      projectName = 'test_app';
      outputDir = '.';
      when(() => argResults.rest).thenReturn([projectName]);
      when(() => argResults['output-dir']).thenReturn(outputDir);

      command = CreateCommand(
        logger: logger,
        flutterInstalled: flutterInstalled,
        flutterConfigEnableAndroid: flutterConfigEnableAndroid,
        flutterConfigEnableIos: flutterConfigEnableIos,
        flutterConfigEnableLinux: flutterConfigEnableLinux,
        flutterConfigEnableMacos: flutterConfigEnableMacos,
        flutterConfigEnableWeb: flutterConfigEnableWeb,
        flutterConfigEnableWindows: flutterConfigEnableWindows,
        melosBootstrap: melosBootstrap,
        flutterFormatFix: flutterFormatFix,
        generator: (_) async => generator,
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
      verify(() => logger.progress('Bootstrapping')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              outputDir,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'org_name': 'com.example',
            'description': 'A Rapid app.',
            'example': false,
            'android': false,
            'ios': false,
            'linux': false,
            'macos': false,
            'web': false,
            'windows': false,
            'none': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.progress('Running "melos bootstrap" in $outputDir '))
          .called(1);
      verify(() => melosBootstrap(cwd: outputDir, logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter format . --fix" in $outputDir ')).called(1);
      verify(() => flutterFormatFix(cwd: outputDir, logger: logger)).called(1);
      verify(() => progress.complete()).called(2);
      verify(() => logger.success('Created a Rapid App!')).called(1);
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
      verify(() => logger.progress('Bootstrapping')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              outputDir,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'org_name': 'com.example',
            'description': description,
            'example': false,
            'android': false,
            'ios': false,
            'linux': false,
            'macos': false,
            'web': false,
            'windows': false,
            'none': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.progress('Running "melos bootstrap" in $outputDir '))
          .called(1);
      verify(() => melosBootstrap(cwd: outputDir, logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter format . --fix" in $outputDir ')).called(1);
      verify(() => flutterFormatFix(cwd: outputDir, logger: logger)).called(1);
      verify(() => progress.complete()).called(2);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --android', () async {
      // Arrange
      when(() => argResults['android']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => logger.progress('Running "flutter config --enable-android"'))
          .called(1);
      verify(() => flutterConfigEnableAndroid(logger: logger)).called(1);
      verify(() => logger.progress('Bootstrapping')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              outputDir,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'org_name': 'com.example',
            'description': 'A Rapid app.',
            'example': false,
            'android': true,
            'ios': false,
            'linux': false,
            'macos': false,
            'web': false,
            'windows': false,
            'none': false,
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.progress('Running "melos bootstrap" in $outputDir '))
          .called(1);
      verify(() => melosBootstrap(cwd: outputDir, logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter format . --fix" in $outputDir ')).called(1);
      verify(() => flutterFormatFix(cwd: outputDir, logger: logger)).called(1);
      verify(() => progress.complete()).called(3);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --ios', () async {
      // Arrange
      when(() => argResults['ios']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => logger.progress('Running "flutter config --enable-ios"'))
          .called(1);
      verify(() => flutterConfigEnableIos(logger: logger)).called(1);
      verify(() => logger.progress('Bootstrapping')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              outputDir,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'org_name': 'com.example',
            'description': 'A Rapid app.',
            'example': false,
            'android': false,
            'ios': true,
            'linux': false,
            'macos': false,
            'web': false,
            'windows': false,
            'none': false,
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.progress('Running "melos bootstrap" in $outputDir '))
          .called(1);
      verify(() => melosBootstrap(cwd: outputDir, logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter format . --fix" in $outputDir ')).called(1);
      verify(() => flutterFormatFix(cwd: outputDir, logger: logger)).called(1);
      verify(() => progress.complete()).called(3);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --linux', () async {
      // Arrange
      when(() => argResults['linux']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter config --enable-linux-desktop"')).called(1);
      verify(() => flutterConfigEnableLinux(logger: logger)).called(1);
      verify(() => logger.progress('Bootstrapping')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              outputDir,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'org_name': 'com.example',
            'description': 'A Rapid app.',
            'example': false,
            'android': false,
            'ios': false,
            'linux': true,
            'macos': false,
            'web': false,
            'windows': false,
            'none': false,
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.progress('Running "melos bootstrap" in $outputDir '))
          .called(1);
      verify(() => melosBootstrap(cwd: outputDir, logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter format . --fix" in $outputDir ')).called(1);
      verify(() => flutterFormatFix(cwd: outputDir, logger: logger)).called(1);
      verify(() => progress.complete()).called(3);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --macos', () async {
      // Arrange
      when(() => argResults['macos']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter config --enable-macos-desktop"')).called(1);
      verify(() => flutterConfigEnableMacos(logger: logger)).called(1);
      verify(() => logger.progress('Bootstrapping')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              outputDir,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'org_name': 'com.example',
            'description': 'A Rapid app.',
            'example': false,
            'android': false,
            'ios': false,
            'linux': false,
            'macos': true,
            'web': false,
            'windows': false,
            'none': false,
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.progress('Running "melos bootstrap" in $outputDir '))
          .called(1);
      verify(() => melosBootstrap(cwd: outputDir, logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter format . --fix" in $outputDir ')).called(1);
      verify(() => flutterFormatFix(cwd: outputDir, logger: logger)).called(1);
      verify(() => progress.complete()).called(3);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --web', () async {
      // Arrange
      when(() => argResults['web']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => logger.progress('Running "flutter config --enable-web"'))
          .called(1);
      verify(() => flutterConfigEnableWeb(logger: logger)).called(1);
      verify(() => logger.progress('Bootstrapping')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              outputDir,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'org_name': 'com.example',
            'description': 'A Rapid app.',
            'example': false,
            'android': false,
            'ios': false,
            'linux': false,
            'macos': false,
            'web': true,
            'windows': false,
            'none': false,
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.progress('Running "melos bootstrap" in $outputDir '))
          .called(1);
      verify(() => melosBootstrap(cwd: outputDir, logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter format . --fix" in $outputDir ')).called(1);
      verify(() => flutterFormatFix(cwd: outputDir, logger: logger)).called(1);
      verify(() => progress.complete()).called(3);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --windows', () async {
      // Arrange
      when(() => argResults['windows']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter config --enable-windows-desktop"')).called(1);
      verify(() => flutterConfigEnableWindows(logger: logger)).called(1);
      verify(() => logger.progress('Bootstrapping')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              outputDir,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'org_name': 'com.example',
            'description': 'A Rapid app.',
            'example': false,
            'android': false,
            'ios': false,
            'linux': false,
            'macos': false,
            'web': false,
            'windows': true,
            'none': false,
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.progress('Running "melos bootstrap" in $outputDir '))
          .called(1);
      verify(() => melosBootstrap(cwd: outputDir, logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter format . --fix" in $outputDir ')).called(1);
      verify(() => flutterFormatFix(cwd: outputDir, logger: logger)).called(1);
      verify(() => progress.complete()).called(3);
      verify(() => logger.success('Created a Rapid App!')).called(1);
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
      verify(() => logger.progress('Running "flutter config --enable-android"'))
          .called(1);
      verify(() => flutterConfigEnableAndroid(logger: logger)).called(1);
      verify(() => logger.progress('Running "flutter config --enable-ios"'))
          .called(1);
      verify(() => flutterConfigEnableIos(logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter config --enable-linux-desktop"')).called(1);
      verify(() => flutterConfigEnableLinux(logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter config --enable-macos-desktop"')).called(1);
      verify(() => flutterConfigEnableMacos(logger: logger)).called(1);
      verify(() => logger.progress('Running "flutter config --enable-web"'))
          .called(1);
      verify(() => flutterConfigEnableWeb(logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter config --enable-windows-desktop"')).called(1);
      verify(() => flutterConfigEnableWindows(logger: logger)).called(1);
      verify(() => logger.progress('Bootstrapping')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              outputDir,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'org_name': 'com.example',
            'description': 'A Rapid app.',
            'example': false,
            'android': true,
            'ios': true,
            'linux': true,
            'macos': true,
            'web': true,
            'windows': true,
            'none': false,
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.progress('Running "melos bootstrap" in $outputDir '))
          .called(1);
      verify(() => melosBootstrap(cwd: outputDir, logger: logger)).called(1);
      verify(() => logger.progress(
          'Running "flutter format . --fix" in $outputDir ')).called(1);
      verify(() => flutterFormatFix(cwd: outputDir, logger: logger)).called(1);
      verify(() => progress.complete()).called(8);
      verify(() => logger.success('Created a Rapid App!')).called(1);
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
      expect(result, ExitCode.unavailable.code);
    });

    group('org-name', () {
      group('--org', () {
        test(
          'is a valid alias',
          withRunner((commandRunner, logger, printLogs) async {
            // Arrange
            const orgName = 'com.my.org';

            // Act
            final result = await commandRunner.run(
              ['create', 'my_project', '--org', orgName],
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
        void Function() verifyOrgNameIsValid2(String orgName) => () async {
              // Arrange
              when(() => argResults['org-name']).thenReturn(orgName);

              // Act
              final result = await command.run();

              // Assert
              expect(result, equals(ExitCode.success.code));
              verify(
                () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (g) => g.dir.path,
                      'dir',
                      outputDir,
                    ),
                  ),
                  vars: <String, dynamic>{
                    'project_name': projectName,
                    'org_name': orgName,
                    'description': 'A Rapid app.',
                    'example': false,
                    'android': false,
                    'ios': false,
                    'web': false,
                    'linux': false,
                    'macos': false,
                    'windows': false,
                    'none': true,
                  },
                  logger: logger,
                ),
              ).called(1);
            };

        test(
          'alphanumeric with three parts',
          verifyOrgNameIsValid2('com.example.app'),
        );

        test(
          'less than three parts',
          verifyOrgNameIsValid2('com.example'),
        );

        test(
          'containing a hyphen',
          verifyOrgNameIsValid2('com.example.bad-app'),
        );

        test(
          'more than three parts',
          verifyOrgNameIsValid2('com.example.app.identifier'),
        );

        test(
          'single char parts',
          verifyOrgNameIsValid2('c.e.a'),
        );

        test(
          'containing an underscore',
          verifyOrgNameIsValid2('com.example.bad_app'),
        );
      });
    });
  });
}
