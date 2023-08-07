@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'common.dart';

/// This test case should be run on every push to dev branch.
/// It servers as a first lightweight way to check if everything works.
/// STILL on every push to main branch the whole e2e test suite must run.

void main() {
  test(
    'E2E fast',
    withTempDir((_) async {
      // Arrange
      final tester = RapidE2ETester('test_app');

      // Act
      await tester.runRapidCommand([
        'create',
        tester.projectName,
        '--android',
        '--ios',
        '--linux',
        '--macos',
        '--web',
        '--windows',
        '--mobile',
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();

      final platformPackages = [
        for (final platform in Platform.values) ...[
          ...tester.platformDependentPackages(platform)
        ]
      ];
      final featurePackages = [
        for (final platform in Platform.values) ...[
          tester.featurePackage('app', platform),
          tester.featurePackage('home_page', platform),
        ]
      ];
      verifyDoExist([
        ...tester.platformIndependentPackages,
        ...platformPackages,
        ...featurePackages,
      ]);
      verifyDoNotHaveTests([
        for (final platform in Platform.values) ...[
          ...tester.platformDependentPackagesWithoutTests(platform),
        ],
      ]);
      await verifyTestsPassWith100PercentCoverage([
        ...tester.platformIndependentPackages,
        for (final platform in Platform.values) ...[
          ...tester.platformDependentPackagesWithTests(platform),
        ],
        ...featurePackages,
      ]);

      // TODO(jtdLab): this times out
      // TODO(jtdLab): use command groups to
      // 1. add all components
      // 2. check if all component files are existing
      // 3. remove all components
      // 4. check if all component files are removed
    }),
    timeout: const Timeout(Duration(minutes: 16)),
  );
}
