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
        'web feature add cubit',
        () async {
          // Arrange
          await setupProject(Platform.web);
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'web',
              'feature',
              'add',
              'cubit',
              name,
              '--feature',
              featureName,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final appFeaturePackage = featurePackage('app', Platform.web);
          final feature = featurePackage(featureName, Platform.web);
          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.web]),
            appFeaturePackage,
            feature,
            ...cubitFiles(
              name: name,
              featureName: featureName,
              platform: Platform.web,
            ),
          });

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.web),
            appFeaturePackage,
          ]);
          // TODO
          await verifyTestsPass(feature, expectedCoverage: 83.33);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
