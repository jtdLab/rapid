import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/feature/remove/bloc.dart';
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
    '''Remove a bloc from $featurePackage of the ${platform.prettyName} part of a Rapid project.''',
    '',
    '''Usage: rapid ${platform.name} $featurePackage remove bloc <name> [arguments]''',
    '-h, --help    Print this usage information.',
    '',
    'Run "rapid help" to see global options.',
  ];
}

void main() {
  setUpAll(registerFallbackValues);

  for (final platform in Platform.values) {
    group('${platform.name} <feature> remove bloc', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final project = setupProjectWithPlatformFeaturePackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          await commandRunner
              .run([platform.name, 'package_a', 'remove', 'bloc', '--help']);
          expect(
            printLogs,
            equals(expectedUsage('package_a', platform: platform)),
          );

          printLogs.clear();

          await commandRunner
              .run([platform.name, 'package_a', 'remove', 'bloc', '-h']);
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
                  .run([platform.name, 'package_a', 'remove', 'bloc']),
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
              () => commandRunner.run(
                [platform.name, 'package_a', 'remove', 'bloc', 'Foo', 'Bar'],
              ),
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
                  .run([platform.name, 'package_a', 'remove', 'bloc', 'foo']),
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
        final command = PlatformFeatureRemoveBlocCommand(
          null,
          platform: platform,
          featureName: 'package_a',
        )
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformFeatureRemoveBloc(
            platform,
            name: 'Foo',
            featureName: 'package_a',
          ),
        ).called(1);
      });
    });
  }
}
