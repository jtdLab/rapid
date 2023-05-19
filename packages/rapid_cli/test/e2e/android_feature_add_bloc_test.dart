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

      setUp(() async {
        Directory.current = getTempDir();

        await setupProject(Platform.android);
        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'android <feature> add bloc',
        () async {
          // Arrange
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act
          final commandResult = await commandRunner.run([
            'android',
            featureName,
            'add',
            'bloc',
            name,
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
          await verifyTestsPass(feature, expectedCoverage: 80.0);
        },
      );

      test(
        'android <feature> add bloc (with output dir)',
        () async {
          // Arrange
          final name = 'FooBar';
          final featureName = 'home_page';
          final outputDir = 'foo';

          // Act
          final commandResult = await commandRunner.run([
            'android',
            featureName,
            'add',
            'bloc',
            name,
            '-o',
            outputDir,
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
            ...blocFiles(
              name: name,
              featureName: featureName,
              platform: Platform.android,
              outputDir: outputDir,
            ),
          });
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.android),
            appFeaturePackage,
          ]);
          // TODO
          await verifyTestsPass(feature, expectedCoverage: 80.0);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
