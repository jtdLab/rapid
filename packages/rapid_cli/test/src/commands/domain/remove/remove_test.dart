import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/domain/remove/remove.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../../helpers/helpers.dart';
import '../../../mocks.dart';

const expectedUsage = [
  'Remove a component from the domain part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid domain remove <component>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  entity              Remove an entity from the domain part of an existing Rapid project.\n'
      '  service_interface   Remove a service interface from the domain part of an existing Rapid project.\n'
      '  value_object        Remove a value object from the domain part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('domain remove', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['domain', 'remove', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['domain', 'remove', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = DomainRemoveCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
