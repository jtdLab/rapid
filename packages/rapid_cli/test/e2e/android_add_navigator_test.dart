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
        'android add navigator',
        () async {
          // Arrange
          await setupProject(Platform.android);
          final featureName = 'home_page';

          // Act
          final commandResult = await commandRunner.run([
            'android',
            'add',
            'navigator',
            '-f',
            featureName,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          final appFeaturePackage = featurePackage('app', Platform.android);
          final feature = featurePackage(featureName, Platform.android);
          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.android]),
            appFeaturePackage,
            feature,
            ...navigatorFiles(
              featureName: featureName,
              platform: Platform.android,
            ),
            ...navigatorImplementationFiles(
              featureName: featureName,
              platform: Platform.android,
            ),
          });
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.android),
            appFeaturePackage,
          ]);
          await verifyTestsPass(feature, expectedCoverage: 100.0);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
