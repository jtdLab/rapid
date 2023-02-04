import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/web/web.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';
import '../../mocks.dart';

const expectedUsage = [
  'Work with the Web part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid web <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  add       Add features or languages to the Web part of an existing Rapid project.\n'
      '  feature   Work with features of the Web part of an existing Rapid project.\n'
      '  remove    Removes features or languages from the Web part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('web', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['web', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['web', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = WebCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
