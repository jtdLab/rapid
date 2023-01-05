import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/macos/macos.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';

const expectedUsage = [
  'Work with the macOS part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid macos <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  add       Add features or languages to the macOS part of an existing Rapid project.\n'
      '  feature   Work with features of the macOS part of an existing Rapid project.\n'
      '  remove    Removes features or languages from the macOS part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockProject extends Mock implements Project {}

void main() {
  group('macos', () {
    late Project project;

    setUp(() {
      project = _MockProject();
    });

    test('m is a valid alias', () {
      // Arrange
      final command = MacosCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('m'));
    });

    test('mac is a valid alias', () {
      // Arrange
      final command = MacosCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('mac'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['macos', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['macos', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = MacosCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
