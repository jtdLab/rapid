import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
}) =>
    withTempDir((root) async {
      // Arrange
      const featureName = 'my_feature';
      final tester = await RapidE2ETester.withProject(root, platform);

      // Act
      await tester.runRapidCommand([
        platform.name,
        'add',
        'feature',
        featureName,
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      final feature = tester.featurePackage(featureName, platform);
      verifyDoExist([feature]);
      await verifyTestsPassWith100PercentCoverage([feature]);
    });
