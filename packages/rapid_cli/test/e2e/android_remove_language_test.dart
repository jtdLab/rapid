@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'dart:io';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() {
        Directory.current = getTempDir();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'android remove language (fast)',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.android);
          languageFiles('app', Platform.android, [language]).create();
          languageFiles('home_page', Platform.android, [language]).create();

          // Act
          final commandResult = await commandRunner.run(
            ['android', 'remove', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.android);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            ...languageFiles('home_page', Platform.android, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.android, ['fr']),
          });
        },
        tags: ['fast'],
      );

      test(
        'android remove language',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.android);
          languageFiles('app', Platform.android, [language]).create();
          languageFiles('home_page', Platform.android, [language]).create();

          // Act
          final commandResult = await commandRunner.run(
            ['android', 'remove', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.android);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            ...languageFiles('home_page', Platform.android, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.android, ['fr']),
          });

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', Platform.android),
            featurePackage('home_page', Platform.android),
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
