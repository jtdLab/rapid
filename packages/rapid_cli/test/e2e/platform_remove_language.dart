import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
}) =>
    withTempDir((root) async {
      // Arrange
      const language = 'fr';
      final tester = await RapidE2ETester.withProject(root, platform);
      await tester.runRapidCommand([
        platform.name,
        'add',
        'language',
        language,
      ]);

      // Act
      await tester.runRapidCommand([
        platform.name,
        'remove',
        'language',
        language,
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoNotExist({
        ...tester.languageFiles('home_page', platform, [language]),
      });
      await verifyTestsPassWith100PercentCoverage([
        tester.featurePackage('app', platform),
        tester.featurePackage('home_page', platform),
      ]);
    });
