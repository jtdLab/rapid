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
        'activate web (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'web'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs(Platform.web),
            featurePackage('app', Platform.web),
            featurePackage('home_page', Platform.web),
            featurePackage('routing', Platform.web),
          });
          verifyDoNotExist(allPlatformDirs.without(platformDirs(Platform.web)));
        },
        tags: ['fast'],
      );

      test(
        'activate web',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'web'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs(Platform.web),
            featurePackage('app', Platform.web),
            featurePackage('home_page', Platform.web),
            featurePackage('routing', Platform.web),
          });
          verifyDoNotExist(allPlatformDirs.without(platformDirs(Platform.web)));

          verifyDoNotHaveTests({
            domainPackage,
            infrastructurePackage,
            featurePackage('routing', Platform.web),
          });
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', Platform.web),
            featurePackage('home_page', Platform.web),
            platformUiPackage(Platform.web),
          });

          final failedIntegrationTests = await runFlutterIntegrationTest(
            cwd: appPackage.path,
            pathToTests: 'integration_test/development_test.dart',
            platform: Platform.web,
          );
          expect(failedIntegrationTests, 0);
        },
        tags: ['web'],
      );
    },
    timeout: const Timeout(Duration(minutes: 16)),
  );
}
