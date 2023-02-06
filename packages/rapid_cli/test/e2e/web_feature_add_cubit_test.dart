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
        'web feature add cubit (fast)',
        () async {
          // Arrange
          await setupProject(Platform.web);
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'web',
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
            ...platformDirs(Platform.web),
            ...cubitFiles(
              name: name,
              featureName: featureName,
              platform: Platform.web,
            ),
          });
        },
        tags: ['fast'],
      );

      test(
        'web feature add cubit',
        () async {
          // Arrange
          await setupProject(Platform.web);
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'web',
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
            ...platformDirs(Platform.web),
            ...cubitFiles(
              name: name,
              featureName: featureName,
              platform: Platform.web,
            ),
          });

          await verifyTestsPass(
            featurePackage(featureName, Platform.web),
            expectedCoverage: 83.33,
          );
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
