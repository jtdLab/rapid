@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/e2e_helper.dart';

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
        'deactivate linux',
        () async {
          // Arrange
          await setupProjectWithPlatform('linux');

          // Act
          final commandResult = await commandRunner.run(
            ['deactivate', 'linux'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs('linux');
          verifyDoExist(platformIndependentPackages);
          verifyDoNotExist(platformDependentDirs);

          await verifyTestsPassWith100PercentCoverage(platformIndependentPackages);
        },
        tags: ['tweak'],
      );
    },
    timeout: const Timeout(Duration(minutes: 8)), // TODO should be lower
  );
}
