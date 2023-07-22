import 'package:rapid_cli/src/project/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
}) =>
    withTempDir((root) async {
      // Arrange
      final tester = await RapidE2ETester.withProject(root, platform);
      final name = 'FooBar';
      await tester.runRapidCommand([
        'ui',
        platform.name,
        'add',
        'widget',
        name,
      ]);

      // Act
      await tester.runRapidCommand([
        'ui',
        platform.name,
        'remove',
        'widget',
        name,
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoNotExist({
        ...tester.widgetFiles(name: name, platform: platform),
      });
      await verifyTestsPassWith100PercentCoverage(
          [tester.platformUiPackage(platform)]);
    });
