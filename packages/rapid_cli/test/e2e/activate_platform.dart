import 'package:rapid_cli/src/project/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
  String? language,
}) =>
    withTempDir((root) async {
      // Arrange
      final tester = await RapidE2ETester.withProject(root);

      // Act
      await tester.runRapidCommand([
        'activate',
        platform.name,
        if (language != null) '--language',
        if (language != null) language,
      ]);

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
