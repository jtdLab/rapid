import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
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
  verifyDoNotExist([
    featurePackage(featureName, platform),
  ]);
}
