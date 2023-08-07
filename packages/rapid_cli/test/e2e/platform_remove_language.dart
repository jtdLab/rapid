import 'package:rapid_cli/src/project/platform.dart';

import 'common.dart';

dynamic Function() performTest({
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
        ...tester.languageFiles(platform, [language]),
      });
      // TODO(jtdLab): maybe verify tests in localization package pass
    });
