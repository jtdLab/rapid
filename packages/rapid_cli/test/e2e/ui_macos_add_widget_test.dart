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
        'ui macos add widget (fast)',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.macos);
          final name = 'FooBar';

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['ui', 'macos', 'add', 'widget', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final outputDir = 'foo';
          final commandResultWithOutputDir = await commandRunner.run(
            ['ui', 'macos', 'add', 'widget', name, '--output-dir', outputDir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...widgetFiles(name: name, platform: Platform.macos),
            ...widgetFiles(
                name: name, outputDir: outputDir, platform: Platform.macos),
          });
        },
        tags: ['fast'],
      );

      test(
        'ui macos add widget',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.macos);
          final name = 'FooBar';

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['ui', 'macos', 'add', 'widget', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final outputDir = 'foo';
          final commandResultWithOutputDir = await commandRunner.run(
            ['ui', 'macos', 'add', 'widget', name, '--output-dir', outputDir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...widgetFiles(name: name, platform: Platform.macos),
            ...widgetFiles(
                name: name, outputDir: outputDir, platform: Platform.macos),
          });

          await verifyTestsPassWith100PercentCoverage({
            platformUiPackage(Platform.macos),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
