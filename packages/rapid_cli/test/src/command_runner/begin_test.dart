import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/begin.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

const expectedUsage = [
  'Starts a group of Rapid command executions.\n'
      '\n'
      'Usage: rapid begin\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('begin', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['begin', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['begin', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      final command = BeginCommand(null)..rapidOverrides = rapid;

      await command.run();

      verify(() => rapid.begin()).called(1);
    });
  });
}
