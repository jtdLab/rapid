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
        'ui linux remove widget (fast)',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.linux);
          final name = 'FooBar';
          final dir = 'foo';
          widgetFiles(name: name, platform: Platform.linux).create();
          widgetFiles(name: name, outputDir: dir, platform: Platform.linux)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['ui', 'linux', 'remove', 'widget', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['ui', 'linux', 'remove', 'widget', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...widgetFiles(name: name, platform: Platform.linux),
            ...widgetFiles(
                name: name, outputDir: dir, platform: Platform.linux),
          });
        },
        tags: ['fast'],
      );

      test(
        'ui linux remove widget',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.linux);
          final name = 'FooBar';
          final dir = 'foo';
          widgetFiles(name: name, platform: Platform.linux).create();
          widgetFiles(name: name, outputDir: dir, platform: Platform.linux)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['ui', 'linux', 'remove', 'widget', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert

          final commandResultWithOutputDir = await commandRunner.run(
            ['ui', 'linux', 'remove', 'widget', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...widgetFiles(name: name, platform: Platform.linux),
            ...widgetFiles(
                name: name, outputDir: dir, platform: Platform.linux),
          });

          await verifyTestsPassWith100PercentCoverage({
            platformUiPackage(Platform.linux),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
