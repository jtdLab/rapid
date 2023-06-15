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
  verifyDoExist({
    ...cubitFiles(
      name: name,
      featureName: featureName,
      platform: platform,
      outputDir: outputDir,
    ),
    applicationBarrelFile(
      featureName: featureName,
      platform: platform,
    ),
  });
  if (type != TestType.fast) {
    await verifyTestsPass(
      featurePackage(featureName, platform),
      expectedCoverage: expectedCoverage,
    );
  }
}
