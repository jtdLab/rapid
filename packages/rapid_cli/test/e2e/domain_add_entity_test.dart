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
        'domain add entity',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'add', 'entity', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final outputDir = 'foo';
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'add', 'entity', name, '--output-dir', outputDir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...entityFiles(name: name),
            ...entityFiles(name: name, outputDir: outputDir),
          });

          await verifyTestsPassWith100PercentCoverage({
            domainPackage,
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
