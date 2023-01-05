import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/linux/remove/remove.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../../helpers/helpers.dart';

const expectedUsage = [
  'Removes features or languages from the Linux part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid linux remove <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  feature    Removes a feature from the Linux part of an existing Rapid project.\n'
      '  language   Removes a language from the Linux part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockProject extends Mock implements Project {}

void main() {
  group('linux remove', () {
    late Project project;

    setUp(() {
      project = _MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['linux', 'remove', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['linux', 'remove', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = LinuxRemoveCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
