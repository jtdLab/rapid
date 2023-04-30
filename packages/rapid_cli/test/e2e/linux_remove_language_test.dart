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
        'linux remove language',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.linux);
          await commandRunner.run([
            'linux',
            'add',
            'language',
            language,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'linux',
            'remove',
            'language',
            language,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          final featurePackages = [
            featurePackage('app', Platform.linux),
            featurePackage('home_page', Platform.linux),
          ];
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.linux]),
            ...featurePackages,
            ...languageFiles('home_page', Platform.linux, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.linux, ['fr']),
          });
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.linux),
            ...featurePackages,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
