@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/e2e_helper.dart';

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
        'infrastructure add data_transfer_object (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          final entity = 'FooBar';
          final outputDir = 'foo';
          await addEntity(name: entity);
          await addEntity(name: entity, outputDir: outputDir);

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'infrastructure',
              'add',
              'data_transfer_object',
              '--entity',
              entity,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
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
        },
        tags: ['fast'],
      );

      test(
        'infrastructure add data_transfer_object',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          final entity = 'FooBar';
          final outputDir = 'foo';
          await addEntity(name: entity);
          await addEntity(name: entity, outputDir: outputDir);

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'infrastructure',
              'add',
              'data_transfer_object',
              '--entity',
              entity,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
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
            infrastructurePackage,
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
