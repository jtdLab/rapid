import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  TestType type = TestType.normal,
}) async {
  // Arrange
  final name = 'FooBar';
  await setupProject(platform);
  await runRapidCommand(
    [
      'ui',
      platform.name,
      'add',
      'widget',
      name,
    ],
  );

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  verifyDoExist({
    ...platformIndependentPackages,
    ...widgetFiles(name: name, platform: platform),
  });
  if (type != TestType.fast) {
    await verifyTestsPassWith100PercentCoverage({
      platformUiPackage(platform),
    });
  }
}
