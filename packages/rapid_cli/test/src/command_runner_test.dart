import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/version.dart';
import 'package:test/test.dart';

class MockLogger extends Mock implements Logger {}

class MockMelosFile extends Mock implements MelosFile {}

class MockProject extends Mock implements Project {}

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Rapid Command Line Interface\n'
      '\n'
      'Usage: rapid <command>\n'
      '\n'
      'Global options:\n'
      '-h, --help       Print this usage information.\n'
      '-v, --version    Print the current version.\n'
      '\n'
      'Available commands:\n'
      '  activate     Adds support for a platform to an existing Rapid project.\n'
      '  android      Work with the Android part of an existing Rapid project.\n'
      '  create       Creates a new Rapid project in the specified directory.\n'
      '  deactivate   Removes support for a platform from an existing Rapid project.\n'
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
      logger = MockLogger();
      melosFile = MockMelosFile();
      when(() => melosFile.name()).thenReturn(projectName);
      project = MockProject();
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
    });
  });
}
