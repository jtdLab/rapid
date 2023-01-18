import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/version.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockProject extends Mock implements Project {}

const expectedUsage = [
  'Rapid Command Line Interface\n'
      '\n'
      'Usage: rapid <command>\n'
      '\n'
      'Global options:\n'
      '-h, --help       Print this usage information.\n'
      '-v, --version    Print the current version.\n'
      '    --verbose    Enable verbose logging.\n'
      '\n'
      'Available commands:\n'
      '  activate         Add support for a platform to an existing Rapid project.\n'
      '  android          Work with the Android part of an existing Rapid project.\n'
      '  create           Create a new Rapid project.\n'
      '  deactivate       Remove support for a platform from an existing Rapid project.\n'
      '  doctor           Show information about an existing Rapid project.\n'
      '  domain           Work with the domain part of an existing Rapid project.\n'
      '  infrastructure   Work with the infrastructure part of an existing Rapid project.\n'
      '  ios              Work with the iOS part of an existing Rapid project.\n'
      '  linux            Work with the Linux part of an existing Rapid project.\n'
      '  macos            Work with the macOS part of an existing Rapid project.\n'
      '  ui               Work with the UI part of an existing Rapid project.\n'
      '  web              Work with the Web part of an existing Rapid project.\n'
      '  windows          Work with the Windows part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help <command>" for more information about a command.'
];

void main() {
  group('RapidCommandRunner', () {
    late List<String> printLogs;
    late Logger logger;
    late MelosFile melosFile;
    late Project project;

    late RapidCommandRunner commandRunner;

    const projectName = 'test_app';

    void Function() overridePrint(void Function() fn) {
      return () {
        final spec = ZoneSpecification(
          print: (_, __, ___, String msg) {
            printLogs.add(msg);
          },
        );
        return Zone.current.fork(specification: spec).run<void>(fn);
      };
    }

    setUp(() {
      printLogs = [];
      logger = _MockLogger();
      melosFile = _MockMelosFile();
      when(() => melosFile.name()).thenReturn(projectName);
      project = _MockProject();
      when(() => project.melosFile).thenReturn(melosFile);

      commandRunner = RapidCommandRunner(
        logger: logger,
        project: project,
      );
    });

    test('can be instantiated without an explicit logger/project instance', () {
      // Act
      final commandRunner = RapidCommandRunner();

      // Assert
      expect(commandRunner, isNotNull);
    });

    group('run', () {
      test('handles FormatException', () async {
        // Arrange
        const exception = FormatException('oops!');
        var isFirstInvocation = true;
        when(() => logger.info(any())).thenAnswer((_) {
          if (isFirstInvocation) {
            isFirstInvocation = false;
            throw exception;
          }
        });

        // Act
        final result = await commandRunner.run(['--version']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(exception.message)).called(1);
        verify(() => logger.info(commandRunner.usage)).called(1);
      });

      test('handles UsageException', () async {
        // Arrange
        final exception = UsageException('oops!', 'exception usage');
        var isFirstInvocation = true;
        when(() => logger.info(any())).thenAnswer((_) {
          if (isFirstInvocation) {
            isFirstInvocation = false;
            throw exception;
          }
        });

        // Act
        final result = await commandRunner.run(['--version']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(exception.message)).called(1);
        verify(() => logger.info('exception usage')).called(1);
      });

      test(
        'handles no command',
        overridePrint(() async {
          // Act
          final result = await commandRunner.run([]);

          // Assert
          expect(printLogs, equals(expectedUsage));
          expect(result, equals(ExitCode.success.code));
        }),
      );

      group('--help', () {
        test(
          'outputs usage',
          overridePrint(() async {
            // Act
            final result = await commandRunner.run(['--help']);

            // Assert
            expect(printLogs, equals(expectedUsage));
            expect(result, equals(ExitCode.success.code));

            printLogs.clear();

            // Act
            final resultAbbr = await commandRunner.run(['-h']);

            // Assert
            expect(printLogs, equals(expectedUsage));
            expect(resultAbbr, equals(ExitCode.success.code));
          }),
        );
      });

      group('--version', () {
        test('outputs current version', () async {
          // Act
          final result = await commandRunner.run(['--version']);

          // Assert
          expect(result, equals(ExitCode.success.code));
          verify(() => logger.info(packageVersion)).called(1);
        });
      });

      group('--verbose', () {
        test('enables verbose logging', () async {
          final result = await commandRunner.run(['--verbose']);
          expect(result, equals(ExitCode.success.code));

          verify(() => logger.detail('Argument information:')).called(1);
          verify(() => logger.detail('  Top level options:')).called(1);
          verify(() => logger.detail('  - verbose: true')).called(1);
          verifyNever(() => logger.detail('    Command options:'));
        });

        test('enables verbose logging for sub commands', () async {
          final result = await commandRunner.run([
            '--verbose',
            'create',
            '--help',
          ]);
          expect(result, equals(ExitCode.success.code));

          verify(() => logger.detail('Argument information:')).called(1);
          verify(() => logger.detail('  Top level options:')).called(1);
          verify(() => logger.detail('  - verbose: true')).called(1);
          verify(() => logger.detail('  Command: create')).called(1);
          verify(() => logger.detail('    - help: true')).called(1);
        });
      });
    });
  });
}
