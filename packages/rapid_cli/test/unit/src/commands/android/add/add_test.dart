import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/add/add.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../../helpers/helpers.dart';
import '../../../mocks.dart';

const expectedUsage = [
  'Add features or languages to the Android part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid android add <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  feature    Adds a feature to the Android part of an existing Rapid project.\n'
      '  language   Adds a language to the Android part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('android add', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['android', 'add', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['android', 'add', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = AndroidAddCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
