import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/linux/linux.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/helpers.dart';

const expectedUsage = [
  'Adds support for Linux to this project.\n'
      '\n'
      'Usage: rapid activate linux\n'
      '-h, --help        Print this usage information.\n'
      '    --org-name    The organization for the native Linux project.\n'
      '                  (defaults to "com.example")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class _FlutterConfigEnablePlatformCommand {
  Future<void> call({required Logger logger});
}

class _MockLogger extends Mock implements Logger {}

class _MockProject extends Mock implements Project {}

class MockFlutterConfigEnablePlatformCommand extends Mock
    implements _FlutterConfigEnablePlatformCommand {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('activate linux', () {
    final cwd = Directory.current;

    late Logger logger;

    late Project project;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableLinux;

    late ArgResults argResults;
    late String? orgName;

    late ActivateLinuxCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();

      project = _MockProject();
      when(
        () => project.addPlatform(
          Platform.linux,
          description: any(named: 'description'),
          orgName: any(named: 'orgName'),
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => project.exists()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(false);

      flutterConfigEnableLinux = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableLinux(logger: logger))
          .thenAnswer((_) async {});

      argResults = _MockArgResults();

      command = ActivateLinuxCommand(
        logger: logger,
        project: project,
        flutterConfigEnableLinux: flutterConfigEnableLinux,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('l is a valid alias', () {
      // Act
      final command = ActivateLinuxCommand(project: project);

      // Assert
      expect(command.aliases, contains('l'));
    });

    test('lin is a valid alias', () {
      // Act
      final command = ActivateLinuxCommand(project: project);

      // Assert
      expect(command.aliases, contains('lin'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(['activate', 'linux', '--help']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(['activate', 'linux', '-h']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = ActivateLinuxCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verifyNever(() => logger.err('Linux is already activated.'));
      verify(() => logger.info('Activating Linux ...')).called(1);
      verify(() => flutterConfigEnableLinux(logger: logger)).called(1);
      verify(
        () => project.addPlatform(
          Platform.linux,
          orgName: 'com.example',
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Linux activated!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output w/ custom org-name',
        () async {
      // Arrange
      orgName = 'custom.org.name';
      when(() => argResults['org-name']).thenReturn(orgName);

      // Act
      final result = await command.run();

      // Assert
      verifyNever(() => logger.err('Linux is already activated.'));
      verify(() => logger.info('Activating Linux ...')).called(1);
      verify(() => flutterConfigEnableLinux(logger: logger)).called(1);
      verify(
        () => project.addPlatform(
          Platform.linux,
          orgName: orgName,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Linux activated!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 66 when project does not exist', () async {
      // Arrange
      when(() => project.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'This command should be run from the root of an existing Rapid project.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.noInput.code);
    });

    test('exits with 78 when Linux is already activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Linux is already activated.')).called(1);
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
                () => project.addPlatform(
                  Platform.linux,
                  orgName: orgName,
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
