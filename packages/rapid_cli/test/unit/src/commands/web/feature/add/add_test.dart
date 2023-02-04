import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/web/feature/add/add.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../../../helpers/helpers.dart';
import '../../../../mocks.dart';

const expectedUsage = [
  'Add components to features of the Web part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid web feature add <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  bloc    Adds a bloc to a feature of the Web part of an existing Rapid project.\n'
      '  cubit   Adds a cubit to a feature of the Web part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('web feature add', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['web', 'feature', 'add', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['web', 'feature', 'add', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = WebFeatureAddCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
