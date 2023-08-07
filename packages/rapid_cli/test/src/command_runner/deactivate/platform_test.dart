import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/deactivate/platform.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Remove support for ${platform.prettyName} from this project.',
    '',
    'Usage: rapid deactivate ${platform.name}',
    '-h, --help    Print this usage information.',
    '',
    'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(registerFallbackValues);

  group('activate', () {
    for (final platform in Platform.values) {
      group(platform.name, () {
        test(
          'help',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            await commandRunner.run(['deactivate', platform.name, '--help']);
            expect(printLogs, equals(expectedUsage(platform)));

            printLogs.clear();

            await commandRunner.run(['deactivate', platform.name, '-h']);
            expect(printLogs, equals(expectedUsage(platform)));
          }),
        );

        test('completes', () async {
          final rapid = MockRapid();
          final command = DeactivatePlatformCommand(null, platform: platform)
            ..rapidOverrides = rapid;

          await command.run();

          verify(() => rapid.deactivatePlatform(platform)).called(1);
        });
      });
    }
  });
}
