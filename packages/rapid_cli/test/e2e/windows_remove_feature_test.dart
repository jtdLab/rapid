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
        'windows remove feature',
        () async {
          // Arrange
          const featureName = 'foo_bar';
          await setupProject(Platform.windows);
          await addFeature(featureName, platform: Platform.windows);

          // Act
          final commandResult = await commandRunner.run(
            ['windows', 'remove', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final featurePackages = [
            featurePackage('app', Platform.windows),
            featurePackage('home_page', Platform.windows),
          ];
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentPackages(Platform.windows),
            ...featurePackages,
          ]);
          verifyDoNotExist([
            featurePackage(featureName, Platform.windows),
          ]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.windows),
            ...featurePackages,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
