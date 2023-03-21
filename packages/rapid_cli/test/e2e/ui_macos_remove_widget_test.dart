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
        'ui macos remove widget',
        () async {
          // Arrange
          await setupProject(Platform.macos);
          final name = 'FooBar';
          widgetFiles(name: name, platform: Platform.macos).create();
          await addPlatformUiPackageThemeExtensionsFile(
            name,
            platform: Platform.macos,
          );
          await addPlatformUiPackageBarrelFile(
            name,
            platform: Platform.macos,
          );

          // Act
          final commandResult = await commandRunner.run(
            ['ui', 'macos', 'remove', 'widget', name],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...widgetFiles(name: name, platform: Platform.macos),
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
