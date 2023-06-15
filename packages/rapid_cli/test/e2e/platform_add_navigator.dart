import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  TestType type = TestType.normal,
}) async {
  // Arrange
  await setupProject(platform);
  final featureName = 'home_page';

  // Act
  await runRapidCommand([
    platform.name,
    'add',
    'navigator',
    '-f',
    featureName,
  ]);

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  verifyDoExist({
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
    await verifyTestsPass(
      featurePackage(featureName, platform),
      expectedCoverage: 100.0,
    );
  }
}
