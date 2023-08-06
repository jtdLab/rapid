import 'package:rapid_cli/src/project/platform.dart';

import 'common.dart';

dynamic Function() performTest({
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
        'page',
        featureName,
      ]);

      // Act
      await tester.runRapidCommand([
        platform.name,
        'remove',
        'feature',
        '${featureName}_page',
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoNotExist([
        tester.featurePackage('${featureName}_page', platform),
      ]);
    });
