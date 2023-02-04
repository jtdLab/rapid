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
        'ui android remove widget (fast)',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.android);
          final name = 'FooBar';
          final dir = 'foo';
          widgetFiles(name: name, platform: Platform.android).create();
          widgetFiles(name: name, outputDir: dir, platform: Platform.android)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['ui', 'android', 'remove', 'widget', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['ui', 'android', 'remove', 'widget', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...widgetFiles(name: name, platform: Platform.android),
            ...widgetFiles(
                name: name, outputDir: dir, platform: Platform.android),
          });
        },
        tags: ['fast'],
      );

      test(
        'ui android remove widget',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.android);
          final name = 'FooBar';
          final dir = 'foo';
          widgetFiles(name: name, platform: Platform.android).create();
          widgetFiles(name: name, outputDir: dir, platform: Platform.android)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['ui', 'android', 'remove', 'widget', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert

          final commandResultWithOutputDir = await commandRunner.run(
            ['ui', 'android', 'remove', 'widget', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...widgetFiles(name: name, platform: Platform.android),
            ...widgetFiles(
                name: name, outputDir: dir, platform: Platform.android),
          });

          await verifyTestsPassWith100PercentCoverage({
            platformUiPackage(Platform.android),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
