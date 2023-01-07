@Tags(['e2e', 'linux'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(
    'E2E',
    () {
      final cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() {
        Directory.current = Directory.systemTemp.createTempSync();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'deactivate linux',
        () async {
          // Arrange
          // TODO should be pregenerated project from a fixture
          await commandRunner.run(
            ['create', '.', '--project-name', projectName, '--linux'],
          );

          // Act
          final commandResult = await commandRunner.run(
            ['deactivate', 'linux'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyTestsPassWith100PercentCoverage(platformIndependentDirs);

          verifyDoNotExist(platformDirs('linux'));
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)), // TODO should be lower
  );
}
