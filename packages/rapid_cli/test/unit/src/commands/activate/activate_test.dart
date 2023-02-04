import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/activate/activate.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';
import '../../mocks.dart';

const expectedUsage = [
  'Add support for a platform to an existing Rapid project.\n'
      '\n'
      'Usage: rapid activate <platform>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  android   Adds support for Android to this project.\n'
      '  ios       Adds support for iOS to this project.\n'
      '  linux     Adds support for Linux to this project.\n'
      '  macos     Adds support for macOS to this project.\n'
      '  web       Adds support for Web to this project.\n'
      '  windows   Adds support for Windows to this project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('activate', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['activate', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['activate', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = ActivateCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
