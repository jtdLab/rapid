import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
}) =>
    withTempDir((root) async {
      // Arrange
      final tester = await RapidE2ETester.withProject(root);

      // Act
      await tester.runRapidCommand(['activate', platform.name]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      final platformPackages = tester.platformDependentPackages(platform);
      final featurePackages = [
        tester.featurePackage('app', platform),
        tester.featurePackage('home_page', platform),
      ];
      verifyDoExist([
        ...platformPackages,
        ...featurePackages,
      ]);

      await verifyTestsPassWith100PercentCoverage([
        ...tester.platformDependentPackagesWithTests(platform),
        ...featurePackages,
      ]);
    });
