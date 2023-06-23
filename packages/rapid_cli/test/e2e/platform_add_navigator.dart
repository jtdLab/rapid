import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
}) =>
    withTempDir((root) async {
      // Arrange
      final tester = await RapidE2ETester.withProject(root, platform);
      final featureName = 'home_page';

      // Act
      await tester.runRapidCommand([
        platform.name,
        'add',
        'navigator',
        '-f',
        featureName,
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoExist({
        ...tester.navigatorFiles(
          featureName: featureName,
          platform: platform,
        ),
        ...tester.navigatorImplementationFiles(
          featureName: featureName,
          platform: platform,
        ),
      });
      await verifyTestsPass(
        tester.featurePackage(featureName, platform),
        expectedCoverage: 100.0,
      );
    });
