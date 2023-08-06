import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/add/feature/tab_flow.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../../matchers.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add a tab flow feature to the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} add feature tab_flow <name> [arguments]\n'
        '-h, --help            Print this usage information.\n'
        '\n'
        '\n'
        '    --sub-features    The features that have this tab flow as a parent.\n'
        '    --desc            The description of the new feature.\n'
        '    --navigator       Whether to generate a navigator for the new feature.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(registerFallbackValues);

  for (final platform in Platform.values) {
    group('${platform.name} add feature flow', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          await commandRunner
              .run([platform.name, 'add', 'feature', 'tab_flow', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner
              .run([platform.name, 'add', 'feature', 'tab_flow', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      group('throws UsageException', () {
        test(
          'when name is missing',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            expect(
              () => commandRunner
                  .run([platform.name, 'add', 'feature', 'tab_flow']),
              throwsUsageException(
                message: 'No option specified for the name.',
              ),
            );
          }),
        );

        test(
          'when multiple names are provided',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            expect(
              () => commandRunner.run(
                [platform.name, 'add', 'feature', 'tab_flow', 'Foo', 'Bar'],
              ),
              throwsUsageException(message: 'Multiple names specified.'),
            );
          }),
        );

        test(
          'when name is not a valid dart package name',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            expect(
              () => commandRunner
                  .run([platform.name, 'add', 'feature', 'tab_flow', '+foo+']),
              throwsUsageException(
                message: '"+foo+" is not a valid dart package name.\n\n'
                    'See https://dart.dev/tools/pub/pubspec#name for more information.',
              ),
            );
          }),
        );
      });

      test(
        'throws UsageException when sub-features is missing',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          expect(
            () => commandRunner.run(
              [platform.name, 'add', 'feature', 'tab_flow', 'package_a'],
            ),
            throwsUsageException(
              message: 'No option specified for the sub-features.',
            ),
          );
        }),
      );

      test('completes', () async {
        final rapid = MockRapid();
        final argResults = MockArgResults();

        when(() => argResults['sub-features'])
            .thenReturn('package_b, package_c');
        when(() => argResults.rest).thenReturn(['package_a']);
        final command = PlatformAddFeatureTabFlowCommand(platform, null)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformAddFeatureTabFlow(
            platform,
            name: 'package_a',
            description: 'The PackageA flow feature.',
            navigator: false,
            subFeatures: {'package_b', 'package_c'},
          ),
        ).called(1);
      });
    });
  }
}
