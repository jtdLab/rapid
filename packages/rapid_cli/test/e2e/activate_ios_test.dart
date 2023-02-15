@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'dart:io';

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
        'activate ios (fast)',
        () async {
          // Arrange
          await setupProject();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'ios'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs(Platform.ios),
            featurePackage('app', Platform.ios),
            featurePackage('home_page', Platform.ios),
            featurePackage('routing', Platform.ios),
          });
          verifyDoNotExist(allPlatformDirs.without(platformDirs(Platform.ios)));
        },
        tags: ['fast'],
      );

      test(
        'activate ios',
        () async {
          // Arrange
          await setupProject();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'ios'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs(Platform.ios),
            featurePackage('app', Platform.ios),
            featurePackage('home_page', Platform.ios),
            featurePackage('routing', Platform.ios),
          });
          verifyDoNotExist(allPlatformDirs.without(platformDirs(Platform.ios)));

          verifyDoNotHaveTests({
            domainPackage,
            infrastructurePackage,
            featurePackage('routing', Platform.ios),
          });
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', Platform.ios),
            featurePackage('home_page', Platform.ios),
            platformUiPackage(Platform.ios),
          });

          final failedIntegrationTests = await runFlutterIntegrationTest(
            cwd: appPackage.path,
            pathToTests: 'integration_test/development_test.dart',
            platform: Platform.ios,
          );
          expect(failedIntegrationTests, 0);
        },
        tags: ['ios'],
      );
    },
    timeout: const Timeout(Duration(minutes: 24)),
  );
}
