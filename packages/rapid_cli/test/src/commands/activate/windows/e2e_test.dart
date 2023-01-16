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
        'activate windows (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'windows'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs('windows'),
            featurePackage('app', 'windows'),
            featurePackage('home_page', 'windows'),
            featurePackage('routing', 'windows'),
          });
          verifyDoNotExist(allPlatformDirs.without(platformDirs('windows')));

          verifyDoNotHaveTests({
            domainPackage,
            infrastructurePackage,
            featurePackage('routing', 'windows'),
            // TODO home page should be tested and not excluded in future
            featurePackage('home_page', 'windows'),
          });
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', 'windows'),
            platformUiPackage('windows'),
          });
        },
      );

      test(
        'activate windows',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'windows'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs('windows'),
            featurePackage('app', 'windows'),
            featurePackage('home_page', 'windows'),
            featurePackage('routing', 'windows'),
          });
          verifyDoNotExist(allPlatformDirs.without(platformDirs('windows')));

          verifyDoNotHaveTests({
            domainPackage,
            infrastructurePackage,
            featurePackage('routing', 'windows'),
            // TODO home page should be tested and not excluded in future
            featurePackage('home_page', 'windows'),
          });
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', 'windows'),
            platformUiPackage('windows'),
          });

          final failedIntegrationTests = await runFlutterIntegrationTest(
            cwd: appPackage.path,
            pathToTests: 'integration_test/development_test.dart',
            platform: Platform.windows,
          );
          expect(failedIntegrationTests, 0);
        },
        tags: ['windows'],
      );
    },
    timeout: const Timeout(Duration(minutes: 7)),
  );
}
