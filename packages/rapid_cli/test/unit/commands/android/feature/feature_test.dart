import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/feature/feature.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';

const expectedUsage = [
  'Work with features of the Android part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid android features <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  add   Add components to features of the Android part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('android feature', () {
    late Project project;

    setUp(() {
      project = MockProject();
    });

    test('feat is a valid alias', () {
      // Arrange
      final command = AndroidFeatureCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('feat'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['android', 'feature', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['android', 'feature', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = AndroidFeatureCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
