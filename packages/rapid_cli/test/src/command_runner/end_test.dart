import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/end.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

const expectedUsage = [
  'Ends a group of Rapid command executions.',
  '',
  'Usage: rapid end',
  '-h, --help    Print this usage information.',
  '',
  'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(registerFallbackValues);

  group('end', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['end', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['end', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      final command = EndCommand(null)..rapidOverrides = rapid;

      await command.run();

      verify(rapid.end).called(1);
    });
  });
}
