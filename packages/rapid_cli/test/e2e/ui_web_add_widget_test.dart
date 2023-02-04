@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

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
        'ui web add widget (fast)',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.web);
          final name = 'FooBar';

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['ui', 'web', 'add', 'widget', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final outputDir = 'foo';
          final commandResultWithOutputDir = await commandRunner.run(
            ['ui', 'web', 'add', 'widget', name, '--output-dir', outputDir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...widgetFiles(name: name, platform: Platform.web),
            ...widgetFiles(
                name: name, outputDir: outputDir, platform: Platform.web),
          });
        },
        tags: ['fast'],
      );

      test(
        'ui web add widget',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.web);
          final name = 'FooBar';

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['ui', 'web', 'add', 'widget', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final outputDir = 'foo';
          final commandResultWithOutputDir = await commandRunner.run(
            ['ui', 'web', 'add', 'widget', name, '--output-dir', outputDir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...widgetFiles(name: name, platform: Platform.web),
            ...widgetFiles(
                name: name, outputDir: outputDir, platform: Platform.web),
          });

          await verifyTestsPassWith100PercentCoverage({
            platformUiPackage(Platform.web),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
