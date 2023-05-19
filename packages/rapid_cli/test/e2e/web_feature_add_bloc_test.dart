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
        'web <feature> add bloc',
        () async {
          // Arrange
          await setupProject(Platform.web);
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act
          final commandResult = await commandRunner.run([
            'web',
            featureName,
            'add',
            'bloc',
            name,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          final appFeaturePackage = featurePackage('app', Platform.web);
          final feature = featurePackage(featureName, Platform.web);
          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.web]),
            appFeaturePackage,
            feature,
            ...blocFiles(
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
          await verifyTestsPass(feature, expectedCoverage: 80.0);
        },
      );

      test(
        'web <feature> add bloc (with output dir)',
        () async {
          // Arrange
          await setupProject(Platform.web);
          final name = 'FooBar';
          final featureName = 'home_page';
          final outputDir = 'foo';

          // Act
          final commandResult = await commandRunner.run([
            'web',
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
          final appFeaturePackage = featurePackage('app', Platform.web);
          final feature = featurePackage(featureName, Platform.web);
          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.web]),
            appFeaturePackage,
            feature,
            ...blocFiles(
              name: name,
              featureName: featureName,
              platform: Platform.web,
              outputDir: outputDir,
            ),
          });
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.web),
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
