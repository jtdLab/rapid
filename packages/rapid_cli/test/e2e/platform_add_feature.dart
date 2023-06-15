import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
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
  await verifyTestsPassWith100PercentCoverage([feature]);
}
