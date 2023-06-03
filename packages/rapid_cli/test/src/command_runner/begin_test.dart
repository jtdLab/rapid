import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/begin.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';

const expectedUsage = [
  'Starts a group of Rapid command executions.\n'
      '\n'
      'Usage: rapid begin\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('begin', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner((commandRunner, _, __, printLogs) async {
        await commandRunner.run(['begin', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['begin', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(() => rapid.begin()).thenAnswer((_) async {});
      final command = BeginCommand(null)..rapidOverrides = rapid;

      await command.run();

      verify(() => rapid.begin()).called(1);
    });
  });
}
