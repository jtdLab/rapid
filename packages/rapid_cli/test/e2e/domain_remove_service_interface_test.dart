@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';

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
        'domain sub_domain remove service_interface',
        () async {
          // Arrange
          await setupProject();
          final name = 'FooBar';
          final dir = 'foo';
          serviceInterfaceFiles(name: name).create();
          serviceInterfaceFiles(name: name, outputDir: dir).create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'sub_domain', 'remove', 'service_interface', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          // TODO test sub-domain
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'domain',
              'sub_domain',
              'remove',
              'service_interface',
              name,
              '--dir',
              dir
            ],
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
            domainPackage(),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
