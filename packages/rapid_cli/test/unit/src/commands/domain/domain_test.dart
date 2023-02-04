import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/domain/domain.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';
import '../../mocks.dart';

const expectedUsage = [
  'Work with the domain part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid domain <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  add      Add a component to the domain part of an existing Rapid project.\n'
      '  remove   Remove a component from the domain part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('domain', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['domain', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['domain', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = DomainCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
