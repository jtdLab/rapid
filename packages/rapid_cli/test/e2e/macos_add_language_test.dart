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
        'macos add language',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.macos);

          // Act
          final commandResult = await commandRunner.run(
            ['macos', 'add', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final featurePackages = [
            featurePackage('app', Platform.macos),
            featurePackage('home_page', Platform.macos),
          ];
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentPackages([Platform.macos]),
            ...featurePackages,
            ...languageFiles('home_page', Platform.macos, ['en', language]),
          ]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackagesWithTests,
            ...platformDependentPackagesWithTests(Platform.macos),
            ...featurePackages,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
