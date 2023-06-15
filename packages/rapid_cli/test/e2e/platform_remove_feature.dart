import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
}) =>
    withTempDir((root) async {
      // Arrange
      const featureName = 'foo_bar';
      final tester = await RapidE2ETester.withProject(root, platform);
      await tester.runRapidCommand([
        platform.name,
        'add',
        'feature',
        featureName,
      ]);

      // Act
      await tester.runRapidCommand([
        platform.name,
        'remove',
        'feature',
        featureName,
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoNotExist([
        tester.featurePackage(featureName, platform),
      ]);
    });
