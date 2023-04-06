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
        'infrastructure sub_infrastructure add data_transfer_object',
        () async {
          // Arrange
          await setupProject();
          final entity = 'FooBar';
          final outputDir = 'foo';
          await addEntity();
          await addEntity(outputDir: outputDir);

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'infrastructure',
              'sub_infrastructure',
              'add',
              'data_transfer_object',
              '--entity',
              entity,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          // TODO test sub-infrastructure
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
              'sub_infrastructure',
              'add',
              'data_transfer_object',
              '--entity',
              entity,
              '--output-dir',
              outputDir
            ],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...dataTransferObjectFiles(entity: entity),
            ...dataTransferObjectFiles(entity: entity, outputDir: outputDir),
          });

          await verifyTestsPassWith100PercentCoverage({
            infrastructurePackage(),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
