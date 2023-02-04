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
        'ios remove feature (fast)',
        () async {
          // Arrange
          const featureName = 'foo_bar';
          await setupProjectWithPlatform(Platform.ios);
          await addFeature(featureName, platform: Platform.ios);

          // Act
          final commandResult = await commandRunner.run(
            ['ios', 'remove', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.ios);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
          ]);
          verifyDoNotExist([featurePackage(featureName, Platform.ios)]);
        },
        tags: ['fast'],
      );

      test(
        'ios remove feature',
        () async {
          // Arrange
          const featureName = 'foo_bar';
          await setupProjectWithPlatform(Platform.ios);
          await addFeature(featureName, platform: Platform.ios);

          // Act
          final commandResult = await commandRunner.run(
            ['ios', 'remove', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.ios);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
          ]);
          verifyDoNotExist([featurePackage(featureName, Platform.ios)]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
            featurePackage('app', Platform.ios),
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
