@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
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
        'deactivate windows (fast)',
        () async {
          // Arrange
          await setupProject(Platform.windows);

          // Act
          final commandResult = await commandRunner.run(
            ['deactivate', 'windows'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist(allPlatformDirs);
        },
        tags: ['fast'],
      );

      test(
        'deactivate windows',
        () async {
          // Arrange
          await setupProject(Platform.windows);

          // Act
          final commandResult = await commandRunner.run(
            ['deactivate', 'windows'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist(allPlatformDirs);

          verifyDoNotHaveTests({domainPackage, infrastructurePackage});
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
