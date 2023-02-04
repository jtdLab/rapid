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
        'linux remove feature (fast)',
        () async {
          // Arrange
          const featureName = 'foo_bar';
          await setupProjectWithPlatform(Platform.linux);
          await addFeature(featureName, platform: Platform.linux);

          // Act
          final commandResult = await commandRunner.run(
            ['linux', 'remove', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.linux);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
          ]);
          verifyDoNotExist([featurePackage(featureName, Platform.linux)]);
        },
        tags: ['fast'],
      );

      test(
        'linux remove feature',
        () async {
          // Arrange
          const featureName = 'foo_bar';
          await setupProjectWithPlatform(Platform.linux);
          await addFeature(featureName, platform: Platform.linux);

          // Act
          final commandResult = await commandRunner.run(
            ['linux', 'remove', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.linux);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
          ]);
          verifyDoNotExist([featurePackage(featureName, Platform.linux)]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', Platform.linux),
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
