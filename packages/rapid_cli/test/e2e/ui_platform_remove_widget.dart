import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
}) async {
  // Arrange
  await setupProject(platform);
  final name = 'FooBar';
  await runRapidCommand([
    'ui',
    platform.name,
    'add',
    'widget',
    name,
  ]);

  // Act
  await runRapidCommand([
    'ui',
    platform.name,
    'remove',
    'widget',
    name,
  ]);

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  verifyDoNotExist({
    ...widgetFiles(name: name, platform: platform),
  });
  await verifyTestsPassWith100PercentCoverage([platformUiPackage(platform)]);
}
