@Tags(['e2e', 'web'])
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
        'deactivate web',
        () async {
          // Arrange
          // TODO should be pregenerated project from a fixture
          await commandRunner.run(
            ['create', '.', '--project-name', projectName, '--web'],
          );

          // Act
          final commandResult = await commandRunner.run(
            ['deactivate', 'web'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs('web');
          verifyDoExist(platformIndependentDirs);
          verifyDoNotExist(platformDependentDirs);

          verifyTestsPassWith100PercentCoverage(platformIndependentDirs);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)), // TODO should be lower
  );
}
