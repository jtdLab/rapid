import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/windows/windows.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

const expectedUsage = [
  'Work with the Windows part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid windows <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  add       Add features or languages to the Windows part of an existing Rapid project.\n'
      '  feature   Work with features of the Windows part of an existing Rapid project.\n'
      '  remove    Removes features or languages from the Windows part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('windows', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test('win is a valid alias', () {
      // Arrange
      final command = WindowsCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('win'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['windows', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['windows', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = WindowsCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
