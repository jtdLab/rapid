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
        'ui android remove widget',
        () async {
          // Arrange
          await setupProject(Platform.android);
          final name = 'FooBar';
          widgetFiles(name: name, platform: Platform.android).create();
          await addThemeExtensionsFile(
            name,
            platform: Platform.android,
          );
          await addBarrelFile(
            name,
            platform: Platform.android,
          );

          // Act
          final commandResult = await commandRunner.run(
            ['ui', 'android', 'remove', 'widget', name],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
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
