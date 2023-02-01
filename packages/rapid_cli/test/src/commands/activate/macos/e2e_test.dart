@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/e2e_helper.dart';

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
        'activate macos (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'macos'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs(Platform.macos),
            featurePackage('app', Platform.macos),
            featurePackage('home_page', Platform.macos),
            featurePackage('routing', Platform.macos),
          });
          verifyDoNotExist(
            allPlatformDirs.without(platformDirs(Platform.macos)),
          );
        },
        tags: ['fast'],
      );

      test(
        'activate macos',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'macos'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs(Platform.macos),
            featurePackage('app', Platform.macos),
            featurePackage('home_page', Platform.macos),
            featurePackage('routing', Platform.macos),
          });
          verifyDoNotExist(
              allPlatformDirs.without(platformDirs(Platform.macos)));

          verifyDoNotHaveTests({
            domainPackage,
            infrastructurePackage,
            featurePackage('routing', Platform.macos),
          });
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', Platform.macos),
            featurePackage('home_page', Platform.macos),
            platformUiPackage(Platform.macos),
          });

          final failedIntegrationTests = await runFlutterIntegrationTest(
            cwd: appPackage.path,
            pathToTests: 'integration_test/development_test.dart',
            platform: Platform.macos,
          );
          expect(failedIntegrationTests, 0);
        },
        tags: ['macos'],
      );
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );
}
