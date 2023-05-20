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
        'domain <sub_domain> add service_interface',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';

          // Act
          final commandResult = await commandRunner.run([
            'domain',
            'default',
            'add',
            'service_interface',
            name,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
            ...serviceInterfaceFiles(name: name),
          });
          verifyDoNotHaveTests({
            domainPackage(),
          });
        },
      );

      test(
        'domain <sub_domain> add service_interface (with output dir)',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          final outputDir = 'foo';

          // Act
          final commandResult = await commandRunner.run([
            'domain',
            'default',
            'add',
            'service_interface',
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
            ...serviceInterfaceFiles(name: name, outputDir: outputDir),
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
