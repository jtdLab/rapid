import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/add/navigator.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add a navigator to the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} add navigator [arguments]\n'
        '-h, --help       Print this usage information.\n'
        '\n'
        '\n'
        '-f, --feature    The name of the feature this new navigator is related to.\n'
        '                 This must be the name of an existing ${platform.prettyName} feature.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} add navigator', () {
      test(
        'help',
        withRunner((commandRunner, _, __, printLogs) async {
          await commandRunner
              .run([platform.name, 'add', 'navigator', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run([platform.name, 'add', 'navigator', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      test('completes', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformAddNavigator(
            any(),
            featureName: any(named: 'featureName'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults['feature']).thenReturn('package_a');
        final command = PlatformAddNavigatorCommand(platform, null)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformAddNavigator(
            platform,
            featureName: 'package_a',
          ),
        ).called(1);
      });
    });
  }
}
