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
        'windows remove language (fast)',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.windows);
          languageFiles('home_page', Platform.windows, [language]).create();

          // Act
          final commandResult = await commandRunner.run(
            ['windows', 'remove', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.windows);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            ...languageFiles('home_page', Platform.windows, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.windows, ['fr']),
          });
        },
        tags: ['fast'],
      );

      test(
        'windows remove language',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.windows);
          languageFiles('home_page', Platform.windows, [language]).create();

          // Act
          final commandResult = await commandRunner.run(
            ['windows', 'remove', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.windows);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            ...languageFiles('home_page', Platform.windows, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.windows, ['fr']),
          });

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', Platform.windows),
            featurePackage('home_page', Platform.windows),
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
