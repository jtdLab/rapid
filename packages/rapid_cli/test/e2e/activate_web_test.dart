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

      group('activate web', () {
        Future<void> performTest({bool slow = false}) async {
          // Arrange
          await setupProject();

          // Act
          final commandResult = await commandRunner.run([
            'activate',
            'web',
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          final platformPackages = platformDependentPackages([Platform.web]);
          final featurePackages = [
            featurePackage('app', Platform.web),
            featurePackage('home_page', Platform.web),
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
            ...platformDependentPackagesWithoutTests(Platform.web)
          ]);
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.web),
            ...featurePackages,
          ]);

          if (slow) {
            final failedIntegrationTests = await runFlutterIntegrationTest(
              platformRootPackage(Platform.web),
              pathToTests: 'integration_test/development_test.dart',
              platform: Platform.web,
            );
            expect(failedIntegrationTests, 0);
          }
        }

        test(
          '',
          () => performTest(),
          timeout: const Timeout(Duration(minutes: 8)),
        );

        test(
          '(slow)',
          () => performTest(slow: true),
          timeout: const Timeout(Duration(minutes: 24)),
          tags: ['web'],
        );
      });
    },
  );
}
