@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

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
        'web remove language',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.web);
          languageFiles('app', Platform.web, [language]).create();
          languageFiles('home_page', Platform.web, [language]).create();

          // Act
          final commandResult = await commandRunner.run(
            ['web', 'remove', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final featurePackages = [
            featurePackage('app', Platform.web),
            featurePackage('home_page', Platform.web),
          ];
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentPackages(Platform.web),
            ...featurePackages,
            ...languageFiles('home_page', Platform.web, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.web, ['fr']),
          });

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.web),
            ...featurePackages,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
