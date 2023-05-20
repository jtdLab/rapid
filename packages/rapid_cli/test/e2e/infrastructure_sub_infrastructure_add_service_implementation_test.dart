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

      setUp(() async {
        Directory.current = getTempDir();

        await setupProject();
        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'infrastructure <sub_infrastructure> add service_implementation',
        () async {
          // Arrange
          await setupProject();
          final name = 'Fake';
          final service = 'FooBar';
          await commandRunner.run([
            'domain',
            'default',
            'add',
            'service_interface',
            service,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'infrastructure',
            'default',
            'add',
            'service_implementation',
            name,
            '--service',
            service,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
            ...serviceImplementationFiles(
              name: name,
              serviceName: service,
            ),
          });
          await verifyTestsPass(infrastructurePackage(), expectedCoverage: 0);
        },
      );

      test(
        'infrastructure <sub_infrastructure> add service_implementation (with output dir)',
        () async {
          // Arrange
          await setupProject();
          final name = 'Fake';
          final service = 'FooBar';
          final outputDir = 'foo';
          await commandRunner.run([
            'domain',
            'default',
            'add',
            'service_interface',
            service,
            '--output-dir',
            outputDir,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'infrastructure',
            'default',
            'add',
            'service_implementation',
            name,
            '--service',
            service,
            '--output-dir',
            outputDir
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
            ...serviceImplementationFiles(
              name: name,
              serviceName: service,
              outputDir: outputDir,
            ),
          });
          await verifyTestsPass(infrastructurePackage(), expectedCoverage: 0);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
