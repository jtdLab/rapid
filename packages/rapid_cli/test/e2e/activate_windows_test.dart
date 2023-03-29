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

      group('activate windows', () {
        Future<void> performTest({bool slow = false}) async {
          // Arrange
          await setupProject();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'windows'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformPackages =
              platformDependentPackages([Platform.windows]);
          final featurePackages = [
            featurePackage('app', Platform.windows),
            featurePackage('home_page', Platform.windows),
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
            ...platformDependentPackagesWithoutTests(Platform.windows)
          ]);
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.windows),
            ...featurePackages,
          ]);

          if (slow) {
            final failedIntegrationTests = await runFlutterIntegrationTest(
              platformRootPackage(Platform.windows),
              pathToTests: 'integration_test/development_test.dart',
              platform: Platform.windows,
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
          tags: ['windows'],
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 24)),
  );
}
