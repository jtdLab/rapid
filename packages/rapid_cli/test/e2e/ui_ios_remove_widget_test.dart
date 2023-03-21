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
        'ui ios remove widget',
        () async {
          // Arrange
          await setupProject(Platform.ios);
          final name = 'FooBar';
          widgetFiles(name: name, platform: Platform.ios).create();
          await addPlatformUiPackageThemeExtensionsFile(
            name,
            platform: Platform.ios,
          );
          await addPlatformUiPackageBarrelFile(
            name,
            platform: Platform.ios,
          );

          // Act
          final commandResult = await commandRunner.run(
            ['ui', 'ios', 'remove', 'widget', name],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...widgetFiles(name: name, platform: Platform.ios),
          });

          await verifyTestsPassWith100PercentCoverage({
            platformUiPackage(Platform.ios),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
