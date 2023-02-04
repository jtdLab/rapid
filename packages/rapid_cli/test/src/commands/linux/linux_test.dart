import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/linux/linux.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';
import '../../mocks.dart';

const expectedUsage = [
  'Work with the Linux part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid linux <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  add       Add features or languages to the Linux part of an existing Rapid project.\n'
      '  feature   Work with features of the Linux part of an existing Rapid project.\n'
      '  remove    Removes features or languages from the Linux part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('linux', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test('l is a valid alias', () {
      // Arrange
      final command = LinuxCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('l'));
    });

    test('lin is a valid alias', () {
      // Arrange
      final command = LinuxCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('lin'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['linux', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['linux', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = LinuxCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
