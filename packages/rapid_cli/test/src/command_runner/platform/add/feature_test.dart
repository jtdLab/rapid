import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/add/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add a feature to the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} add feature <name> [arguments]\n'
        '-h, --help       Print this usage information.\n'
        '\n'
        '\n'
        '    --desc       The description of this new feature.\n'
        '                 (defaults to "A Rapid feature.")\n'
        '    --routing    Wheter the new feature has routes.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} add feature', () {
      test(
        'help',
        withRunner((commandRunner, _, __, printLogs) async {
          await commandRunner.run([platform.name, 'add', 'feature', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run([platform.name, 'add', 'feature', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      test('completes', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformAddFeature(
            any(),
            name: any(named: 'name'),
            description: any(named: 'description'),
            routing: any(named: 'routing'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults['routing']).thenReturn(true);
        when(() => argResults['desc']).thenReturn('Some description.');
        when(() => argResults.rest).thenReturn(['package_a']);
        final command = PlatformAddFeatureCommand(platform, null)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformAddFeature(
            platform,
            name: 'package_a',
            description: 'Some description.',
            routing: true,
          ),
        ).called(1);
      });
    });
  }
}
