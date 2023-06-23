import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
  bool tab = false,
  bool localization = true,
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
        'flow',
        featureName,
        if (!localization) '--no-localization',
        if (tab) '--tab',
        '--features',
        '${subFeatureAName}_page, ${subFeatureBName}_page',
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      final feature = tester.featurePackage('${featureName}_flow', platform);
      final l10nDir = tester.l10nDirectory('${featureName}_flow', platform);
      verifyDoExist([
        feature,
        if (localization) l10nDir,
      ]);
      if (!localization) {
        verifyDoNotExist([l10nDir]);
      }
      await verifyTestsPassWith100PercentCoverage([feature]);
    });
