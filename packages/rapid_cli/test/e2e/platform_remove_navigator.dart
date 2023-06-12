import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  TestType type = TestType.normal,
}) async {
  // Arrange
  await setupProject(platform);
  final featureName = 'home_page';
  await runRapidCommand([
    platform.name,
    'add',
    'navigator',
    '-f',
    featureName,
  ]);

  // Act
  await runRapidCommand([
    platform.name,
    'remove',
    'navigator',
    '-f',
    featureName,
  ]);

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  final appFeaturePackage = featurePackage('app', platform);
  final feature = featurePackage(featureName, platform);
  verifyDoExist({
    ...platformIndependentPackages,
    ...platformDependentPackages([platform]),
    appFeaturePackage,
    feature,
  });
  verifyDoNotExist({
    ...navigatorFiles(
      featureName: featureName,
      platform: platform,
    ),
    ...navigatorImplementationFiles(
      featureName: featureName,
      platform: platform,
    ),
  });
  if (type != TestType.fast) {
    await verifyTestsPassWith100PercentCoverage([
      ...platformIndependentPackagesWithTests,
      ...platformDependentPackagesWithTests(platform),
      appFeaturePackage,
    ]);
    await verifyTestsPass(feature, expectedCoverage: 100.0);
  }
}
