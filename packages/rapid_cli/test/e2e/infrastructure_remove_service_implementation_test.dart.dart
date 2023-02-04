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
        'infrastructure remove service_implementation (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();
          final name = 'Fake';
          final serviceName = 'FooBar';
          final outputDir = 'foo';
          serviceImplementationFiles(name: name, serviceName: serviceName)
              .create();
          serviceImplementationFiles(
                  name: name, serviceName: serviceName, outputDir: outputDir)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'infrastructure',
              'remove',
              'service_implementation',
              name,
              '--service',
              serviceName,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
              'remove',
              'service_implementation',
              name,
              '--service',
              serviceName,
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
            ...serviceImplementationFiles(name: name, serviceName: serviceName),
            ...serviceImplementationFiles(
                name: name, serviceName: serviceName, outputDir: outputDir),
          });
        },
        tags: ['fast'],
      );

      test(
        'infrastructure remove service_implementation',
        () async {
          // Arrange
          await setupProjectNoPlatforms();
          final name = 'Fake';
          final serviceName = 'FooBar';
          final outputDir = 'foo';
          serviceImplementationFiles(name: name, serviceName: serviceName)
              .create();
          serviceImplementationFiles(
                  name: name, serviceName: serviceName, outputDir: outputDir)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'infrastructure',
              'remove',
              'service_implementation',
              name,
              '--service',
              serviceName,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
              'remove',
              'service_implementation',
              name,
              '--service',
              serviceName,
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
            ...serviceImplementationFiles(name: name, serviceName: serviceName),
            ...serviceImplementationFiles(
                name: name, serviceName: serviceName, outputDir: outputDir),
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
