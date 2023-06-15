@Tags(['e2e'])
import 'dart:io';

import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      setUpAll(() {
        projectName = 'test_app';
      });

      setUp(() {
        Directory.current = getTempDir();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group('create', () {
        Future<void> performTest({
          required String flag,
        }) async {
          // Act
          await runRapidCommand([
            'create',
            projectName,
            '--$flag',
          ]);

          // Assert
          final platform = Platform.values.firstWhere((p) => flag == p.name);
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoNotExist(
            allPlatformDependentPackages.without(
              platformDependentPackages(platform),
            ),
          );
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

        test(
          '--android',
          () => performTest(
            flag: 'android',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );

        test(
          '--ios',
          () => performTest(
            flag: 'ios',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );

        test(
          '--linux',
          () => performTest(
            flag: 'linux',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );

        test(
          '--macos',
          () => performTest(
            flag: 'macos',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );

        test(
          '--web',
          () => performTest(
            flag: 'web',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );

        test(
          '--windows',
          () => performTest(
            flag: 'windows',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );

        test(
          '--mobile',
          () => performTest(
            flag: 'mobile',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );
      });
    },
  );
}
