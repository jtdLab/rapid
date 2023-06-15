import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  TestType type = TestType.normal,
}) async {
  // Arrange
  const featureName = 'foo_bar';
  await setupProject(platform);
  await runRapidCommand([
    platform.name,
    'add',
    'feature',
    featureName,
  ]);

  // Act
  await runRapidCommand([
    platform.name,
    'remove',
    'feature',
    featureName,
  ]);

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  final featurePackages = [
    featurePackage('app', platform),
    featurePackage('home_page', platform),
  ];
  verifyDoExist([
    ...platformIndependentPackages,
    ...platformDependentPackages(platform),
    ...featurePackages,
  ]);
  verifyDoNotExist([
    featurePackage(featureName, platform),
  ]);
  if (type != TestType.fast) {
    await verifyTestsPassWith100PercentCoverage([
      ...platformIndependentPackagesWithTests,
      ...platformDependentPackagesWithTests(platform),
      ...featurePackages,
    ]);
  }
}
