import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  TestType type = TestType.normal,
}) async {
  // Arrange
  await setupProject(platform);

  // Act
  await runRapidCommand(['deactivate', platform.name]);

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  verifyDoExist({
    ...platformIndependentPackages,
  });
  verifyDoNotExist(allPlatformDependentPackages);
  verifyDoNotHaveTests(platformIndependentPackagesWithoutTests);
  if (type != TestType.fast) {
    await verifyTestsPassWith100PercentCoverage({
      ...platformIndependentPackagesWithTests,
    });
  }
}
