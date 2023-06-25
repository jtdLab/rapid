import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
}) =>
    withTempDir((root) async {
      // Arrange
      final tester = await RapidE2ETester.withProject(root, platform);
      final featureName = 'feature_a';
      await tester.runRapidCommand([
        platform.name,
        'add',
        'feature',
        'page',
        featureName,
        '--no-localization'
      ]);

      // Act
      await tester.runRapidCommand([
        platform.name,
        featureName,
        'add',
        'localization',
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoExist({
        ...tester.languageFiles(
          '${featureName}_page',
          platform,
          ['en'],
        ),
      });
      await verifyTestsPass(
        tester.featurePackage('${featureName}_page', platform),
      );
    });
