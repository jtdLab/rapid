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
        'android feature add bloc',
        () async {
          // Arrange
          await setupProject(Platform.android);
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'android',
              'feature',
              'add',
              'bloc',
              name,
              '--feature',
              featureName,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final appFeaturePackage = featurePackage('app', Platform.android);
          final feature = featurePackage(featureName, Platform.android);
          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.android]),
            appFeaturePackage,
            feature,
            ...blocFiles(
              name: name,
              featureName: featureName,
              platform: Platform.android,
            ),
          });

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.android),
            appFeaturePackage,
          ]);
          // TODO
          await verifyTestsPass(feature, expectedCoverage: 78.57);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
