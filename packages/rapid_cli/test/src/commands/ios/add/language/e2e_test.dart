void main() {
  // TODO impl
}

/* @Tags(['e2e'])
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
        'ios add language (fast)',
        () async {
          // Arrange
          const language = 'fr';
          await setupProjectWithPlatform('ios');

          // Act
          final commandResult = await commandRunner.run(
            ['ios', 'add', 'language', language],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs('ios');
          final langFiles = languageFiles('home_page', 'ios', ['en', language]);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            ...langFiles,
          ]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackages,
            ...platformDependentDirs,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
 */
