@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';

import 'common.dart';

// TODO test sub-domain

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() async {
        Directory.current = getTempDir();

        await setupProject();
        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group('domain <sub_domain> add value_object', () {
        Future<void> performTest({
          String? outputDir,
          TestType type = TestType.normal,
          required RapidCommandRunner commandRunner,
        }) async {
          // Arrange
          final name = 'FooBar';

          // Act
          final commandResult = await commandRunner.run([
            'domain',
            'default',
            'add',
            'value_object',
            name,
            if (outputDir != null) '--output-dir',
            if (outputDir != null) outputDir,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyHasAnalyzerIssues(3);
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
            ...valueObjectFiles(name: name, outputDir: outputDir),
          });
        }

        test(
          '(fast) ',
          () => performTest(
            type: TestType.fast,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          'with output dir (fast) ',
          () => performTest(
            outputDir: 'foo',
            type: TestType.fast,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
        );

        test(
          'with output dir',
          () => performTest(
            outputDir: 'foo',
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
        );
      });
    },
  );
}
