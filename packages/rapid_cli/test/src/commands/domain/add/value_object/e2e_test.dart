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
        'domain add value_object (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();
          final name = 'FooBar';

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'add', 'value_object', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final outputDir = 'foo';
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'add', 'value_object', name, '--output-dir', outputDir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyHasAnalyzerIssues(10);
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...valueObjectFiles(name: name),
            ...valueObjectFiles(name: name, outputDir: outputDir),
          });
        },
        tags: ['fast'],
      );

      test(
        'domain add value_object',
        () async {
          // Arrange
          await setupProjectNoPlatforms();
          final name = 'FooBar';

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'add', 'value_object', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final outputDir = 'foo';
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'add', 'value_object', name, '--output-dir', outputDir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyHasAnalyzerIssues(10);
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...valueObjectFiles(name: name),
            ...valueObjectFiles(name: name, outputDir: outputDir),
          });

          await verifyTestsPassWith100PercentCoverage({
            domainPackage,
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
