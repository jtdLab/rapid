import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/pub/add.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

const expectedUsage = [
  'Add packages in a Rapid environment.\n'
      '\n'
      'Usage: rapid pub add [dev:]<package>[:descriptor] [[dev:]<package>[:descriptor] ...]\n'
      '-h, --help       Print this usage information.\n'
      '-p, --package    The package where the command is run.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('add remove', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner((commandRunner, _, __, printLogs) async {
        await commandRunner.run(['pub', 'add', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['pub', 'add', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.pubAdd(
          packageName: any(named: 'packageName'),
          packages: any(named: 'packages'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults['package']).thenReturn('foo');
      when(() => argResults.rest).thenReturn(['a: ^1.0.0', 'b:']);
      final command = PubAddCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.pubAdd(packageName: 'foo', packages: ['a: ^1.0.0', 'b:']),
      ).called(1);
    });
  });
}
