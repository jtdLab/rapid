import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/infrastructure/infrastructure.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';

const expectedUsage = [
  'Work with the UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  android   Work with the Android UI part of an existing Rapid project.\n'
      '  ios       Work with the iOS UI part of an existing Rapid project.\n'
      '  linux     Work with the Linux UI part of an existing Rapid project.\n'
      '  macos     Work with the macOS UI part of an existing Rapid project.\n'
      '  web       Work with the Web UI part of an existing Rapid project.\n'
      '  windows   Work with the Windows UI part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockProject extends Mock implements Project {}

void main() {
  group('ui', () {
    late Project project;

    setUp(() {
      project = _MockProject();
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['ui', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['ui', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = InfrastructureCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
