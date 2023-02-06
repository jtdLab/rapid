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
        'infrastructure add service_implementation (fast)',
        () async {
          // Arrange
          await setupProject();
          final name = 'Fake';
          final service = 'FooBar';
          final outputDir = 'foo';
          await addServiceInterface();
          await addServiceInterface(outputDir: outputDir);

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'infrastructure',
              'add',
              'service_implementation',
              name,
              '--service',
              service,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
              'add',
              'service_implementation',
              name,
              '--service',
              service,
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
            ...serviceImplementationFiles(
              name: name,
              serviceName: service,
            ),
            ...serviceImplementationFiles(
              name: name,
              serviceName: service,
              outputDir: outputDir,
            ),
          });
        },
        tags: ['fast'],
      );

      test(
        'infrastructure add service_implementation',
        () async {
          // Arrange
          await setupProject();
          final name = 'Fake';
          final service = 'FooBar';
          final outputDir = 'foo';
          await addServiceInterface();
          await addServiceInterface(outputDir: outputDir);

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'infrastructure',
              'add',
              'service_implementation',
              name,
              '--service',
              service,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
              'add',
              'service_implementation',
              name,
              '--service',
              service,
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
            ...serviceImplementationFiles(
              name: name,
              serviceName: service,
            ),
            ...serviceImplementationFiles(
              name: name,
              serviceName: service,
              outputDir: outputDir,
            ),
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
