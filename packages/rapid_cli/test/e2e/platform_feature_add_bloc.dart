import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  String? outputDir,
  required double expectedCoverage,
}) async {
  // Arrange
  final name = 'FooBar';
  final featureName = 'home_page';

  // Act
  await runRapidCommand([
    platform.name,
    featureName,
    'add',
    'bloc',
    name,
    if (outputDir != null) '--output-dir',
    if (outputDir != null) outputDir,
  ]);

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  verifyDoExist({
    ...blocFiles(
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
  await verifyTestsPass(
    featurePackage(featureName, platform),
    expectedCoverage: expectedCoverage,
  );
}
