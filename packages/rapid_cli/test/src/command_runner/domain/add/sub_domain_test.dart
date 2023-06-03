import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/domain/add/sub_domain.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';

const expectedUsage = [
  'Add subdomains of the domain part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid domain add sub_domain <name>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('domain add sub_domain', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner((commandRunner, _, __, printLogs) async {
        await commandRunner.run(['domain', 'add', 'sub_domain', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['domain', 'add', 'sub_domain', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.domainAddSubDomain(name: any(named: 'name')),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults.rest).thenReturn(['foo_bar']);
      final command = DomainAddSubDomainCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(() => rapid.domainAddSubDomain(name: 'foo_bar')).called(1);
    });
  });
}
