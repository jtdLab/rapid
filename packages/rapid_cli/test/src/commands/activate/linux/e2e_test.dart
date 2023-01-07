@Tags(['e2e', 'linux'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
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
        'activate linux',
        () async {
          // Arrange
          await commandRunner.run(
            ['create', '.', '--project-name', projectName],
          );

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'linux'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          // await verifyNoFormattingIssues(); TODO add later

          final platformDependentDirs = platformDirs('linux');
          verifyTestsPassWith100PercentCoverage([
            ...platformIndependentDirs,
            ...platformDependentDirs,
          ]);

          // TODO maybe verify that platform dir exist

          final failedIntegrationTests = await runFlutterIntegrationTest(
            cwd: appDir.path,
            pathToTests: 'integration_test/development_test.dart',
            platform: Platform.linux,
          );
          expect(failedIntegrationTests, 0);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)), // TODO should be lower
  );
}
