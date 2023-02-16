import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/android.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

const expectedUsage = [
  'Work with the Android part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid android <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  add       Add features or languages to the Android part of an existing Rapid project.\n'
      '  feature   Work with features of the Android part of an existing Rapid project.\n'
      '  remove    Removes features or languages from the Android part of an existing Rapid project.\n'
      '  set       Set properties of features from the Android part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('android', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test('a is a valid alias', () {
      // Arrange
      final command = AndroidCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('a'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['android', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['android', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = AndroidCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
