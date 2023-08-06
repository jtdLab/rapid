import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/pub/remove.dart';
import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Remove packages in a Rapid environment.\n'
      '\n'
      'Usage: rapid pub remove [packages]\n'
      '-h, --help       Print this usage information.\n'
      '-p, --package    The package where the command is run in.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(registerFallbackValues);

  group('pub remove', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['pub', 'remove', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['pub', 'remove', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      final argResults = MockArgResults();
      when(() => argResults['package']).thenReturn('foo');
      when(() => argResults.rest).thenReturn(['a: ^1.0.0', 'b:']);
      final command = PubRemoveCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () =>
            rapid.pubRemove(packageName: 'foo', packages: ['a: ^1.0.0', 'b:']),
      ).called(1);
    });
  });
}
