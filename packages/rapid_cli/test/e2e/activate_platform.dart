import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  TestType type = TestType.normal,
}) async {
  // Arrange
  await setupProject();
  // Act
  await runRapidCommand(['activate', platform.name]);

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  final platformPackages = platformDependentPackages(platform);
  final featurePackages = [
    featurePackage('app', platform),
    featurePackage('home_page', platform),
  ];
  verifyDoExist([
    ...platformPackages,
    ...featurePackages,
  ]);
  if (type != TestType.fast) {
    await verifyTestsPassWith100PercentCoverage([
      ...platformDependentPackagesWithTests(platform),
      ...featurePackages,
    ]);
  }

  if (type == TestType.slow) {
    final failedIntegrationTests = await runFlutterIntegrationTest(
      platformRootPackage(platform),
      pathToTests: 'integration_test/development_test.dart',
      platform: platform,
    );
    expect(failedIntegrationTests, 0);
  }
}
