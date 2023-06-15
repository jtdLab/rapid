import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
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
    ...widgetFiles(name: name, platform: platform),
  });
  await verifyTestsPassWith100PercentCoverage([platformUiPackage(platform)]);
}
