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
        'domain remove value_object (fast)',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          final dir = 'foo';
          valueObjectFiles(name: name).create();
          valueObjectFiles(name: name, outputDir: dir).create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'remove', 'value_object', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'remove', 'value_object', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...valueObjectFiles(name: name),
            ...valueObjectFiles(name: name, outputDir: dir),
          });
        },
        tags: ['fast'],
      );

      test(
        'domain remove value_object',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          final dir = 'foo';
          valueObjectFiles(name: name).create();
          valueObjectFiles(name: name, outputDir: dir).create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'remove', 'value_object', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'remove', 'value_object', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...valueObjectFiles(name: name),
            ...valueObjectFiles(name: name, outputDir: dir),
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
