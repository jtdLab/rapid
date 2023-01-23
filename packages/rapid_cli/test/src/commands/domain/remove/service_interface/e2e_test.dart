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
        'domain remove service_interface (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          final name = 'FooBar';
          final outputDir = 'foo';
          serviceInterfaceFiles(name: name).create();
          serviceInterfaceFiles(name: name, outputDir: outputDir).create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'remove', 'service_interface', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'remove', 'service_interface', name, '--dir', outputDir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...serviceInterfaceFiles(name: name),
            ...serviceInterfaceFiles(name: name, outputDir: outputDir),
          });
        },
        tags: ['fast'],
      );

      test(
        'domain remove service_interface',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          final name = 'FooBar';
          final outputDir = 'foo';
          serviceInterfaceFiles(name: name).create();
          serviceInterfaceFiles(name: name, outputDir: outputDir).create();

          // Act + Assert
          final commandResult = await commandRunner.run(
            ['domain', 'remove', 'service_interface', name],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            ['domain', 'remove', 'service_interface', name, '--dir', outputDir],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...serviceInterfaceFiles(name: name),
            ...serviceInterfaceFiles(name: name, outputDir: outputDir),
          });

          // TODO tests ?
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}