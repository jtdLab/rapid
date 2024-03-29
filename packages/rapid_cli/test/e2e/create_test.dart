@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'common.dart';

dynamic Function() performTest({
  required String flag,
}) =>
    withTempDir((_) async {
      // Arrange
      final tester = RapidE2ETester('test_app');

      // Act
      await tester.runRapidCommand([
        'create',
        tester.projectName,
        '--$flag',
      ]);

      // Assert
      final platform = Platform.values.firstWhere((p) => flag == p.name);
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoNotExist(
        tester.allPlatformDependentPackages.without(
          tester.platformDependentPackages(platform),
        ),
      );
      final platformPackages = tester.platformDependentPackages(platform);
      final featurePackages = [
        tester.featurePackage('app', platform),
        tester.featurePackage('home_page', platform),
      ];
      verifyDoExist([
        ...tester.platformIndependentPackages,
        ...platformPackages,
        ...featurePackages,
      ]);
      verifyDoNotHaveTests([
        ...tester.platformDependentPackagesWithoutTests(platform),
      ]);
      await verifyTestsPassWith100PercentCoverage([
        ...tester.platformIndependentPackages,
        ...tester.platformDependentPackagesWithTests(platform),
        ...featurePackages,
      ]);
    });

void main() {
  group(
    'E2E',
    () {
      group('create', () {
        test(
          '--android',
          performTest(
            flag: 'android',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );

        test(
          '--ios',
          performTest(
            flag: 'ios',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );

        test(
          '--linux',
          performTest(
            flag: 'linux',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );

        test(
          '--macos',
          performTest(
            flag: 'macos',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );

        test(
          '--web',
          performTest(
            flag: 'web',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );

        test(
          '--windows',
          performTest(
            flag: 'windows',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );

        test(
          '--mobile',
          performTest(
            flag: 'mobile',
          ),
          timeout: const Timeout(Duration(minutes: 16)),
        );
      });
    },
  );
}
