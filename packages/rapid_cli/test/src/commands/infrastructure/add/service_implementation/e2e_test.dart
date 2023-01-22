@Tags(['e2e'])
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
        'infrastructure add service_implementation (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          final name = 'Fake';
          final service = 'FooBar';
          final outputDir = 'foo';
          await addService(name: service);
          await addService(name: service, outputDir: outputDir);

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'infrastructure',
              'add',
              'service_implementation',
              name,
              '--service',
              service,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
              'add',
              'service_implementation',
              name,
              '--service',
              service,
              '--output-dir',
              outputDir
            ],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...serviceImplementationFiles(
              name: name,
              serviceName: service,
            ),
            ...serviceImplementationFiles(
              name: name,
              serviceName: service,
              outputDir: outputDir,
            ),
          });
        },
        tags: ['fast'],
      );

      test(
        'infrastructure add service_implementation',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          final name = 'Fake';
          final service = 'FooBar';
          final outputDir = 'foo';
          await addService(name: service);
          await addService(name: service, outputDir: outputDir);

          // Act + Assert
          final commandResult = await commandRunner.run(
            [
              'infrastructure',
              'add',
              'service_implementation',
              name,
              '--service',
              service,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // Act + Assert
          final commandResultWithOutputDir = await commandRunner.run(
            [
              'infrastructure',
              'add',
              'service_implementation',
              name,
              '--service',
              service,
              '--output-dir',
              outputDir
            ],
          );
          expect(commandResultWithOutputDir, equals(ExitCode.success.code));

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          verifyDoExist({
            ...platformIndependentPackages,
            ...serviceImplementationFiles(service: service),
            ...serviceImplementationFiles(
                service: service, outputDir: outputDir),
          });

          await verifyTestsPassWith100PercentCoverage({
            infrastructurePackage,
          });
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
