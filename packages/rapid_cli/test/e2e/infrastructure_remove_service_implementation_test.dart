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
        'infrastructure sub_infrastructure remove service_implementation',
        () async {
          // Arrange
          await setupProject();
          final name = 'Fake';
          final serviceName = 'FooBar';
          final outputDir = 'foo';
          serviceImplementationFiles(name: name, serviceName: serviceName)
              .create();
          serviceImplementationFiles(
            name: name,
            serviceName: serviceName,
            outputDir: outputDir,
          ).create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'infrastructure',
              'sub_infrastructure',
              'remove',
              'service_implementation',
              name,
              '--service',
              serviceName,
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
            infrastructurePackage(),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
