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
        'infrastructure sub_infrastructure add service_implementation',
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
              'sub_infrastructure',
              'add',
              'service_implementation',
              name,
              '--service',
              service,
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
          await verifyHasAnalyzerIssues(2);
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

          await verifyTestsPass(infrastructurePackage(), expectedCoverage: 100);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
