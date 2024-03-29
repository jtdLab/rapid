import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/pub/get.dart';
import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Get packages in a Rapid environment.',
  '',
  'Usage: rapid pub get',
  '-h, --help       Print this usage information.',
  '-p, --package    The package where the command is run.',
  '',
  'Run "rapid help" to see global options.',
];

void main() {
  setUpAll(registerFallbackValues);

  group('pub get', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['pub', 'get', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['pub', 'get', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      final argResults = MockArgResults();
      when(() => argResults['package']).thenReturn('foo');
      final command = PubGetCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.pubGet(packageName: 'foo'),
      ).called(1);
    });
  });
}
