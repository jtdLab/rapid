@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
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
        Future<void> performTest({required String flag}) async {
          // Arrange
          final platforms = flag.toPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['create', projectName, '--$flag'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          for (final platform in platforms) {
            final platformPackages = platformDependentPackages(platform);
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
          }
        }

        Future<void> performSlowTest({required Platform platform}) async {
          // Act
          final commandResult = await commandRunner.run(
            ['create', projectName, '--${platform.name}'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformPackages = platformDependentPackages(platform);
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
            final commandResult = await commandRunner.run(
              ['create', projectName],
            );

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
          tags: ['fast'],
        );

        group('--android', () {
          test(
            '',
            () => performTest(flag: 'android'),
          );

          test(
            '(slow)',
            () => performSlowTest(platform: Platform.android),
            tags: ['android'],
          );
        });

        group('--ios', () {
          test(
            '',
            () => performTest(flag: 'ios'),
          );

          test(
            '(slow)',
            () => performSlowTest(platform: Platform.ios),
            tags: ['ios'],
          );
        });

        group('--linux', () {
          test(
            '',
            () => performTest(flag: 'linux'),
          );

          test(
            '(slow)',
            () => performSlowTest(platform: Platform.linux),
            tags: ['linux'],
          );
        });

        group('--macos', () {
          test(
            '',
            () => performTest(flag: 'macos'),
          );

          test(
            '(slow)',
            () => performSlowTest(platform: Platform.macos),
            tags: ['macos'],
          );
        });

        group('--web', () {
          test(
            '',
            () => performTest(flag: 'web'),
          );

          test(
            '(slow)',
            () => performSlowTest(platform: Platform.web),
            tags: ['web'],
          );
        });

        group('--windows', () {
          test(
            '',
            () => performTest(flag: 'windows'),
          );

          test(
            '(slow)',
            () => performSlowTest(platform: Platform.windows),
            tags: ['windows'],
          );
        });

        test(
          '--mobile',
          () => performTest(flag: 'mobile'),
        );

        test(
          '--desktop',
          () => performTest(flag: 'desktop'),
        );

        test(
          '--all',
          () => performTest(flag: 'all'),
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 24)),
  );
}
