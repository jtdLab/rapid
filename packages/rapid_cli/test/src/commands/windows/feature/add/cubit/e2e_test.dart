@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../../helpers/e2e_helper.dart';

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
        'windows feature add cubit (fast)',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.windows);
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'windows',
              'feature',
              'add',
              'cubit',
              name,
              '--feature-name',
              featureName,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs(Platform.windows),
            ...cubitFiles(
              name: name,
              featureName: featureName,
              platform: Platform.windows,
            ),
          });
        },
        tags: ['fast'],
      );

      test(
        'windows feature add cubit',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.windows);
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'windows',
              'feature',
              'add',
              'cubit',
              name,
              '--feature-name',
              featureName,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...platformDirs(Platform.windows),
            ...cubitFiles(
              name: name,
              featureName: featureName,
              platform: Platform.windows,
            ),
          });

          await verifyTestsPass(
            featurePackage(featureName, Platform.windows),
            expectedCoverage: 83.33,
          );
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
