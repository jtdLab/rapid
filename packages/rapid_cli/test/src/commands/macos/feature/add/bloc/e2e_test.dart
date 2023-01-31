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
        'macos feature add bloc (fast)',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.macos);
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'macos',
              'feature',
              'add',
              'bloc',
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
            ...platformDirs(Platform.macos),
            ...blocFiles(
              name: name,
              featureName: featureName,
              platform: Platform.macos,
            ),
          });
        },
        tags: ['fast'],
      );

      test(
        'macos feature add bloc',
        () async {
          // Arrange
          await setupProjectWithPlatform(Platform.macos);
          final name = 'FooBar';
          final featureName = 'home_page';

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'macos',
              'feature',
              'add',
              'bloc',
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
            ...platformDirs(Platform.macos),
            ...blocFiles(
              name: name,
              featureName: featureName,
              platform: Platform.macos,
            ),
          });

          await verifyTestsPass(
            featurePackage(featureName, Platform.macos),
            expectedCoverage: 82.35,
          );
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
