@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
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
        'deactivate windows',
        () async {
          // Arrange
          await setupProject(Platform.windows);

          // Act
          final commandResult = await commandRunner.run([
            'deactivate',
            'windows',
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist(allPlatformDependentPackages);
          verifyDoNotHaveTests(platformIndependentPackagesWithoutTests);
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackagesWithTests,
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
