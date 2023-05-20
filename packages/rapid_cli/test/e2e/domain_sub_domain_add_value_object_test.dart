@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';

import 'common.dart';

// TODO test sub-domain

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() async {
        Directory.current = getTempDir();

        await setupProject();
        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'domain <sub_domain> add value_object',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';

          // Act
          final commandResult = await commandRunner.run([
            'domain',
            'default',
            'add',
            'value_object',
            name,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyHasAnalyzerIssues(3);
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
            ...valueObjectFiles(name: name),
          });
        },
      );

      test(
        'domain <sub_domain> add value_object (with output dir)',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          final outputDir = 'foo';

          // Act
          final commandResult = await commandRunner.run([
            'domain',
            'default',
            'add',
            'value_object',
            name,
            '--output-dir',
            outputDir
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyHasAnalyzerIssues(3);
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
            ...valueObjectFiles(name: name, outputDir: outputDir),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
