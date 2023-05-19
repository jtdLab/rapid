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

        await setupProject(Platform.ios);
        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'ios <feature> add bloc',
        () async {
          // Arrange
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act
          final commandResult = await commandRunner.run([
            'ios',
            featureName,
            'add',
            'bloc',
            name,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          final appFeaturePackage = featurePackage('app', Platform.ios);
          final feature = featurePackage(featureName, Platform.ios);
          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.ios]),
            appFeaturePackage,
            feature,
            ...blocFiles(
              name: name,
              featureName: featureName,
              platform: Platform.ios,
            ),
          });
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.ios),
            appFeaturePackage,
          ]);
          // TODO
          await verifyTestsPass(feature, expectedCoverage: 80.0);
        },
      );

      test(
        'ios <feature> add bloc (with output dir)',
        () async {
          // Arrange
          final name = 'FooBar';
          final featureName = 'home_page';
          final outputDir = 'foo';

          // Act
          final commandResult = await commandRunner.run([
            'ios',
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
          final appFeaturePackage = featurePackage('app', Platform.ios);
          final feature = featurePackage(featureName, Platform.ios);
          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.ios]),
            appFeaturePackage,
            feature,
            ...blocFiles(
              name: name,
              featureName: featureName,
              platform: Platform.ios,
              outputDir: outputDir,
            ),
          });
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.ios),
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
