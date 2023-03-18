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
        'deactivate macos',
        () async {
          // Arrange
          await setupProject(Platform.macos);

          // Act
          final commandResult = await commandRunner.run(
            ['deactivate', 'macos'],
          );

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
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
