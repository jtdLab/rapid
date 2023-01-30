@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../../helpers/e2e_helper.dart';

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
        'ui macos remove widget (fast)',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.macos);
          final name = 'FooBar';
          final dir = 'foo';
          widgetFiles(name: name, platform: Platform.macos).create();
          widgetFiles(name: name, outputDir: dir, platform: Platform.macos)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['ui', 'macos', 'remove', 'widget', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['ui', 'macos', 'remove', 'widget', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...widgetFiles(name: name, platform: Platform.macos),
            ...widgetFiles(
                name: name, outputDir: dir, platform: Platform.macos),
          });
        },
        tags: ['fast'],
      );

      test(
        'ui macos remove widget',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.macos);
          final name = 'FooBar';
          final dir = 'foo';
          widgetFiles(name: name, platform: Platform.macos).create();
          widgetFiles(name: name, outputDir: dir, platform: Platform.macos)
              .create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['ui', 'macos', 'remove', 'widget', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert

          final commandResultWithOutputDir = await commandRunner.run(
            ['ui', 'macos', 'remove', 'widget', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...widgetFiles(name: name, platform: Platform.macos),
            ...widgetFiles(
                name: name, outputDir: dir, platform: Platform.macos),
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
