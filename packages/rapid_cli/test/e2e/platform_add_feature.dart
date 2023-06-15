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
  final feature = featurePackage(featureName, platform);
  verifyDoExist([feature]);
  if (type != TestType.fast) {
    await verifyTestsPassWith100PercentCoverage([feature]);
  }
}
