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
        'infrastructure sub_infrastructure remove data_transfer_object',
        () async {
          // Arrange
          await setupProject();
          final entityName = 'FooBar';
          final outputDir = 'foo';
          dataTransferObjectFiles(entity: entityName).create();
          dataTransferObjectFiles(entity: entityName, outputDir: outputDir)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'infrastructure',
              'sub_infrastructure',
              'remove',
              'data_transfer_object',
              '--entity',
              entityName
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          // TODO test sub-infrastructure
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
              'sub_infrastructure',
              'remove',
              'data_transfer_object',
              '--entity',
              entityName,
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
            infrastructurePackage(),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
