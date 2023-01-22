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
        'infrastructure remove service_implementation (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          final entityName = 'FooBar';
          final name = '${entityName}Dto';

          final outputDir = 'foo';
          serviceImplementationFiles(entity: entityName).create();
          serviceImplementationFiles(entity: entityName, outputDir: outputDir)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['infrastructure', 'remove', 'service_implementation', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
              'remove',
              'service_implementation',
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
            ...serviceImplementationFiles(entity: entityName),
            ...serviceImplementationFiles(
                entity: entityName, outputDir: outputDir),
          });
        },
        tags: ['fast'],
      );

      test(
        'infrastructure remove service_implementation',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          final entityName = 'FooBar';
          final name = '${entityName}Dto';

          final outputDir = 'foo';
          serviceImplementationFiles(entity: entityName).create();
          serviceImplementationFiles(entity: entityName, outputDir: outputDir)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['infrastructure', 'remove', 'service_implementation', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
              'remove',
              'service_implementation',
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
            ...serviceImplementationFiles(entity: entityName),
            ...serviceImplementationFiles(
                entity: entityName, outputDir: outputDir),
          });

          // TODO tests ?
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
