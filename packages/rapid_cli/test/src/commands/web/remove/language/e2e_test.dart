@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/e2e_helper.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() {
        Directory.current = Directory.systemTemp.createTempSync();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'web remove language (fast)',
        () async {
          // Arrange
          const language = 'fr';
          await setupProjectWithPlatform(Platform.web);
          languageFiles('home_page', Platform.web, [language]).create();

          // Act
          final commandResult = await commandRunner.run(
            ['web', 'remove', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.web);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            ...languageFiles('home_page', Platform.web, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.web, ['fr']),
          });
        },
        tags: ['fast'],
      );

      test(
        'web remove language',
        () async {
          // Arrange
          const language = 'fr';
          await setupProjectWithPlatform(Platform.web);
          languageFiles('home_page', Platform.web, [language]).create();

          // Act
          final commandResult = await commandRunner.run(
            ['web', 'remove', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.web);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            ...languageFiles('home_page', Platform.web, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.web, ['fr']),
          });

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackages,
            featurePackage('app', Platform.web),
            featurePackage('home_page', Platform.web),
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
