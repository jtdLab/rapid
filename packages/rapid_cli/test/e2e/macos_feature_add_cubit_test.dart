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
        'macos feature add cubit (fast)',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.macos);
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'macos',
              'feature',
              'add',
              'cubit',
              name,
              '--feature-name',
              featureName,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs(Platform.macos),
            ...cubitFiles(
              name: name,
              featureName: featureName,
              platform: Platform.macos,
            ),
          });
        },
        tags: ['fast'],
      );

      test(
        'macos feature add cubit',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.macos);
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'macos',
              'feature',
              'add',
              'cubit',
              name,
              '--feature-name',
              featureName,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs(Platform.macos),
            ...cubitFiles(
              name: name,
              featureName: featureName,
              platform: Platform.macos,
            ),
          });

          await verifyTestsPass(
            featurePackage(featureName, Platform.macos),
            expectedCoverage: 86.67,
          );
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
