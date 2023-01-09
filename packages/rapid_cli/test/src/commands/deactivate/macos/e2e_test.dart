@Tags(['e2e', 'macos'])
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

      test(
        'deactivate macos',
        () async {
          // Arrange
          await setupProjectAllPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['deactivate', 'macos'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs('macos');
          verifyDoExist(platformIndependentDirs);
          verifyDoNotExist(platformDependentDirs);

          verifyTestsPassWith100PercentCoverage(platformIndependentDirs);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)), // TODO should be lower
  );
}
