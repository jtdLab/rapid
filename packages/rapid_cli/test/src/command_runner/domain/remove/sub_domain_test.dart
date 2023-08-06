import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/domain/remove/sub_domain.dart';
import 'package:test/test.dart';

import '../../../matchers.dart';
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
  setUpAll(registerFallbackValues);

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

    group('throws UsageException', () {
      test(
        'when name is missing',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          expect(
            () => commandRunner.run(['domain', 'remove', 'sub_domain']),
            throwsUsageException(
              message: 'No option specified for the name.',
            ),
          );
        }),
      );

      test(
        'when multiple names are provided',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          expect(
            () => commandRunner
                .run(['domain', 'remove', 'sub_domain', 'Foo', 'Bar']),
            throwsUsageException(message: 'Multiple names specified.'),
          );
        }),
      );

      test(
        'when name is not a valid dart package name',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          expect(
            () =>
                commandRunner.run(['domain', 'remove', 'sub_domain', '+foo+']),
            throwsUsageException(
              message: '"+foo+" is not a valid dart package name.\n\n'
                  'See https://dart.dev/tools/pub/pubspec#name for more information.',
            ),
          );
        }),
      );
    });

    test('completes', () async {
      final rapid = MockRapid();
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
