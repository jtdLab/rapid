@Tags(['e2e'])
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';

import 'common.dart';

// TODO test sub-infrastructure

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

      group('infrastructure <sub_infrastructure> remove service_implementation',
          () {
        Future<void> performTest({
          String? dir,
          TestType type = TestType.normal,
          required RapidCommandRunner commandRunner,
        }) async {
          // Arrange
          await setupProject();
          final name = 'Fake';
          final service = 'FooBar';
          final outputDir = 'foo';
          await commandRunner.run([
            'domain',
            'default',
            'add',
            'service_interface',
            service,
            if (dir != null) '--output-dir',
            if (dir != null) outputDir,
          ]);
          await commandRunner.run([
            'infrastructure',
            'default',
            'add',
            'service_implementation',
            name,
            '--service',
            service,
            if (dir != null) '--output-dir',
            if (dir != null) outputDir,
          ]);

          // Act
          final commandResult = await commandRunner.run([
            'infrastructure',
            'default',
            'remove',
            'service_implementation',
            name,
            '--service',
            service,
            if (dir != null) '--dir',
            if (dir != null) outputDir
          ]);

          // Assert
          expect(commandResult, equals(ExitCode.success.code));
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...serviceImplementationFiles(
              name: name,
              serviceName: service,
              outputDir: outputDir,
            ),
          });
          if (type != TestType.fast) {
            verifyDoNotHaveTests({
              infrastructurePackage(),
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
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
