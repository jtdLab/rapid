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
        'create (fast)',
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
        },
        tags: ['fast'],
      );

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
              ...platformDirs(Platform.android),
              featurePackage('app', Platform.android),
              featurePackage('home_page', Platform.android),
              featurePackage('routing', Platform.android),
            });
            verifyDoNotExist(
              allPlatformDirs.without(platformDirs(Platform.android)),
            );

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
              ...platformDirs(Platform.ios),
              featurePackage('app', Platform.ios),
              featurePackage('home_page', Platform.ios),
              featurePackage('routing', Platform.ios),
            });
            verifyDoNotExist(
              allPlatformDirs.without(platformDirs(Platform.ios)),
            );
          },
          tags: ['fast'],
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
              ...platformDirs(Platform.ios),
              featurePackage('app', Platform.ios),
              featurePackage('home_page', Platform.ios),
              featurePackage('routing', Platform.ios),
            });
            verifyDoNotExist(
              allPlatformDirs.without(platformDirs(Platform.ios)),
            );

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
              ...platformDirs(Platform.linux),
              featurePackage('app', Platform.linux),
              featurePackage('home_page', Platform.linux),
              featurePackage('routing', Platform.linux),
            });
            verifyDoNotExist(
              allPlatformDirs.without(platformDirs(Platform.linux)),
            );
          },
          tags: ['fast'],
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
              ...platformDirs(Platform.linux),
              featurePackage('app', Platform.linux),
              featurePackage('home_page', Platform.linux),
              featurePackage('routing', Platform.linux),
            });
            verifyDoNotExist(
              allPlatformDirs.without(platformDirs(Platform.linux)),
            );

            verifyDoNotHaveTests({
              domainPackage,
              infrastructurePackage,
              featurePackage('routing', Platform.linux),
            });
            await verifyTestsPassWith100PercentCoverage({
              ...platformIndependentPackages
                  .without({domainPackage, infrastructurePackage}),
              featurePackage('app', Platform.linux),
              featurePackage('home_page', Platform.linux),
              platformUiPackage(Platform.linux),
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
              ...platformDirs(Platform.macos),
              featurePackage('app', Platform.macos),
              featurePackage('home_page', Platform.macos),
              featurePackage('routing', Platform.macos),
            });
            verifyDoNotExist(
              allPlatformDirs.without(platformDirs(Platform.macos)),
            );

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
              ...platformDirs(Platform.web),
              featurePackage('app', Platform.web),
              featurePackage('home_page', Platform.web),
              featurePackage('routing', Platform.web),
            });
            verifyDoNotExist(
              allPlatformDirs.without(platformDirs(Platform.web)),
            );
          },
          tags: ['fast'],
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
              ...platformDirs(Platform.web),
              featurePackage('app', Platform.web),
              featurePackage('home_page', Platform.web),
              featurePackage('routing', Platform.web),
            });
            verifyDoNotExist(
              allPlatformDirs.without(platformDirs(Platform.web)),
            );

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
              ...platformDirs(Platform.windows),
              featurePackage('app', Platform.windows),
              featurePackage('home_page', Platform.windows),
              featurePackage('routing', Platform.windows),
            });
            verifyDoNotExist(
              allPlatformDirs.without(platformDirs(Platform.windows)),
            );
          },
          tags: ['fast'],
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
              ...platformDirs(Platform.windows),
              featurePackage('app', Platform.windows),
              featurePackage('home_page', Platform.windows),
              featurePackage('routing', Platform.windows),
            });
            verifyDoNotExist(
              allPlatformDirs.without(platformDirs(Platform.windows)),
            );

            verifyDoNotHaveTests({
              domainPackage,
              infrastructurePackage,
              featurePackage('routing', Platform.windows),
            });
            await verifyTestsPassWith100PercentCoverage({
              ...platformIndependentPackages
                  .without({domainPackage, infrastructurePackage}),
              featurePackage('app', Platform.windows),
              featurePackage('home_page', Platform.windows),
              platformUiPackage(Platform.windows),
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

        test(
          '--mobile (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--mobile'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            verifyDoExist({
              ...platformIndependentPackages,
              ...platformDirs(Platform.android),
              ...platformDirs(Platform.ios),
              featurePackage('app', Platform.android),
              featurePackage('app', Platform.ios),
              featurePackage('home_page', Platform.android),
              featurePackage('home_page', Platform.ios),
              featurePackage('routing', Platform.android),
              featurePackage('routing', Platform.ios),
            });
            verifyDoNotExist(
              allPlatformDirs.without({
                ...platformDirs(Platform.android),
                ...platformDirs(Platform.ios)
              }),
            );
          },
          tags: ['fast'],
        );

        test(
          '--desktop (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--desktop'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            verifyDoExist({
              ...platformIndependentPackages,
              ...platformDirs(Platform.linux),
              ...platformDirs(Platform.macos),
              ...platformDirs(Platform.windows),
              featurePackage('app', Platform.linux),
              featurePackage('app', Platform.macos),
              featurePackage('app', Platform.windows),
              featurePackage('home_page', Platform.linux),
              featurePackage('home_page', Platform.macos),
              featurePackage('home_page', Platform.windows),
              featurePackage('routing', Platform.linux),
              featurePackage('routing', Platform.macos),
              featurePackage('routing', Platform.windows),
            });
            verifyDoNotExist(
              allPlatformDirs.without({
                ...platformDirs(Platform.linux),
                ...platformDirs(Platform.macos),
                ...platformDirs(Platform.windows),
              }),
            );
          },
          tags: ['fast'],
        );

        test(
          '--all (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--all'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            verifyDoExist({
              ...platformIndependentPackages,
              ...platformDirs(Platform.android),
              ...platformDirs(Platform.ios),
              ...platformDirs(Platform.linux),
              ...platformDirs(Platform.macos),
              ...platformDirs(Platform.web),
              ...platformDirs(Platform.windows),
              featurePackage('app', Platform.android),
              featurePackage('app', Platform.ios),
              featurePackage('app', Platform.linux),
              featurePackage('app', Platform.macos),
              featurePackage('app', Platform.web),
              featurePackage('app', Platform.windows),
              featurePackage('home_page', Platform.android),
              featurePackage('home_page', Platform.ios),
              featurePackage('home_page', Platform.linux),
              featurePackage('home_page', Platform.macos),
              featurePackage('home_page', Platform.web),
              featurePackage('home_page', Platform.windows),
              featurePackage('routing', Platform.android),
              featurePackage('routing', Platform.ios),
              featurePackage('routing', Platform.linux),
              featurePackage('routing', Platform.macos),
              featurePackage('routing', Platform.web),
              featurePackage('routing', Platform.windows),
            });
            verifyDoNotExist(
              allPlatformDirs.without({
                ...platformDirs(Platform.android),
                ...platformDirs(Platform.ios),
                ...platformDirs(Platform.linux),
                ...platformDirs(Platform.macos),
                ...platformDirs(Platform.web),
                ...platformDirs(Platform.windows),
              }),
            );
          },
          tags: ['fast'],
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
