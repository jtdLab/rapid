import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/deactivate/deactivate.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

const expectedUsage = [
  'Remove support for a platform from an existing Rapid project.\n'
      '\n'
      'Usage: rapid deactivate <platform>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  android   Removes support for Android from this project.\n'
      '  ios       Removes support for iOS from this project.\n'
      '  linux     Removes support for Linux from this project.\n'
      '  macos     Removes support for macOS from this project.\n'
      '  web       Removes support for Web from this project.\n'
      '  windows   Removes support for Windows from this project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('deactivate', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['deactivate', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['deactivate', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = DeactivateCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
