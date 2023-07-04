import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/add/feature/widget.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add a widget feature to the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} add feature widget <name> [arguments]\n'
        '-h, --help                 Print this usage information.\n'
        '\n'
        '\n'
        '    --desc                 The description of the new feature.\n'
        '    --[no-]localization    Whether the new feature has localizations.\n'
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
    group('${platform.name} add feature widget', () {
      test(
        'help',
        withRunner((commandRunner, _, __, printLogs) async {
          await commandRunner
              .run([platform.name, 'add', 'feature', 'widget', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner
              .run([platform.name, 'add', 'feature', 'widget', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      test('completes', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformAddFeatureWidget(
            any(),
            name: any(named: 'name'),
            description: any(named: 'description'),
            localization: any(named: 'localization'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults['localization']).thenReturn(false);
        when(() => argResults['desc']).thenReturn('Some description.');
        when(() => argResults.rest).thenReturn(['package_a']);
        final command = PlatformAddFeatureWidgetCommand(platform, null)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformAddFeatureWidget(
            platform,
            name: 'package_a',
            description: 'Some description.',
            localization: false,
          ),
        ).called(1);
      });
    });
  }
}
