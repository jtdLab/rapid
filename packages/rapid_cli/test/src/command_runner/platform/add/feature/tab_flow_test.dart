import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/add/feature/tab_flow.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

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
        '    --navigator       Wheter to generate a navigator for the new feature.\n'
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
              .run([platform.name, 'add', 'feature', 'tab_flow', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner
              .run([platform.name, 'add', 'feature', 'tab_flow', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      test('completes', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformAddFeatureTabFlow(
            any(),
            name: any(named: 'name'),
            description: any(named: 'description'),
            navigator: any(named: 'navigator'),
            subFeatures: any(named: 'subFeatures'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults['navigator']).thenReturn(true);
        when(() => argResults['desc']).thenReturn('Some description.');
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
            description: 'Some description.',
            navigator: true,
            subFeatures: {'package_b', 'package_c'},
          ),
        ).called(1);
      });
    });
  }
}
