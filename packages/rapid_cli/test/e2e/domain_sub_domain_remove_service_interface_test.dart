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
        'domain sub_domain remove service_interface',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          await commandRunner.run([
            'domain',
            'sub_domain',
            'add',
            'service_interface',
            name,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'domain',
            'sub_domain',
            'remove',
            'service_interface',
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
            ...serviceInterfaceFiles(name: name),
          });
          verifyDoNotHaveTests({
            domainPackage(),
          });
        },
      );

      test(
        'domain sub_domain remove service_interface (with output dir)',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          final dir = 'foo';
          await commandRunner.run([
            'domain',
            'sub_domain',
            'add',
            'service_interface',
            name,
            '--output-dir',
            dir,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'domain',
            'sub_domain',
            'remove',
            'service_interface',
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
            ...serviceInterfaceFiles(name: name, outputDir: dir),
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
