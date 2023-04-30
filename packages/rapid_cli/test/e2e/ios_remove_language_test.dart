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
        'ios remove language',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.ios);
          await commandRunner.run([
            'ios',
            'add',
            'language',
            language,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'ios',
            'remove',
            'language',
            language,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          final featurePackages = [
            featurePackage('app', Platform.ios),
            featurePackage('home_page', Platform.ios),
          ];
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.ios]),
            ...featurePackages,
            ...languageFiles('home_page', Platform.ios, ['en']),
          ]);
          verifyDoNotExist({
            ...languageFiles('home_page', Platform.ios, ['fr']),
          });
          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.ios),
            ...featurePackages,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
