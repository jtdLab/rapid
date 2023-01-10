@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() {
        Directory.current = Directory.systemTemp.createTempSync();

        // TODO add mock logger here to prevent logging to stdout while running tests
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
          verifyDoExist(platformIndependentDirs);
          verifyDoNotExist(platformDependentDirs);

          await verifyTestsPassWith100PercentCoverage(platformIndependentDirs);
        },
        tags: ['tweak'],
      );
    },
    timeout: const Timeout(Duration(minutes: 8)), // TODO should be lower
  );
}
