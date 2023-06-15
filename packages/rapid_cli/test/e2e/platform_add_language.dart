import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  TestType type = TestType.normal,
}) async {
  // Arrange
  const language = 'fr';
  await setupProject(platform);

  // Act
  await runRapidCommand([
    platform.name,
    'add',
    'language',
    language,
  ]);

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  verifyDoExist([
    ...languageFiles('home_page', platform, ['en', language]),
  ]);
  if (type != TestType.fast) {
    await verifyTestsPassWith100PercentCoverage([
      featurePackage('app', platform),
      featurePackage('home_page', platform),
    ]);
  }
}
