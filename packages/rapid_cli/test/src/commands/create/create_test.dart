import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/create/create.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Creates a new Rapid project in the specified directory.\n'
      '\n'
      'Usage: rapid create <output directory>\n'
      '-h, --help            Print this usage information.\n'
      '\n'
      '\n'
      '    --project-name    The name of this new project. This must be a valid dart package name.\n'
      '    --desc            The description of this new project.\n'
      '                      (defaults to "A Rapid app.")\n'
      '    --org-name        The organization of this new project.\n'
      '                      (defaults to "com.example")\n'
      '    --example         Wheter this new project contains example features and their tests.\n'
      '\n'
      '\n'
      '    --android         Wheter this new project supports the Android platform.\n'
      '    --ios             Wheter this new project supports the iOS platform.\n'
      '    --linux           Wheter this new project supports the Linux platform.\n'
      '    --macos           Wheter this new project supports the macOS platform.\n'
      '    --web             Wheter this new project supports the Web platform.\n'
      '    --windows         Wheter this new project supports the Windows platform.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

// ignore: one_member_abstracts
abstract class FlutterInstalledCommand {
  Future<bool> call();
}

abstract class FlutterConfigEnablePlatformCommand {
  Future<void> call();
}

abstract class MelosBootstrapCommand {
  Future<void> call({String cwd});
}

class MockLogger extends Mock implements Logger {}

class MockProgress extends Mock implements Progress {}

class MockArgResults extends Mock implements ArgResults {}

class MockFlutterInstalledCommand extends Mock
    implements FlutterInstalledCommand {}

class MockFlutterConfigEnablePlatformCommand extends Mock
    implements FlutterConfigEnablePlatformCommand {}

class MockMasonGenerator extends Mock implements MasonGenerator {}

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

class MockMelosBootstrapCommand extends Mock implements MelosBootstrapCommand {}

void main() {
  group('create', () {
    late String outputDir;
    late String projectName;
    late List<String> progressLogs;
    late Logger logger;
    late Progress progress;
    late ArgResults argResults;
    late FlutterInstalledCommand flutterInstalled;
    late FlutterConfigEnablePlatformCommand flutterConfigEnableAndroid;
    late FlutterConfigEnablePlatformCommand flutterConfigEnableIos;
    late FlutterConfigEnablePlatformCommand flutterConfigEnableLinux;
    late FlutterConfigEnablePlatformCommand flutterConfigEnableMacos;
    late FlutterConfigEnablePlatformCommand flutterConfigEnableWeb;
    late FlutterConfigEnablePlatformCommand flutterConfigEnableWindows;
    late MasonGenerator generator;
    late MelosBootstrapCommand melosBootstrap;

    late CreateCommand command;

    final generatedFiles = List.filled(
      62,
      const GeneratedFile.created(path: ''),
    );

    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    setUp(() {
      outputDir = Directory.systemTemp.createTempSync().path;
      projectName = 'test_app';
      progressLogs = <String>[];
      progress = MockProgress();
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      logger = MockLogger();
      when(() => logger.err(any())).thenReturn(null);
      when(() => logger.progress(any())).thenReturn(progress);
      argResults = MockArgResults();
      when(() => argResults['project-name']).thenReturn(projectName);
      when(() => argResults.rest).thenReturn([outputDir]);
      flutterInstalled = MockFlutterInstalledCommand();
      when(() => flutterInstalled()).thenAnswer((_) async => true);
      flutterConfigEnableAndroid = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableAndroid()).thenAnswer((_) async {});
      flutterConfigEnableIos = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableIos()).thenAnswer((_) async {});
      flutterConfigEnableWeb = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableWeb()).thenAnswer((_) async {});
      flutterConfigEnableLinux = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableLinux()).thenAnswer((_) async {});
      flutterConfigEnableMacos = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableMacos()).thenAnswer((_) async {});
      flutterConfigEnableWindows = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableWindows()).thenAnswer((_) async {});
      generator = MockMasonGenerator();
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles);
      melosBootstrap = MockMelosBootstrapCommand();
      when(() => melosBootstrap(cwd: any(named: 'cwd')))
          .thenAnswer((_) async {});

      command = CreateCommand(
        logger: logger,
        flutterInstalled: flutterInstalled,
        flutterConfigEnableAndroid: flutterConfigEnableAndroid,
        flutterConfigEnableIos: flutterConfigEnableIos,
        flutterConfigEnableLinux: flutterConfigEnableLinux,
        flutterConfigEnableMacos: flutterConfigEnableMacos,
        flutterConfigEnableWeb: flutterConfigEnableWeb,
        flutterConfigEnableWindows: flutterConfigEnableWindows,
        generator: (_) async => generator,
        melosBootstrap: melosBootstrap,
      )..argResultOverrides = argResults;
    });

    test('c is a valid alias', () {
      // Arrange
      final command = CreateCommand();

      // Act + Assert
      expect(command.aliases, contains('c'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, project, printLogs) async {
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
      'throws UsageException when --project-name is missing '
      'and directory base is not a valid package name',
      withRunner((commandRunner, logger, project, printLogs) async {
        // Arrange
        outputDir = '.invalid';
        final expectedErrorMessage =
            '"$outputDir" is not a valid package name.\n\n'
            'See https://dart.dev/tools/pub/pubspec#name for more information.';

        // Act
        final result = await commandRunner.run(
          ['create', outputDir],
        );

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when --project-name is invalid',
      withRunner((commandRunner, logger, project, printLogs) async {
        // Arrange
        projectName = 'My App';
        final expectedErrorMessage =
            '"$projectName" is not a valid package name.\n\n'
            'See https://dart.dev/tools/pub/pubspec#name for more information.';

        // Act
        final result = await commandRunner.run(
          ['create', outputDir, '--project-name', projectName],
        );

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when output directory is missing',
      withRunner((commandRunner, logger, project, printLogs) async {
        // Arrange
        const expectedErrorMessage =
            'No option specified for the output directory.';

        // Act
        final result = await commandRunner.run(['create']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when multiple output directories are provided',
      withRunner((commandRunner, logger, project, printLogs) async {
        // Assert
        const expectedErrorMessage = 'Multiple output directories specified.';

        // Act
        final result = await commandRunner.run(['create', './a', './b']);

        // Arrange
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test('exits with 69 when flutter is not installed', () async {
      // Arrange
      when(() => flutterInstalled()).thenAnswer((_) async => false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Flutter not installed.')).called(1);
      expect(result, ExitCode.unavailable.code);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled()).called(1);
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
      verify(() => melosBootstrap(cwd: outputDir)).called(1);
      verify(() => progress.complete()).called(1);
      verify(() => logger.alert('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --android', () async {
      // Arrange
      when(() => argResults['android']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled()).called(1);
      verify(() => logger.progress('Running "flutter config --enable-android"'))
          .called(1);
      verify(() => flutterConfigEnableAndroid()).called(1);
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
      verify(() => melosBootstrap(cwd: outputDir)).called(1);
      verify(() => progress.complete()).called(2);
      verify(() => logger.alert('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --ios', () async {
      // Arrange
      when(() => argResults['ios']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled()).called(1);
      verify(() => logger.progress('Running "flutter config --enable-ios"'))
          .called(1);
      verify(() => flutterConfigEnableIos()).called(1);
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
      verify(() => melosBootstrap(cwd: outputDir)).called(1);
      verify(() => progress.complete()).called(2);
      verify(() => logger.alert('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --linux', () async {
      // Arrange
      when(() => argResults['linux']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled()).called(1);
      verify(() => logger.progress(
          'Running "flutter config --enable-linux-desktop"')).called(1);
      verify(() => flutterConfigEnableLinux()).called(1);
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
      verify(() => melosBootstrap(cwd: outputDir)).called(1);
      verify(() => progress.complete()).called(2);
      verify(() => logger.alert('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --macos', () async {
      // Arrange
      when(() => argResults['macos']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled()).called(1);
      verify(() => logger.progress(
          'Running "flutter config --enable-macos-desktop"')).called(1);
      verify(() => flutterConfigEnableMacos()).called(1);
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
      verify(() => melosBootstrap(cwd: outputDir)).called(1);
      verify(() => progress.complete()).called(2);
      verify(() => logger.alert('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --web', () async {
      // Arrange
      when(() => argResults['web']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled()).called(1);
      verify(() => logger.progress('Running "flutter config --enable-web"'))
          .called(1);
      verify(() => flutterConfigEnableWeb()).called(1);
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
      verify(() => melosBootstrap(cwd: outputDir)).called(1);
      verify(() => progress.complete()).called(2);
      verify(() => logger.alert('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --windows', () async {
      // Arrange
      when(() => argResults['windows']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled()).called(1);
      verify(() => logger.progress(
          'Running "flutter config --enable-windows-desktop"')).called(1);
      verify(() => flutterConfigEnableWindows()).called(1);
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
      verify(() => melosBootstrap(cwd: outputDir)).called(1);
      verify(() => progress.complete()).called(2);
      verify(() => logger.alert('Created a Rapid App!')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    group('org-name', () {
      group('--org', () {
        test(
          'is a valid alias',
          withRunner((commandRunner, logger, project, printLogs) async {
            // Arrange
            const orgName = 'com.my.org';

            // Act
            final result = await commandRunner.run(
              [
                'create',
                p.join(outputDir, 'foo'),
                '--org',
                orgName,
              ],
            );

            // Assert
            expect(result, equals(ExitCode.success.code));
          }),
          timeout: const Timeout(Duration(seconds: 120)),
        );
      });

      group('invalid --org-name', () {
        String expectedErrorMessage(String orgName) =>
            '"$orgName" is not a valid org name.\n\n'
            'A valid org name has at least 2 parts separated by "."\n'
            'Each part must start with a letter and only include '
            'alphanumeric characters (A-Z, a-z, 0-9), underscores (_), '
            'and hyphens (-)\n'
            '(ex. com.example)';

        test(
          'no delimiters',
          withRunner((commandRunner, logger, project, printLogs) async {
            // Arrange
            const orgName = 'My App';

            // Act
            final result = await commandRunner.run(
              ['create', p.join(outputDir, 'foo'), '--org-name', orgName],
            );

            // Assert
            expect(result, equals(ExitCode.usage.code));
            verify(() => logger.err(expectedErrorMessage(orgName))).called(1);
          }),
        );

        test(
          'less than 2 domains',
          withRunner((commandRunner, logger, project, printLogs) async {
            // Arrange
            const orgName = 'badorgname';

            // Act
            final result = await commandRunner.run(
              ['create', p.join(outputDir, 'foo'), '--org-name', orgName],
            );

            // Assert
            expect(result, equals(ExitCode.usage.code));
            verify(() => logger.err(expectedErrorMessage(orgName))).called(1);
          }),
        );

        test(
          'invalid characters present',
          withRunner((commandRunner, logger, project, printLogs) async {
            // Arrange
            const orgName = 'bad%.org@.#name';

            // Act
            final result = await commandRunner.run(
              ['create', p.join(outputDir, 'foo'), '--org-name', orgName],
            );

            // Assert
            expect(result, equals(ExitCode.usage.code));
            verify(() => logger.err(expectedErrorMessage(orgName))).called(1);
          }),
        );

        test(
          'segment starts with a non-letter',
          withRunner((commandRunner, logger, project, printLogs) async {
            // Arrange
            const orgName = 'bad.org.1name';

            // Act
            final result = await commandRunner.run(
              ['create', p.join(outputDir, 'foo'), '--org-name', orgName],
            );

            // Assert
            expect(result, equals(ExitCode.usage.code));
            verify(() => logger.err(expectedErrorMessage(orgName))).called(1);
          }),
        );

        test(
          'valid prefix but invalid suffix',
          withRunner((commandRunner, logger, project, printLogs) async {
            // Arrange
            const orgName = 'some.good.prefix.bad@@suffix';

            // Act
            final result = await commandRunner.run(
              ['create', p.join(outputDir, 'foo'), '--org-name', orgName],
            );

            // Assert
            expect(result, equals(ExitCode.usage.code));
            verify(() => logger.err(expectedErrorMessage(orgName))).called(1);
          }),
        );
      });

      group('valid --org-name', () {
        Future<void> expectValidOrgName(String orgName) async {
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
              },
              logger: logger,
            ),
          ).called(1);
        }

        test('alphanumeric with three parts', () async {
          await expectValidOrgName('com.example.app');
        });

        test('containing an underscore', () async {
          await expectValidOrgName('com.example.bad_app');
        });

        test('containing a hyphen', () async {
          await expectValidOrgName('com.example.bad-app');
        });

        test('single character parts', () async {
          await expectValidOrgName('c.e.a');
        });

        test('more than three parts', () async {
          await expectValidOrgName('com.example.app.identifier');
        });

        test('less than three parts', () async {
          await expectValidOrgName('com.example');
        });
      });
    });
  });
}
