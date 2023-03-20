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
        'android remove feature',
        () async {
          // Arrange
          const featureName = 'foo_bar';
          await setupProject(Platform.android);
          await addFeature(featureName, platform: Platform.android);

          // Act
          final commandResult = await commandRunner.run(
            ['android', 'remove', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final featurePackages = [
            featurePackage('app', Platform.android),
            featurePackage('home_page', Platform.android),
          ];
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.android]),
            ...featurePackages,
          ]);
          verifyDoNotExist([
            featurePackage(featureName, Platform.android),
          ]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.android),
            ...featurePackages,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
