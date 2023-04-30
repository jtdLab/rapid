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
        'windows remove language',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.windows);
          await commandRunner.run([
            'windows',
            'add',
            'language',
            language,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'windows',
            'remove',
            'language',
            language,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          final featurePackages = [
            featurePackage('app', Platform.windows),
            featurePackage('home_page', Platform.windows),
          ];
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.windows]),
            ...featurePackages,
            ...languageFiles('home_page', Platform.windows, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.windows, ['fr']),
          });
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.windows),
            ...featurePackages,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
