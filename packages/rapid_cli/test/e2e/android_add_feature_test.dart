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
        'android add feature (fast)',
        () async {
          // Arrange
          const featureName = 'my_feature';
          await setupProject(Platform.android);

          // Act
          final commandResult = await commandRunner.run(
            ['android', 'add', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.android);
          final featureDir = featurePackage(featureName, Platform.android);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            featureDir,
          ]);
        },
        tags: ['fast'],
      );

      test(
        'android add feature',
        () async {
          // Arrange
          const featureName = 'my_feature';
          await setupProject(Platform.android);

          // Act
          final commandResult = await commandRunner.run(
            ['android', 'add', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.android);
          final featureDir = featurePackage(featureName, Platform.android);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            featureDir,
          ]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', Platform.android),
            featureDir,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
