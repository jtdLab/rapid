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
        Directory.current = getTempDir();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'domain remove service_interface (fast)',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          final dir = 'foo';
          serviceInterfaceFiles(name: name).create();
          serviceInterfaceFiles(name: name, outputDir: dir).create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'remove', 'service_interface', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'remove', 'service_interface', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...serviceInterfaceFiles(name: name),
            ...serviceInterfaceFiles(name: name, outputDir: dir),
          });
        },
        tags: ['fast'],
      );

      test(
        'domain remove service_interface',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          final dir = 'foo';
          serviceInterfaceFiles(name: name).create();
          serviceInterfaceFiles(name: name, outputDir: dir).create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'remove', 'service_interface', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'remove', 'service_interface', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...serviceInterfaceFiles(name: name),
            ...serviceInterfaceFiles(name: name, outputDir: dir),
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
