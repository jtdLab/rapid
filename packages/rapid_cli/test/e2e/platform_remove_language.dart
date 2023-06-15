import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  TestType type = TestType.normal,
}) async {
  // Arrange
  const language = 'fr';
  await setupProject(platform);
  await runRapidCommand([
    platform.name,
    'add',
    'language',
    language,
  ]);

  // Act
  await runRapidCommand([
    platform.name,
    'remove',
    'language',
    language,
  ]);

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  final featurePackages = [
    featurePackage('app', platform),
    featurePackage('home_page', platform),
  ];
  verifyDoExist([
    ...platformIndependentPackages,
    ...platformDependentPackages(platform),
    ...featurePackages,
    ...languageFiles('home_page', platform, ['en']),
  ]);
  verifyDoNotExist({
    ...languageFiles('home_page', platform, ['fr']),
  });
  if (type != TestType.fast) {
    await verifyTestsPassWith100PercentCoverage([
      ...platformIndependentPackagesWithTests,
      ...platformDependentPackagesWithTests(platform),
      ...featurePackages,
    ]);
  }
}
