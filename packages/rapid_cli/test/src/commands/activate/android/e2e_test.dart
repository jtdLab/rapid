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
        'activate android (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

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
            ...platformDirs('android'),
            featurePackage('app', 'android'),
            featurePackage('home_page', 'android'),
            featurePackage('routing', 'android'),
          });
          verifyDoNotExist(allPlatformDirs.without(platformDirs('android')));

          verifyDoNotHaveTests({
            domainPackage,
            infrastructurePackage,
            featurePackage('routing', 'android'),
            // TODO home page should be tested and not excluded in future
            featurePackage('home_page', 'android'),
          });
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', 'android'),
            platformUiPackage('android'),
          });
        },
      );

      test(
        'activate android',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

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
            ...platformDirs('android'),
            featurePackage('app', 'android'),
            featurePackage('home_page', 'android'),
            featurePackage('routing', 'android'),
          });
          verifyDoNotExist(allPlatformDirs.without(platformDirs('android')));

          verifyDoNotHaveTests({
            domainPackage,
            infrastructurePackage,
            featurePackage('routing', 'android'),
            // TODO home page should be tested and not excluded in future
            featurePackage('home_page', 'android'),
          });
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', 'android'),
            platformUiPackage('android'),
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
    timeout: const Timeout(Duration(minutes: 7)),
  );
}
