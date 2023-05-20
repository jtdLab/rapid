@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';

import 'common.dart';

// TODO test sub-infrastructure

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
        'infrastructure <sub_infrastructure> add data_transfer_object',
        () async {
          // Arrange
          await setupProject();
          final entity = 'FooBar';
          await commandRunner.run([
            'domain',
            'default',
            'add',
            'entity',
            entity,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'infrastructure',
            'default',
            'add',
            'data_transfer_object',
            '--entity',
            entity,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
            ...dataTransferObjectFiles(entity: entity),
          });
          await verifyTestsPassWith100PercentCoverage({
            infrastructurePackage(),
          });
        },
      );

      test(
        'infrastructure <sub_infrastructure> add data_transfer_object (with output dir)',
        () async {
          // Arrange
          await setupProject();
          final entity = 'FooBar';
          final outputDir = 'foo';
          await commandRunner.run([
            'domain',
            'default',
            'add',
            'entity',
            entity,
            '--output-dir',
            outputDir,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'infrastructure',
            'default',
            'add',
            'data_transfer_object',
            '--entity',
            entity,
            '--output-dir',
            outputDir
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
            ...dataTransferObjectFiles(entity: entity, outputDir: outputDir),
          });
          await verifyTestsPassWith100PercentCoverage({
            infrastructurePackage(),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
