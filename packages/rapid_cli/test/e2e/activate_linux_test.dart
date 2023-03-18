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

      group('activate linux', () {
        Future<void> performTest({bool slow = false}) async {
          // Arrange
          await setupProject();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'linux'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformPackages = platformDependentPackages(Platform.linux);
          final featurePackages = [
            featurePackage('app', Platform.linux),
            featurePackage('home_page', Platform.linux),
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
            ...platformDependentPackagesWithoutTests(Platform.linux)
          ]);
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.linux),
            ...featurePackages,
          ]);

          if (slow) {
            final failedIntegrationTests = await runFlutterIntegrationTest(
              platformRootPackage(Platform.linux),
              pathToTests: 'integration_test/development_test.dart',
              platform: Platform.linux,
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
          tags: ['linux'],
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 24)),
  );
}
