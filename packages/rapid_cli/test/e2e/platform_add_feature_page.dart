import 'package:rapid_cli/src/project/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
  bool localization = true,
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
        'page',
        featureName,
        if (!localization) '--no-localization',
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      final feature = tester.featurePackage('${featureName}_page', platform);
      final l10nDir = tester.l10nDirectory('${featureName}_page', platform);
      verifyDoExist([
        feature,
        if (localization) l10nDir,
      ]);
      if (!localization) {
        verifyDoNotExist([l10nDir]);
      }
      await verifyTestsPassWith100PercentCoverage([feature]);
    });
