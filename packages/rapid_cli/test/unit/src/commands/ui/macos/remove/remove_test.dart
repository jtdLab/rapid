import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/macos/remove/remove.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../../../helpers/helpers.dart';
import '../../../../mocks.dart';

const expectedUsage = [
  'Remove components from the macOS UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui macos remove <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  widget   Remove a widget from the macOS UI part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('ui macos remove', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['ui', 'macos', 'remove', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['ui', 'macos', 'remove', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = UiMacosRemoveCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
