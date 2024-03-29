import 'package:rapid_cli/src/project/platform.dart';

import 'common.dart';

dynamic Function() performTest({
  required Platform platform,
}) =>
    withTempDir((root) async {
      // Arrange
      final tester = await RapidE2ETester.withProject(root, platform);

      // Act
      await tester.runRapidCommand(['deactivate', platform.name]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoNotExist(tester.allPlatformDependentPackages);
    });
