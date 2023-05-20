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
        'infrastructure <sub_infrastructure> remove service_implementation',
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
          await commandRunner.run([
            'infrastructure',
            'default',
            'add',
            'service_implementation',
            name,
            '--service',
            service,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'infrastructure',
            'default',
            'remove',
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
          });
          verifyDoNotExist({
            ...serviceImplementationFiles(name: name, serviceName: service),
          });
          verifyDoNotHaveTests({
            infrastructurePackage(),
          });
        },
      );

      test(
        'infrastructure <sub_infrastructure> remove service_implementation (with output dir)',
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
            '-o',
            outputDir,
          ]);
          await commandRunner.run([
            'infrastructure',
            'default',
            'add',
            'service_implementation',
            name,
            '--service',
            service,
            '-o',
            outputDir,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'infrastructure',
            'default',
            'remove',
            'service_implementation',
            name,
            '--service',
            service,
            '--dir',
            outputDir
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...serviceImplementationFiles(
              name: name,
              serviceName: service,
              outputDir: outputDir,
            ),
          });
          verifyDoNotHaveTests({
            infrastructurePackage(),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
