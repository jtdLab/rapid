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
        'ui windows remove widget (fast)',
        () async {
          // Arrange
          await setupProject(Platform.windows);
          final name = 'FooBar';
          final dir = 'foo';
          widgetFiles(name: name, platform: Platform.windows).create();
          widgetFiles(name: name, outputDir: dir, platform: Platform.windows)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['ui', 'windows', 'remove', 'widget', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['ui', 'windows', 'remove', 'widget', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...widgetFiles(name: name, platform: Platform.windows),
            ...widgetFiles(
                name: name, outputDir: dir, platform: Platform.windows),
          });
        },
        tags: ['fast'],
      );

      test(
        'ui windows remove widget',
        () async {
          // Arrange
          await setupProject(Platform.windows);
          final name = 'FooBar';
          final dir = 'foo';
          widgetFiles(name: name, platform: Platform.windows).create();
          widgetFiles(name: name, outputDir: dir, platform: Platform.windows)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['ui', 'windows', 'remove', 'widget', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert

          final commandResultWithOutputDir = await commandRunner.run(
            ['ui', 'windows', 'remove', 'widget', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...widgetFiles(name: name, platform: Platform.windows),
            ...widgetFiles(
                name: name, outputDir: dir, platform: Platform.windows),
          });

          await verifyTestsPassWith100PercentCoverage({
            platformUiPackage(Platform.windows),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
