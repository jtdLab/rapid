@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
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

      group(
        'ui add widget',
        () {
          Future<void> performTest({
            TestType type = TestType.normal,
            required RapidCommandRunner commandRunner,
          }) async {
            // Arrange
            await setupProject();
            final name = 'FooBar';
            await commandRunner.run([
              'ui',
              'add',
              'widget',
              name,
            ]);

            // Act
            final commandResult = await commandRunner.run([
              'ui',
              'remove',
              'widget',
              name,
            ]);

            // Assert
            expect(commandResult, equals(ExitCode.success.code));
            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();
            verifyDoExist({
              ...platformIndependentPackages,
            });
            verifyDoNotExist({
              ...widgetFiles(name: name),
            });
            if (type != TestType.fast) {
              await verifyTestsPassWith100PercentCoverage({
                uiPackage,
              });
            }
          }

          test(
            '(fast)',
            () => performTest(
              type: TestType.fast,
              commandRunner: commandRunner,
            ),
            timeout: const Timeout(Duration(minutes: 4)),
          );

          test(
            '',
            () => performTest(
              commandRunner: commandRunner,
            ),
            timeout: const Timeout(Duration(minutes: 4)),
          );
        },
      );
    },
  );
}
