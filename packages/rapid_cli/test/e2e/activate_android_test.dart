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

      setUp(() {
        Directory.current = getTempDir();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group('activate android', () {
        Future<void> performTest({bool slow = false}) async {
          // Arrange
          await setupProject();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'android'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformPackages = platformDependentPackages(Platform.android);
          final featurePackages = [
            featurePackage('app', Platform.android),
            featurePackage('home_page', Platform.android),
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
            ...platformDependentPackagesWithoutTests(Platform.android)
          ]);
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.android),
            ...featurePackages,
          ]);

          if (slow) {
            final failedIntegrationTests = await runFlutterIntegrationTest(
              platformRootPackage(Platform.android),
              pathToTests: 'integration_test/development_test.dart',
              platform: Platform.android,
            );
            expect(failedIntegrationTests, 0);
          }
        }

        test(
          '',
          () => performTest(),
        );

        test(
          '(slow)',
          () => performTest(slow: true),
          tags: ['android'],
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 24)),
  );
}
