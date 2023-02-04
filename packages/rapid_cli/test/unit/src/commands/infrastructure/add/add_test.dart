import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/infrastructure/add/add.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../../helpers/helpers.dart';
import '../../../mocks.dart';

const expectedUsage = [
  'Add a component to the infrastructure part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid infrastructure add <component>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  data_transfer_object     Add a data transfer object to the infrastructure part of an existing Rapid project.\n'
      '  service_implementation   Add a service implementation to the infrastructure part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('infrastructure add', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['infrastructure', 'add', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['infrastructure', 'add', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = InfrastructureAddCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
