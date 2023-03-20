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
        'linux add feature',
        () async {
          // Arrange
          const featureName = 'my_feature';
          await setupProject(Platform.linux);

          // Act
          final commandResult = await commandRunner.run(
            ['linux', 'add', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final featurePackages = [
            featurePackage('app', Platform.linux),
            featurePackage('home_page', Platform.linux),
            featurePackage(featureName, Platform.linux),
          ];
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.linux]),
            ...featurePackages,
          ]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.linux),
            ...featurePackages,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
