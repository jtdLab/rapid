import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/add/feature/flow.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add a flow feature to the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} add feature flow <name> [arguments]\n'
        '-h, --help                 Print this usage information.\n'
        '\n'
        '\n'
        '    --features             The features that have this flow as a parent.\n'
        '    --desc                 The description of the new feature.\n'
        '    --tab                  Wheter the new feature is a tabflow.\n'
        '    --navigator            Wheter to generate a navigator for the new feature.\n'
        '    --[no-]localization    Wether the new feature as localizations.\n'
        '                           (defaults to on)\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} add feature flow', () {
      test(
        'help',
        withRunner((commandRunner, _, __, printLogs) async {
          await commandRunner
              .run([platform.name, 'add', 'feature', 'flow', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner
              .run([platform.name, 'add', 'feature', 'flow', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      test('completes', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformAddFeatureFlow(
            any(),
            name: any(named: 'name'),
            tab: any(named: 'tab'),
            description: any(named: 'description'),
            navigator: any(named: 'navigator'),
            localization: any(named: 'localization'),
            features: any(named: 'features'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults['tab']).thenReturn(false);
        when(() => argResults['localization']).thenReturn(false);
        when(() => argResults['navigator']).thenReturn(true);
        when(() => argResults['desc']).thenReturn('Some description.');
        when(() => argResults.rest).thenReturn(['package_a']);
        final command = PlatformAddFeatureFlowCommand(platform, null)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformAddFeatureFlow(
            platform,
            name: 'package_a',
            tab: false,
            description: 'Some description.',
            navigator: true,
            localization: false,
            features: null,
          ),
        ).called(1);
      });

      test('completes (tab)', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformAddFeatureFlow(
            any(),
            name: any(named: 'name'),
            tab: any(named: 'tab'),
            description: any(named: 'description'),
            navigator: any(named: 'navigator'),
            localization: any(named: 'localization'),
            features: any(named: 'features'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults['tab']).thenReturn(true);
        when(() => argResults['localization']).thenReturn(false);
        when(() => argResults['navigator']).thenReturn(true);
        when(() => argResults['desc']).thenReturn('Some description.');
        when(() => argResults['features']).thenReturn('foo, bar');
        when(() => argResults.rest).thenReturn(['package_a']);
        final command = PlatformAddFeatureFlowCommand(platform, null)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformAddFeatureFlow(
            platform,
            name: 'package_a',
            tab: true,
            description: 'Some description.',
            navigator: true,
            localization: false,
            features: {'foo', 'bar'},
          ),
        ).called(1);
      });
    });
  }
}
