import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/domain/remove/sub_domain.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';
import '../../../utils.dart';

const expectedUsage = [
  'Remove subdomains of the domain part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid domain remove sub_domain <name>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('domain remove sub_domain', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['domain', 'remove', 'sub_domain', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['domain', 'remove', 'sub_domain', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.domainRemoveSubDomain(name: any(named: 'name')),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults.rest).thenReturn(['foo_bar']);
      final command = DomainRemoveSubDomainCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(() => rapid.domainRemoveSubDomain(name: 'foo_bar')).called(1);
    });
  });
}
