import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/pub/get.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

const expectedUsage = [
  'Get packages in a Rapid environment.\n'
      '\n'
      'Usage: rapid pub get\n'
      '-h, --help       Print this usage information.\n'
      '-p, --package    The package where the command is run.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('pub get', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner((commandRunner, _, __, printLogs) async {
        await commandRunner.run(['pub', 'get', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['pub', 'get', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.pubGet(
          packageName: any(named: 'packageName'),
        ),
      ).thenAnswer((_) async {});
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
