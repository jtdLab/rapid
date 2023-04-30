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

      group('activate macos', () {
        Future<void> performTest({bool slow = false}) async {
          // Arrange
          await setupProject();

          // Act
          final commandResult = await commandRunner.run([
            'activate',
            'macos',
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          final platformPackages = platformDependentPackages([Platform.macos]);
          final featurePackages = [
            featurePackage('app', Platform.macos),
            featurePackage('home_page', Platform.macos),
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
            ...platformDependentPackagesWithoutTests(Platform.macos)
          ]);
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.macos),
            ...featurePackages,
          ]);

          if (slow) {
            final failedIntegrationTests = await runFlutterIntegrationTest(
              platformRootPackage(Platform.macos),
              pathToTests: 'integration_test/development_test.dart',
              platform: Platform.macos,
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
          tags: ['macos'],
        );
      });
    },
  );
}
