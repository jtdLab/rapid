@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() {
        Directory.current = getTempDir();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'domain sub_domain add value_object',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'sub_domain', 'add', 'value_object', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final outputDir = 'foo';
          // TODO test sub-domain
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'domain',
              'sub_domain',
              'add',
              'value_object',
              name,
              '--output-dir',
              outputDir
            ],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyHasAnalyzerIssues(6);
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...valueObjectFiles(name: name),
            ...valueObjectFiles(name: name, outputDir: outputDir),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
