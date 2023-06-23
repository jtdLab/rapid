import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/doctor.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';

const expectedUsage = [
  'Show information about an existing Rapid project.\n'
      '\n'
      'Usage: rapid doctor\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('doctor', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner((commandRunner, _, __, printLogs) async {
        await commandRunner.run(['doctor', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['doctor', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(() => rapid.doctor()).thenAnswer((_) async => 0);
      final command = DoctorCommand(null)..rapidOverrides = rapid;

      await command.run();

      verify(() => rapid.doctor()).called(1);
    });
  });
}
