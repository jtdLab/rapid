@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../helpers/e2e_helper.dart';

void main() {
  group(
    'E2E',
    () {
      final cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUpAll(() {
        projectName = 'test_app';
      });

      setUp(() {
        Directory.current = Directory.systemTemp.createTempSync();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'create',
        () async {
          // Act
          final commandResult = await commandRunner.run(
            ['create', projectName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist(platformIndependentPackages);
          verifyDoNotExist(allPlatformDirs);

          verifyDoNotHaveTests({domainPackage, infrastructurePackage});
          await verifyTestsPassWith100PercentCoverage(
            platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
          );
        },
      );

      group('create', () {
        test(
          '--android (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--android'],
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
          '--android',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--android'],
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

        test(
          '--ios (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--ios'],
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
          '--ios',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--ios'],
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

        test(
          '--linux (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--linux'],
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
          '--linux',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--linux'],
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

        test(
          '--macos (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--macos'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            verifyDoExist({
              ...platformIndependentPackages,
              ...platformDirs('macos'),
              featurePackage('app', 'macos'),
              featurePackage('home_page', 'macos'),
              featurePackage('routing', 'macos'),
            });
            verifyDoNotExist(allPlatformDirs.without(platformDirs('macos')));

            verifyDoNotHaveTests({
              domainPackage,
              infrastructurePackage,
              featurePackage('routing', 'macos'),
              // TODO home page should be tested and not excluded in future
              featurePackage('home_page', 'macos'),
            });
            await verifyTestsPassWith100PercentCoverage({
              ...platformIndependentPackages
                  .without({domainPackage, infrastructurePackage}),
              featurePackage('app', 'macos'),
              platformUiPackage('macos'),
            });
          },
        );

        test(
          '--macos',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--macos'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            verifyDoExist({
              ...platformIndependentPackages,
              ...platformDirs('macos'),
              featurePackage('app', 'macos'),
              featurePackage('home_page', 'macos'),
              featurePackage('routing', 'macos'),
            });
            verifyDoNotExist(allPlatformDirs.without(platformDirs('macos')));

            verifyDoNotHaveTests({
              domainPackage,
              infrastructurePackage,
              featurePackage('routing', 'macos'),
              // TODO home page should be tested and not excluded in future
              featurePackage('home_page', 'macos'),
            });
            await verifyTestsPassWith100PercentCoverage({
              ...platformIndependentPackages
                  .without({domainPackage, infrastructurePackage}),
              featurePackage('app', 'macos'),
              platformUiPackage('macos'),
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

        test(
          '--web (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--web'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            verifyDoExist({
              ...platformIndependentPackages,
              ...platformDirs('web'),
              featurePackage('app', 'web'),
              featurePackage('home_page', 'web'),
              featurePackage('routing', 'web'),
            });
            verifyDoNotExist(allPlatformDirs.without(platformDirs('web')));

            verifyDoNotHaveTests({
              domainPackage,
              infrastructurePackage,
              featurePackage('routing', 'web'),
              // TODO home page should be tested and not excluded in future
              featurePackage('home_page', 'web'),
            });
            await verifyTestsPassWith100PercentCoverage({
              ...platformIndependentPackages
                  .without({domainPackage, infrastructurePackage}),
              featurePackage('app', 'web'),
              platformUiPackage('web'),
            });
          },
        );

        test(
          '--web',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--web'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            verifyDoExist({
              ...platformIndependentPackages,
              ...platformDirs('web'),
              featurePackage('app', 'web'),
              featurePackage('home_page', 'web'),
              featurePackage('routing', 'web'),
            });
            verifyDoNotExist(allPlatformDirs.without(platformDirs('web')));

            verifyDoNotHaveTests({
              domainPackage,
              infrastructurePackage,
              featurePackage('routing', 'web'),
              // TODO home page should be tested and not excluded in future
              featurePackage('home_page', 'web'),
            });
            await verifyTestsPassWith100PercentCoverage({
              ...platformIndependentPackages
                  .without({domainPackage, infrastructurePackage}),
              featurePackage('app', 'web'),
              platformUiPackage('web'),
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

        // TODO fails because of https://github.com/felangel/mason/issues/676
        test(
          '--windows (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--windows'],
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

        // TODO fails because of https://github.com/felangel/mason/issues/676
        test(
          '--windows',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--windows'],
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
      });
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
