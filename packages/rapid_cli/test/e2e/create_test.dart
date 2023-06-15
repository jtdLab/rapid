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
          TestType type = TestType.normal,
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
          if (type == TestType.slow) {
            final failedIntegrationTests = await runFlutterIntegrationTest(
              platformRootPackage(platform),
              pathToTests: 'integration_test/development_test.dart',
              platform: platform,
            );
            expect(failedIntegrationTests, 0);
          }
        }

        group('--android', () {
          test(
            '(fast)',
            () => performTest(
              type: TestType.fast,
              flag: 'android',
            ),
            timeout: const Timeout(Duration(minutes: 8)),
            tags: ['fast'],
          );

          test(
            '--android',
            () => performTest(
              flag: 'android',
            ),
            timeout: const Timeout(Duration(minutes: 16)),
          );

          test(
            '--android (slow)',
            () => performTest(
              flag: 'android',
            ),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['android'],
          );
        });

        group('--ios', () {
          test(
            '(fast)',
            () => performTest(
              type: TestType.fast,
              flag: 'ios',
            ),
            timeout: const Timeout(Duration(minutes: 8)),
            tags: ['fast'],
          );

          test(
            '--ios',
            () => performTest(
              flag: 'ios',
            ),
            timeout: const Timeout(Duration(minutes: 16)),
          );

          test(
            '--ios (slow)',
            () => performTest(
              flag: 'ios',
            ),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['ios'],
          );
        });

        group('--linux', () {
          test(
            '(fast)',
            () => performTest(
              type: TestType.fast,
              flag: 'linux',
            ),
            timeout: const Timeout(Duration(minutes: 8)),
            tags: ['fast'],
          );

          test(
            '--linux',
            () => performTest(
              flag: 'linux',
            ),
            timeout: const Timeout(Duration(minutes: 16)),
          );

          test(
            '--linux (slow)',
            () => performTest(
              flag: 'linux',
            ),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['linux'],
          );
        });

        group('--macos', () {
          test(
            '(fast)',
            () => performTest(
              type: TestType.fast,
              flag: 'macos',
            ),
            timeout: const Timeout(Duration(minutes: 8)),
            tags: ['fast'],
          );

          test(
            '--macos',
            () => performTest(
              flag: 'macos',
            ),
            timeout: const Timeout(Duration(minutes: 16)),
          );

          test(
            '--macos (slow)',
            () => performTest(
              flag: 'macos',
            ),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['macos'],
          );
        });

        group('--web', () {
          test(
            '(fast)',
            () => performTest(
              type: TestType.fast,
              flag: 'web',
            ),
            timeout: const Timeout(Duration(minutes: 8)),
            tags: ['fast'],
          );

          test(
            '--web',
            () => performTest(
              flag: 'web',
            ),
            timeout: const Timeout(Duration(minutes: 16)),
          );

          test(
            '--web (slow)',
            () => performTest(
              flag: 'web',
            ),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['web'],
          );
        });

        group('--windows', () {
          test(
            '(fast)',
            () => performTest(
              type: TestType.fast,
              flag: 'windows',
            ),
            timeout: const Timeout(Duration(minutes: 8)),
            tags: ['fast'],
          );

          test(
            '--windows',
            () => performTest(
              flag: 'windows',
            ),
            timeout: const Timeout(Duration(minutes: 16)),
          );

          test(
            '--windows (slow)',
            () => performTest(
              flag: 'windows',
            ),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['windows'],
          );
        });

        group('--mobile', () {
          test(
            '(fast)',
            () => performTest(
              type: TestType.fast,
              flag: 'mobile',
            ),
            timeout: const Timeout(Duration(minutes: 8)),
            tags: ['fast'],
          );

          test(
            '--mobile',
            () => performTest(
              flag: 'mobile',
            ),
            timeout: const Timeout(Duration(minutes: 16)),
          );

          test(
            '--mobile (slow)',
            () => performTest(
              flag: 'mobile',
            ),
            timeout: const Timeout(Duration(minutes: 24)),
            tags: ['mobile'],
          );
        });
      });
    },
  );
}
