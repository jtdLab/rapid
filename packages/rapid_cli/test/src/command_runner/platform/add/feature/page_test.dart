import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/add/feature/page.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add a page feature to the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} add feature page <name> [arguments]\n'
        '-h, --help                 Print this usage information.\n'
        '\n'
        '\n'
        '    --desc                 The description of the new feature.\n'
        '    --navigator            Whether to generate a navigator for the new feature.\n'
        '    --[no-]localization    Whether the new feature as localizations.\n'
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
    group('${platform.name} add feature page', () {
      test(
        'help',
        withRunner((commandRunner, _, __, printLogs) async {
          await commandRunner
              .run([platform.name, 'add', 'feature', 'page', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner
              .run([platform.name, 'add', 'feature', 'page', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      test('completes', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformAddFeaturePage(
            any(),
            name: any(named: 'name'),
            description: any(named: 'description'),
            navigator: any(named: 'navigator'),
            localization: any(named: 'localization'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults['localization']).thenReturn(false);
        when(() => argResults['navigator']).thenReturn(true);
        when(() => argResults['desc']).thenReturn('Some description.');
        when(() => argResults.rest).thenReturn(['package_a']);
        final command = PlatformAddFeaturePageCommand(platform, null)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformAddFeaturePage(
            platform,
            name: 'package_a',
            description: 'Some description.',
            navigator: true,
            localization: false,
          ),
        ).called(1);
      });
    });
  }
}
