import 'package:rapid_cli/src/project/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
}) =>
    withTempDir((root) async {
      // Arrange
      const featureName = 'foo';
      final tester = await RapidE2ETester.withProject(root, platform);

      // Act
      await tester.runRapidCommand([
        platform.name,
        'add',
        'feature',
        'flow',
        featureName,
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      final feature = tester.featurePackage('${featureName}_flow', platform);
      verifyDoExist([feature]);
      await verifyTestsPassWith100PercentCoverage([feature]);
    });
