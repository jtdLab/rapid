import 'package:rapid_cli/src/project/platform.dart';

import 'common.dart';

dynamic Function() performTest({
  required Platform platform,
}) =>
    withTempDir((root) async {
      // Arrange
      const featureName = 'foo';
      const subFeatureAName = 'feature_a';
      const subFeatureBName = 'feature_b';
      final tester = await RapidE2ETester.withProject(root, platform);
      await tester.runRapidCommand([
        platform.name,
        'add',
        'feature',
        'page',
        subFeatureAName,
      ]);
      await tester.runRapidCommand([
        platform.name,
        'add',
        'feature',
        'page',
        subFeatureBName,
      ]);

      // Act
      await tester.runRapidCommand([
        platform.name,
        'add',
        'feature',
        'tab_flow',
        featureName,
        '--sub-features',
        '${subFeatureAName}_page, ${subFeatureBName}_page',
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      final feature =
          tester.featurePackage('${featureName}_tab_flow', platform);
      verifyDoExist([feature]);
      await verifyTestsPassWith100PercentCoverage([feature]);
    });
