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
        Directory.current = Directory.systemTemp.createTempSync();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'linux remove language (fast)',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.linux);
          languageFiles('home_page', Platform.linux, [language]).create();

          // Act
          final commandResult = await commandRunner.run(
            ['linux', 'remove', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.linux);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            ...languageFiles('home_page', Platform.linux, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.linux, ['fr']),
          });
        },
        tags: ['fast'],
      );

      test(
        'linux remove language',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.linux);
          languageFiles('home_page', Platform.linux, [language]).create();

          // Act
          final commandResult = await commandRunner.run(
            ['linux', 'remove', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.linux);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            ...languageFiles('home_page', Platform.linux, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.linux, ['fr']),
          });

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', Platform.linux),
            featurePackage('home_page', Platform.linux),
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
