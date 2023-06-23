import 'package:rapid_cli/src/core/platform.dart';

import 'common.dart';

dynamic performTest({
  required Platform platform,
}) =>
    withTempDir((root) async {
      // Arrange
      final name = 'FooBar';
      final tester = await RapidE2ETester.withProject(root, platform);
      await tester.runRapidCommand(
        [
          'ui',
          platform.name,
          'add',
          'widget',
          name,
        ],
      );

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoExist({
        ...tester.widgetFiles(name: name, platform: platform),
      });
      await verifyTestsPassWith100PercentCoverage(
          [tester.platformUiPackage(platform)]);
    });
