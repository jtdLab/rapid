@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';

import 'common.dart';

// TODO test sub-domain

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
        'domain sub_domain remove value_object',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          await commandRunner.run([
            'domain',
            'sub_domain',
            'add',
            'value_object',
            name,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'domain',
            'sub_domain',
            'remove',
            'value_object',
            name,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...valueObjectFiles(name: name),
          });
          verifyDoNotHaveTests({
            domainPackage(),
          });
        },
      );

      test(
        'domain sub_domain remove value_object (with output dir)',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          final dir = 'foo';
          await commandRunner.run([
            'domain',
            'sub_domain',
            'add',
            'value_object',
            name,
            '--output-dir',
            dir,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'domain',
            'sub_domain',
            'remove',
            'value_object',
            name,
            '--dir',
            dir
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...valueObjectFiles(name: name, outputDir: dir),
          });
          verifyDoNotHaveTests({
            domainPackage(),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
