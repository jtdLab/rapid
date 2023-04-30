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

      setUp(() {
        Directory.current = getTempDir();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'infrastructure sub_infrastructure remove data_transfer_object',
        () async {
          // Arrange
          await setupProject();
          final entity = 'FooBar';
          await commandRunner.run([
            'domain',
            'sub_domain',
            'add',
            'entity',
            entity,
          ]);
          await commandRunner.run([
            'infrastructure',
            'sub_infrastructure',
            'add',
            'data_transfer_object',
            '--entity',
            entity,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'infrastructure',
            'sub_infrastructure',
            'remove',
            'data_transfer_object',
            '--entity',
            entity
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...dataTransferObjectFiles(entity: entity),
          });
          verifyDoNotHaveTests({
            infrastructurePackage(),
          });
        },
      );

      test(
        'infrastructure sub_infrastructure remove data_transfer_object (with output dir)',
        () async {
          // Arrange
          await setupProject();
          final entity = 'FooBar';
          final dir = 'foo';
          await commandRunner.run([
            'domain',
            'sub_domain',
            'add',
            'entity',
            entity,
            '--output-dir',
            dir,
          ]);
          await commandRunner.run([
            'infrastructure',
            'sub_infrastructure',
            'add',
            'data_transfer_object',
            '--entity',
            entity,
            '--output-dir',
            dir,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'infrastructure',
            'sub_infrastructure',
            'remove',
            'data_transfer_object',
            '--entity',
            entity,
            '--dir',
            dir
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...dataTransferObjectFiles(entity: entity, outputDir: dir),
          });
          verifyDoNotHaveTests({
            infrastructurePackage(),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
