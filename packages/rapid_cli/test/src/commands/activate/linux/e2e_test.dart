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
        'activate linux (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'linux'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs('linux'),
            featurePackage('app', 'linux'),
            featurePackage('home_page', 'linux'),
            featurePackage('routing', 'linux'),
          });
          verifyDoNotExist(allPlatformDirs.without(platformDirs('linux')));

          verifyDoNotHaveTests({
            domainPackage,
            infrastructurePackage,
            featurePackage('routing', 'linux'),
            // TODO home page should be tested and not excluded in future
            featurePackage('home_page', 'linux'),
          });
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', 'linux'),
            platformUiPackage('linux'),
          });
        },
      );

      test(
        'activate linux',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'linux'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs('linux'),
            featurePackage('app', 'linux'),
            featurePackage('home_page', 'linux'),
            featurePackage('routing', 'linux'),
          });
          verifyDoNotExist(allPlatformDirs.without(platformDirs('linux')));

          verifyDoNotHaveTests({
            domainPackage,
            infrastructurePackage,
            featurePackage('routing', 'linux'),
            // TODO home page should be tested and not excluded in future
            featurePackage('home_page', 'linux'),
          });
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', 'linux'),
            platformUiPackage('linux'),
          });

          final failedIntegrationTests = await runFlutterIntegrationTest(
            cwd: appPackage.path,
            pathToTests: 'integration_test/development_test.dart',
            platform: Platform.linux,
          );
          expect(failedIntegrationTests, 0);
        },
        tags: ['linux'],
      );
    },
    timeout: const Timeout(Duration(minutes: 7)),
  );
}
