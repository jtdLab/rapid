import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/ui/web/remove/remove.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Remove components from the Web UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui web remove <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  widget   Remove a widget from the Web UI part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockProject extends Mock implements Project {}

void main() {
  group('ui web remove', () {
    late Project project;

    setUp(() {
      project = _MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['ui', 'web', 'remove', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['ui', 'web', 'remove', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = UiWebRemoveCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}