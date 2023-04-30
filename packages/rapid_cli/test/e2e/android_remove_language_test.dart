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
        'android remove language',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.android);
          await commandRunner.run([
            'android',
            'add',
            'language',
            language,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'android',
            'remove',
            'language',
            language,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          final featurePackages = [
            featurePackage('app', Platform.android),
            featurePackage('home_page', Platform.android),
          ];
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.android]),
            ...featurePackages,
            ...languageFiles('home_page', Platform.android, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.android, ['fr']),
          });
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.android),
            ...featurePackages,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
