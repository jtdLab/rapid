import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
}) async {
  // Arrange
  await setupProject(platform);

  // Act
  await runRapidCommand(['deactivate', platform.name]);

  // Assert
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  verifyDoNotExist(allPlatformDependentPackages);
}
