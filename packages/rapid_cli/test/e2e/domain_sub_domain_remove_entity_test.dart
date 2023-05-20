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

      group('domain <sub_domain> remove entity', () {
        Future<void> performTest({
          String? dir,
          TestType type = TestType.normal,
          required RapidCommandRunner commandRunner,
        }) async {
          // Arrange
          final name = 'FooBar';

          await commandRunner.run([
            'domain',
            'default',
            'add',
            'entity',
            name,
            if (dir != null) '--output-dir',
            if (dir != null) dir,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'domain',
            'default',
            'remove',
            'entity',
            name,
            if (dir != null) '--dir',
            if (dir != null) dir,
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...entityFiles(name: name, outputDir: dir),
          });
          if (type != TestType.fast) {
            verifyDoNotHaveTests({
              domainPackage(),
            });
          }
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
          'with dir (fast) ',
          () => performTest(
            dir: 'foo',
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
          'with dir',
          () => performTest(
            dir: 'foo',
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
        );
      });
    },
  );
}
