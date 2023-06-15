import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  TestType type = TestType.normal,
}) async {
  // Arrange
  const featureName = 'my_feature';
  await setupProject(platform);

  // Act
  await runRapidCommand([
    platform.name,
    'add',
    'feature',
    featureName,
  ]);

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  final featurePackages = [
    featurePackage('app', platform),
    featurePackage('home_page', platform),
    featurePackage(featureName, platform),
  ];
  verifyDoExist([
    ...platformIndependentPackages,
    ...platformDependentPackages(platform),
    ...featurePackages,
  ]);
  if (type != TestType.fast) {
    await verifyTestsPassWith100PercentCoverage([
      ...platformIndependentPackagesWithTests,
      ...platformDependentPackagesWithTests(platform),
      ...featurePackages,
    ]);
  }
}
