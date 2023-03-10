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
        'ios add language (fast)',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.ios);

          // Act
          final commandResult = await commandRunner.run(
            ['ios', 'add', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.ios);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            ...languageFiles('home_page', Platform.ios, ['en', language]),
          ]);
        },
        tags: ['fast'],
      );

      test(
        'ios add language',
        () async {
          // Arrange
          const language = 'fr';
          await setupProject(Platform.ios);

          // Act
          final commandResult = await commandRunner.run(
            ['ios', 'add', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.ios);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            ...languageFiles('home_page', Platform.ios, ['en', language]),
          ]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', Platform.ios),
            featurePackage('home_page', Platform.ios),
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
