@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';
import 'dart:io';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() {
        Directory.current = Directory.systemTemp.createTempSync();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'infrastructure remove data_transfer_object (fast)',
        () async {
          // Arrange
          await setupProject();
          final entityName = 'FooBar';
          final name = '${entityName}Dto';
          final outputDir = 'foo';
          dataTransferObjectFiles(entity: entityName).create();
          dataTransferObjectFiles(entity: entityName, outputDir: outputDir)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['infrastructure', 'remove', 'data_transfer_object', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
              'remove',
              'data_transfer_object',
              name,
              '--dir',
              outputDir
            ],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...dataTransferObjectFiles(entity: entityName),
            ...dataTransferObjectFiles(
                entity: entityName, outputDir: outputDir),
          });
        },
        tags: ['fast'],
      );

      test(
        'infrastructure remove data_transfer_object',
        () async {
          // Arrange
          await setupProject();
          final entityName = 'FooBar';
          final name = '${entityName}Dto';
          final outputDir = 'foo';
          dataTransferObjectFiles(entity: entityName).create();
          dataTransferObjectFiles(entity: entityName, outputDir: outputDir)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['infrastructure', 'remove', 'data_transfer_object', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
              'remove',
              'data_transfer_object',
              name,
              '--dir',
              outputDir
            ],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...dataTransferObjectFiles(entity: entityName),
            ...dataTransferObjectFiles(
                entity: entityName, outputDir: outputDir),
          });

          verifyDoNotHaveTests({
            infrastructurePackage,
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
