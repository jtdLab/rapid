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
        'linux add navigator',
        () async {
          // Arrange
          await setupProject(Platform.linux);
          final featureName = 'home_page';

          // Act
          final commandResult = await commandRunner.run([
            'linux',
            'add',
            'navigator',
            '-f',
            featureName,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          final appFeaturePackage = featurePackage('app', Platform.linux);
          final feature = featurePackage(featureName, Platform.linux);
          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.linux]),
            appFeaturePackage,
            feature,
            ...navigatorFiles(
              featureName: featureName,
              platform: Platform.linux,
            ),
            ...navigatorImplementationFiles(
              featureName: featureName,
              platform: Platform.linux,
            ),
          });
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.linux),
            appFeaturePackage,
          ]);
          await verifyTestsPass(feature, expectedCoverage: 100.0);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
