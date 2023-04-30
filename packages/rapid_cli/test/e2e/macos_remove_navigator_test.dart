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
        'macos remove navigator',
        () async {
          // Arrange
          await setupProject(Platform.macos);
          final featureName = 'home_page';
          await commandRunner.run([
            'macos',
            'add',
            'navigator',
            '-f',
            featureName,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'macos',
            'remove',
            'navigator',
            '-f',
            featureName,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          final appFeaturePackage = featurePackage('app', Platform.macos);
          final feature = featurePackage(featureName, Platform.macos);
          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.macos]),
            appFeaturePackage,
            feature,
          });
          verifyDoNotExist({
            ...navigatorFiles(
              featureName: featureName,
              platform: Platform.macos,
            ),
            ...navigatorImplementationFiles(
              featureName: featureName,
              platform: Platform.macos,
            ),
          });
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.macos),
            appFeaturePackage,
          ]);
          // TODO
          await verifyTestsPass(feature, expectedCoverage: 100.0);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
