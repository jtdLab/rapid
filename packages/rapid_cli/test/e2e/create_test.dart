@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUpAll(() {
        projectName = 'test_app';
      });

      setUp(() {
        Directory.current = getTempDir();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group('create', () {
        Future<void> performTest({
          TestType type = TestType.normal,
          required String flag,
        }) async {
          // Act
          final commandResult = await commandRunner.run([
            'create',
            projectName,
            '--$flag',
          ]);

          // Assert
          final platforms = flag.toPlatforms();
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoNotExist(
            allPlatformDependentPackages.without(
              platformDependentPackages(platforms),
            ),
          );
          for (final platform in platforms) {
            final platformPackages = platformDependentPackages([platform]);
            final featurePackages = [
              featurePackage('app', platform),
              featurePackage('home_page', platform),
            ];
            verifyDoExist([
              ...platformIndependentPackages,
              ...platformPackages,
              ...featurePackages,
            ]);
            if (type != TestType.fast) {
              verifyDoNotHaveTests([
                ...platformIndependentPackagesWithoutTests,
                ...platformDependentPackagesWithoutTests(platform)
              ]);
              await verifyTestsPassWith100PercentCoverage([
                ...platformIndependentPackagesWithTests,
                ...platformDependentPackagesWithTests(platform),
                ...featurePackages,
              ]);
            }
          }
        }

// TODO this is more granular but increases execution time by wide margin
/*         Future<void> performSlowTest({required Platform platform}) async {
          // Act
          final commandResult = await commandRunner.run([
            'create',
            projectName,
            '--${platform.name}',
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformPackages = platformDependentPackages([platform]);
          final featurePackages = [
            featurePackage('app', platform),
            featurePackage('home_page', platform),
          ];
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformPackages,
            ...featurePackages,
          ]);
          verifyDoNotExist(
            allPlatformDependentPackages.without(platformPackages),
          );
          verifyDoNotHaveTests([
            ...platformIndependentPackagesWithoutTests,
            ...platformDependentPackagesWithoutTests(platform)
          ]);
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(platform),
            ...featurePackages,
          ]);
          final failedIntegrationTests = await runFlutterIntegrationTest(
            platformRootPackage(platform),
            pathToTests: 'integration_test/development_test.dart',
            platform: platform,
          );
          expect(failedIntegrationTests, 0);
        }

        test(
          '',
          () async {
            // Act
            final commandResult = await commandRunner.run([
              'create',
              projectName,
            ]);

            // Assert
            expect(commandResult, equals(ExitCode.success.code));
            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();
            verifyDoExist(platformIndependentPackages);
            verifyDoNotExist(allPlatformDependentPackages);
            verifyDoNotHaveTests(platformIndependentPackagesWithoutTests);
            await verifyTestsPassWith100PercentCoverage(
              platformIndependentPackagesWithTests,
            );
          },
          timeout: const Timeout(Duration(minutes: 8)),
        );

        group('--android', () {
          test(
            '',
            () => performTest(flag: 'android'),
            timeout: const Timeout(Duration(minutes: 8)),
          );

          test(
            '(slow)',
            () => performSlowTest(platform: Platform.android),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['android'],
          );
        });

        group('--ios', () {
          test(
            '',
            () => performTest(flag: 'ios'),
            timeout: const Timeout(Duration(minutes: 8)),
          );

          test(
            '(slow)',
            () => performSlowTest(platform: Platform.ios),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['ios'],
          );
        });

        group('--linux', () {
          test(
            '',
            () => performTest(flag: 'linux'),
            timeout: const Timeout(Duration(minutes: 8)),
          );

          test(
            '(slow)',
            () => performSlowTest(platform: Platform.linux),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['linux'],
          );
        });

        group('--macos', () {
          test(
            '',
            () => performTest(flag: 'macos'),
            timeout: const Timeout(Duration(minutes: 8)),
          );

          test(
            '(slow)',
            () => performSlowTest(platform: Platform.macos),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['macos'],
          );
        });

        group('--web', () {
          test(
            '',
            () => performTest(flag: 'web'),
            timeout: const Timeout(Duration(minutes: 8)),
          );

          test(
            '(slow)',
            () => performSlowTest(platform: Platform.web),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['web'],
          );
        });

        group('--windows', () {
          test(
            '',
            () => performTest(flag: 'windows'),
            timeout: const Timeout(Duration(minutes: 8)),
          );

          test(
            '(slow)',
            () => performSlowTest(platform: Platform.windows),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['windows'],
          );
        });

        test(
          '--mobile',
          () => performTest(flag: 'mobile'),
          timeout: const Timeout(Duration(minutes: 24)),
        );

        test(
          '--desktop',
          () => performTest(flag: 'desktop'),
          timeout: const Timeout(Duration(minutes: 24)),
        ); */

        test(
          '--all (fast)',
          () => performTest(type: TestType.fast, flag: 'all'),
          timeout: const Timeout(Duration(minutes: 8)),
          tags: ['fast'],
        );

        test(
          '--all',
          () => performTest(flag: 'all'),
          timeout: const Timeout(Duration(minutes: 24)),
        );
      });
    },
  );
}
