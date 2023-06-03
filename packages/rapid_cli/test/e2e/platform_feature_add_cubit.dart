import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  String? outputDir,
  required double expectedCoverage,
  TestType type = TestType.normal,
}) async {
  // Arrange
  final name = 'FooBar';
  final featureName = 'home_page';

  // Act
  await runRapidCommand([
    platform.name,
    featureName,
    'add',
    'cubit',
    name,
    if (outputDir != null) '--output-dir',
    if (outputDir != null) outputDir,
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
    ...cubitFiles(
      name: name,
      featureName: featureName,
      platform: platform,
      outputDir: outputDir,
    ),
  });
  if (type != TestType.fast) {
    await verifyTestsPassWith100PercentCoverage([
      ...platformIndependentPackagesWithTests,
      ...platformDependentPackagesWithTests(platform),
      appFeaturePackage,
    ]);
    // TODO
    await verifyTestsPass(feature, expectedCoverage: expectedCoverage);
  }
}
