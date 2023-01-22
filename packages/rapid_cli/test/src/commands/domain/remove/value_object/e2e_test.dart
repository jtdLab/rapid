@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/e2e_helper.dart';

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
        'domain remove value_object (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          final name = 'FooBar';
          final outputDir = 'foo';
          valueObjectFiles(name: name).create();
          valueObjectFiles(name: name, outputDir: outputDir).create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'remove', 'value_object', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'remove', 'value_object', name, '--dir', outputDir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...valueObjectFiles(name: name),
            ...valueObjectFiles(name: name, outputDir: outputDir),
          });
        },
        tags: ['fast'],
      );

      test(
        'domain remove value_object',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          final name = 'FooBar';
          final outputDir = 'foo';
          valueObjectFiles(name: name).create();
          valueObjectFiles(name: name, outputDir: outputDir).create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'remove', 'value_object', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'remove', 'value_object', name, '--dir', outputDir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...valueObjectFiles(name: name),
            ...valueObjectFiles(name: name, outputDir: outputDir),
          });

          // TODO tests ?
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
