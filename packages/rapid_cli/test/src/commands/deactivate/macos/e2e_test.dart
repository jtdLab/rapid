@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
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
        'deactivate macos (fast)',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.macos);

          // Act
          final commandResult = await commandRunner.run(
            ['deactivate', 'macos'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist(allPlatformDirs);
        },
        tags: ['fast'],
      );

      test(
        'deactivate macos',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.macos);

          // Act
          final commandResult = await commandRunner.run(
            ['deactivate', 'macos'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist(allPlatformDirs);

          verifyDoNotHaveTests({domainPackage, infrastructurePackage});
          await verifyTestsPassWith100PercentCoverage({
            ...platformIndependentPackages
                .without({domainPackage, infrastructurePackage}),
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
