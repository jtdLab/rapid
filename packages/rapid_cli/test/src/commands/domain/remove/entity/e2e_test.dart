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
        'domain remove entity (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();
          final name = 'FooBar';
          final dir = 'foo';
          entityFiles(name: name).create();
          entityFiles(name: name, outputDir: dir).create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'remove', 'entity', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'remove', 'entity', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...entityFiles(name: name),
            ...entityFiles(name: name, outputDir: dir),
          });
        },
        tags: ['fast'],
      );

      test(
        'domain remove entity',
        () async {
          // Arrange
          await setupProjectNoPlatforms();
          final name = 'FooBar';
          final dir = 'foo';
          entityFiles(name: name).create();
          entityFiles(name: name, outputDir: dir).create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'remove', 'entity', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'remove', 'entity', name, '--dir', dir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...entityFiles(name: name),
            ...entityFiles(name: name, outputDir: dir),
          });

          await verifyDoNotHaveTests({
            domainPackage,
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
