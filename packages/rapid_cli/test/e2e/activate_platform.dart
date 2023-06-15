import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
}) async {
  // Arrange
  await setupProject();
  // Act
  await runRapidCommand(['activate', platform.name]);

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  final platformPackages = platformDependentPackages(platform);
  final featurePackages = [
    featurePackage('app', platform),
    featurePackage('home_page', platform),
  ];
  verifyDoExist([
    ...platformPackages,
    ...featurePackages,
  ]);

  await verifyTestsPassWith100PercentCoverage([
    ...platformDependentPackagesWithTests(platform),
    ...featurePackages,
  ]);
}
