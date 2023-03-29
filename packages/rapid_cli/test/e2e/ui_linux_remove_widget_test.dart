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
        'ui linux remove widget',
        () async {
          // Arrange
          await setupProject(Platform.linux);
          final name = 'FooBar';
          widgetFiles(name: name, platform: Platform.linux).create();
          await addPlatformUiPackageThemeExtensionsFile(
            name,
            platform: Platform.linux,
          );
          await addPlatformUiPackageBarrelFile(
            name,
            platform: Platform.linux,
          );

          // Act
          final commandResult = await commandRunner.run(
            ['ui', 'linux', 'remove', 'widget', name],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...widgetFiles(name: name, platform: Platform.linux),
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
