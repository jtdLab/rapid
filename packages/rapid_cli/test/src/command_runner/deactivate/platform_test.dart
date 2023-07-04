import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/deactivate/platform.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Removes support for ${platform.prettyName} from this project.\n'
        '\n'
        'Usage: rapid deactivate ${platform.name}\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  group('activate', () {
    setUpAll(() {
      registerFallbackValues();
    });

    for (final platform in Platform.values) {
      group(platform.name, () {
        test(
          'help',
          withRunner((commandRunner, _, __, printLogs) async {
            await commandRunner.run(['deactivate', platform.name, '--help']);
            expect(printLogs, equals(expectedUsage(platform)));

            printLogs.clear();

            await commandRunner.run(['deactivate', platform.name, '-h']);
            expect(printLogs, equals(expectedUsage(platform)));
          }),
        );

        test('completes', () async {
          final rapid = MockRapid();
          when(() => rapid.deactivatePlatform(platform))
              .thenAnswer((_) async {});
          final command = DeactivatePlatformCommand(platform, null)
            ..rapidOverrides = rapid;

          await command.run();

          verify(() => rapid.deactivatePlatform(platform)).called(1);
        });
      });
    }
  });
}
