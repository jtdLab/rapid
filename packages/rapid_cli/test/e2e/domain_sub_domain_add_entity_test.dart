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

      setUp(() async {
        Directory.current = getTempDir();

        await setupProject();
        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'domain <sub_domain> add entity',
        () async {
          // Arrange
          final name = 'FooBar';

          // Act + Assert
          final commandResult = await commandRunner.run([
            'domain',
            'default',
            'add',
            'entity',
            name,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
            ...entityFiles(name: name),
          });
          await verifyTestsPassWith100PercentCoverage({
            domainPackage(),
          });
        },
      );

      test(
        'domain <sub_domain> add entity (with output dir)',
        () async {
          // Arrange
          final name = 'FooBar';
          final outputDir = 'foo';

          final commandResult = await commandRunner.run([
            'domain',
            'default',
            'add',
            'entity',
            name,
            '--output-dir',
            outputDir
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
            ...entityFiles(name: name, outputDir: outputDir),
          });
          await verifyTestsPassWith100PercentCoverage({
            domainPackage(),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
