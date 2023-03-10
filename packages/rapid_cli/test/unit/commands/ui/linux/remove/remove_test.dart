import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/linux/remove/remove.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

const expectedUsage = [
  'Remove components from the Linux UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui linux remove <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  widget   Remove a widget from the Linux UI part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('ui linux remove', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['ui', 'linux', 'remove', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['ui', 'linux', 'remove', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = UiLinuxRemoveCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
