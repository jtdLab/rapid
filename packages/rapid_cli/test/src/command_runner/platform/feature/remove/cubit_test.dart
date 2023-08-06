import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/feature/remove/cubit.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../../matchers.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(
  String featurePackage, {
  required Platform platform,
}) {
  return [
    'Remove a cubit from $featurePackage of the ${platform.prettyName} part of a Rapid project.',
    '',
    'Usage: rapid ${platform.name} $featurePackage remove cubit <name> [arguments]',
    '-h, --help    Print this usage information.',
    '',
    'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(registerFallbackValues);

  for (final platform in Platform.values) {
    group('${platform.name} <feature> remove cubit', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final project = setupProjectWithPlatformFeaturePackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          await commandRunner.run(
            [platform.name, 'package_a', 'remove', 'cubit', '--help'],
          );
          expect(
            printLogs,
            equals(expectedUsage('package_a', platform: platform)),
          );

          printLogs.clear();

          await commandRunner.run(
            [platform.name, 'package_a', 'remove', 'cubit', '-h'],
          );
          expect(
            printLogs,
            equals(expectedUsage('package_a', platform: platform)),
          );
        }),
      );

      group('throws UsageException', () {
        test(
          'when name is missing',
          overridePrint((printLogs) async {
            final project = setupProjectWithPlatformFeaturePackage('package_a');
            final commandRunner = getCommandRunner(project: project);

            expect(
              () => commandRunner
                  .run([platform.name, 'package_a', 'remove', 'cubit']),
              throwsUsageException(
                message: 'No option specified for the name.',
              ),
            );
          }),
        );

        test(
          'when multiple names are provided',
          overridePrint((printLogs) async {
            final project = setupProjectWithPlatformFeaturePackage('package_a');
            final commandRunner = getCommandRunner(project: project);

            expect(
              () => commandRunner.run([
                platform.name,
                'package_a',
                'remove',
                'cubit',
                'Foo',
                'Bar'
              ]),
              throwsUsageException(message: 'Multiple names specified.'),
            );
          }),
        );

        test(
          'when name is not a valid dart class name',
          overridePrint((printLogs) async {
            final project = setupProjectWithPlatformFeaturePackage('package_a');
            final commandRunner = getCommandRunner(project: project);

            expect(
              () => commandRunner
                  .run([platform.name, 'package_a', 'remove', 'cubit', 'foo']),
              throwsUsageException(
                message: '"foo" is not a valid dart class name.',
              ),
            );
          }),
        );
      });

      test('completes', () async {
        final rapid = MockRapid();
        final argResults = MockArgResults();
        when(() => argResults.rest).thenReturn(['Foo']);
        final command =
            PlatformFeatureRemoveCubitCommand(platform, 'package_a', null)
              ..argResultOverrides = argResults
              ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformFeatureRemoveCubit(
            platform,
            name: 'Foo',
            featureName: 'package_a',
          ),
        ).called(1);
      });
    });
  }
}
