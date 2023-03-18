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

      group('activate ios', () {
        Future<void> performTest({required bool fast}) async {
          // Arrange
          await setupProject();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'ios'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformPackages = platformDependentPackages(Platform.ios);
          final featurePackages = [
            featurePackage('app', Platform.ios),
            featurePackage('home_page', Platform.ios),
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
            ...platformDependentPackagesWithoutTests(Platform.ios)
          ]);
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.ios),
            ...featurePackages,
          ]);

          final failedIntegrationTests = await runFlutterIntegrationTest(
            platformRootPackage(Platform.ios),
            pathToTests: 'integration_test/development_test.dart',
            platform: Platform.ios,
          );
          expect(failedIntegrationTests, 0);
        }

        test(
          '',
          () => performTest(fast: true),
        );

        test(
          '(slow)',
          () => performTest(fast: false),
          tags: ['ios'],
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 24)),
  );
}
