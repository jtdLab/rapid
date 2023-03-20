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
        'ios remove feature',
        () async {
          // Arrange
          const featureName = 'foo_bar';
          await setupProject(Platform.ios);
          await addFeature(featureName, platform: Platform.ios);

          // Act
          final commandResult = await commandRunner.run(
            ['ios', 'remove', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final featurePackages = [
            featurePackage('app', Platform.ios),
            featurePackage('home_page', Platform.ios),
          ];
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.ios]),
            ...featurePackages,
          ]);
          verifyDoNotExist([
            featurePackage(featureName, Platform.ios),
          ]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.ios),
            ...featurePackages,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
