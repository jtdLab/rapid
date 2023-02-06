@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';

/* Future<void> _performTest(bool fast) async {
  final dir = await getTempDir('activate_android${fast ? '_fast' : ''}');

  // Arrange
  await setupProjectNoPlatforms(dir);

  await IOOverrides.runZoned(
    () async {
      print(Directory.current.path);
      // Act
      final commandRunner = RapidCommandRunner();
      final commandResult = await commandRunner.run(
        ['activate', 'android'],
      );

      // Assert
      expect(commandResult, equals(ExitCode.success.code));

      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();

      verifyDoExist({
        ...platformIndependentPackages,
        ...platformDirs(Platform.android),
        featurePackage('app', Platform.android),
        featurePackage('home_page', Platform.android),
        featurePackage('routing', Platform.android),
      });
      verifyDoNotExist(
        allPlatformDirs.without(platformDirs(Platform.android)),
      );

      if (!fast) {
        verifyDoNotHaveTests({
          domainPackage,
          infrastructurePackage,
          featurePackage('routing', Platform.android),
        });
        await verifyTestsPassWith100PercentCoverage({
          ...platformIndependentPackages
              .without({domainPackage, infrastructurePackage}),
          featurePackage('app', Platform.android),
          featurePackage('home_page', Platform.android),
          platformUiPackage(Platform.android),
        });

        final failedIntegrationTests = await runFlutterIntegrationTest(
          cwd: appPackage.path,
          pathToTests: 'integration_test/development_test.dart',
          platform: Platform.android,
        );
        expect(failedIntegrationTests, 0);
      }
    },
    getCurrentDirectory: () => dir,
  );
}
 */

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() {
        Directory.current = Directory.systemTemp.createTempSync();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'activate android (fast)',
        () async {
          // Arrange
          await setupProject();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'android'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs(Platform.android),
            featurePackage('app', Platform.android),
            featurePackage('home_page', Platform.android),
            featurePackage('routing', Platform.android),
          });
          verifyDoNotExist(
            allPlatformDirs.without(platformDirs(Platform.android)),
          );
        },
        tags: ['fast'],
      );

      test(
        'activate android',
        () async {
          // Arrange
          await setupProject();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'android'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs(Platform.android),
            featurePackage('app', Platform.android),
            featurePackage('home_page', Platform.android),
            featurePackage('routing', Platform.android),
          });
          verifyDoNotExist(
              allPlatformDirs.without(platformDirs(Platform.android)));

          verifyDoNotHaveTests({
            domainPackage,
            infrastructurePackage,
            featurePackage('routing', Platform.android),
          });
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', Platform.android),
            featurePackage('home_page', Platform.android),
            platformUiPackage(Platform.android),
          });

          final failedIntegrationTests = await runFlutterIntegrationTest(
            cwd: appPackage.path,
            pathToTests: 'integration_test/development_test.dart',
            platform: Platform.android,
          );
          expect(failedIntegrationTests, 0);
        },
        tags: ['android'],
      );
    },
    timeout: const Timeout(Duration(minutes: 16)),
  );
}
