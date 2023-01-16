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
        'activate ios (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

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
            ...platformDirs('ios'),
            featurePackage('app', 'ios'),
            featurePackage('home_page', 'ios'),
            featurePackage('routing', 'ios'),
          });
          verifyDoNotExist(allPlatformDirs.without(platformDirs('ios')));

          verifyDoNotHaveTests({
            domainPackage,
            infrastructurePackage,
            featurePackage('routing', 'ios'),
            // TODO home page should be tested and not excluded in future
            featurePackage('home_page', 'ios'),
          });
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', 'ios'),
            platformUiPackage('ios'),
          });
        },
      );

      test(
        'activate ios',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

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
            ...platformDirs('ios'),
            featurePackage('app', 'ios'),
            featurePackage('home_page', 'ios'),
            featurePackage('routing', 'ios'),
          });
          verifyDoNotExist(allPlatformDirs.without(platformDirs('ios')));

          verifyDoNotHaveTests({
            domainPackage,
            infrastructurePackage,
            featurePackage('routing', 'ios'),
            // TODO home page should be tested and not excluded in future
            featurePackage('home_page', 'ios'),
          });
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', 'ios'),
            platformUiPackage('ios'),
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
    timeout: const Timeout(Duration(minutes: 7)),
  );
}
