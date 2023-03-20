@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

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
        'ui android add widget',
        () async {
          // Arrange
          await setupProject(Platform.android);
          final name = 'FooBar';

          // Act
          final commandResult = await commandRunner.run(
            ['ui', 'android', 'add', 'widget', name],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...widgetFiles(name: name, platform: Platform.android),
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
