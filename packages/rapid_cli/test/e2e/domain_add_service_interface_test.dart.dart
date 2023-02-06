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
        'domain add service_interface (fast)',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'add', 'service_interface', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final outputDir = 'foo';
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'domain',
              'add',
              'service_interface',
              name,
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
            ...serviceInterfaceFiles(name: name),
            ...serviceInterfaceFiles(name: name, outputDir: outputDir),
          });
        },
        tags: ['fast'],
      );

      test(
        'domain add service_interface',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'add', 'service_interface', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final outputDir = 'foo';
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'domain',
              'add',
              'service_interface',
              name,
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
            ...serviceInterfaceFiles(name: name),
            ...serviceInterfaceFiles(name: name, outputDir: outputDir),
          });

          verifyDoNotHaveTests({
            domainPackage,
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
