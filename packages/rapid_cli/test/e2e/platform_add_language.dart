import 'package:rapid_cli/src/project/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
}) =>
    withTempDir((root) async {
      // Arrange
      const language = 'fr';
      final tester = await RapidE2ETester.withProject(root, platform);

      // Act
      await tester.runRapidCommand([
        platform.name,
        'add',
        'language',
        language,
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoExist([
        ...tester.languageFiles('home_page', platform, ['en', language]),
      ]);
      await verifyTestsPassWith100PercentCoverage([
        tester.featurePackage('app', platform),
        tester.featurePackage('home_page', platform),
      ]);
    });
