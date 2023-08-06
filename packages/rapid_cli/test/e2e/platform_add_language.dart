import 'package:rapid_cli/src/project/platform.dart';

import 'common.dart';

dynamic Function() performTest({
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
        ...tester.languageFiles(platform, ['en', language]),
      ]);
      // TODO maybe verify tests in localization package pass
    });
