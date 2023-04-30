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
        'ios remove navigator',
        () async {
          // Arrange
          await setupProject(Platform.ios);
          final featureName = 'home_page';
          await commandRunner.run([
            'ios',
            'add',
            'navigator',
            '-f',
            featureName,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'ios',
            'remove',
            'navigator',
            '-f',
            featureName,
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
          });
          verifyDoNotExist({
            ...navigatorFiles(
              featureName: featureName,
              platform: Platform.ios,
            ),
            ...navigatorImplementationFiles(
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
          await verifyTestsPass(feature, expectedCoverage: 100.0);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
