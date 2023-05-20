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
        'domain <sub_domain> remove entity',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          await commandRunner.run([
            'domain',
            'default',
            'add',
            'entity',
            name,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'domain',
            'default',
            'remove',
            'entity',
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
            ...entityFiles(name: name),
          });
          verifyDoNotHaveTests({
            domainPackage(),
          });
        },
      );

      test(
        'domain <sub_domain> remove entity (with output dir)',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          final dir = 'foo';
          await commandRunner.run([
            'domain',
            'default',
            'add',
            'entity',
            name,
            '--output-dir',
            dir
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'domain',
            'default',
            'remove',
            'entity',
            name,
            '--dir',
            dir,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...entityFiles(name: name, outputDir: dir),
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
