import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/remove/feature.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Removes a feature from the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} remove feature <name>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} remove feature', () {
      test(
        'help',
        withRunner((commandRunner, _, __, printLogs) async {
          await commandRunner
              .run([platform.name, 'remove', 'feature', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run([platform.name, 'remove', 'feature', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      test('completes', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformRemoveFeature(
            any(),
            name: any(named: 'name'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults.rest).thenReturn(['package_a']);
        final command = PlatformRemoveFeatureCommand(platform, null)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformRemoveFeature(
            platform,
            name: 'package_a',
          ),
        ).called(1);
      });
    });
  }
}
