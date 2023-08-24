import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/domain/sub_domain/add/value_object.dart';
import 'package:test/test.dart';

import '../../../../matchers.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(String subDomainPackage) => [
      'Add a value object to the subdomain $subDomainPackage.',
      '',
      '''Usage: rapid domain $subDomainPackage add value_object <name> [arguments]''',
      '-h, --help    Print this usage information.',
      '',
      '',
      '    --type    The type that gets wrapped by this value object.',
      '              Generics get escaped via "#" e.g Tuple<#A, #B, String>.',
      '              (defaults to "String")',
      '',
      'Run "rapid help" to see global options.',
    ];

void main() {
  setUpAll(registerFallbackValues);

  group('domain <sub_domain> add value_object', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = setupProjectWithDomainPackage('package_a');
        final commandRunner = getCommandRunner(project: project);

        await commandRunner
            .run(['domain', 'package_a', 'add', 'value_object', '--help']);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner
            .run(['domain', 'package_a', 'add', 'value_object', '-h']);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );

    group('throws UsageException', () {
      test(
        'when name is missing',
        overridePrint((printLogs) async {
          final project = setupProjectWithDomainPackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner
                .run(['domain', 'package_a', 'add', 'value_object']),
            throwsUsageException(
              message: 'No option specified for the name.',
            ),
          );
        }),
      );

      test(
        'when multiple names are provided',
        overridePrint((printLogs) async {
          final project = setupProjectWithDomainPackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner.run(
              ['domain', 'package_a', 'add', 'value_object', 'Foo', 'Bar'],
            ),
            throwsUsageException(
              message: 'Multiple names specified.',
            ),
          );
        }),
      );

      test(
        'when name is not a valid dart class name',
        overridePrint((printLogs) async {
          final project = setupProjectWithDomainPackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner
                .run(['domain', 'package_a', 'add', 'value_object', 'foo']),
            throwsUsageException(
              message: '"foo" is not a valid dart class name.',
            ),
          );
        }),
      );
    });

    test('completes', () async {
      final rapid = MockRapid();
      final argResults = MockArgResults();
      when(() => argResults['type']).thenReturn('Triple<#A, int, #B>');
      when(() => argResults.rest).thenReturn(['Foo']);
      final command = DomainSubDomainAddValueObjectCommand(
        null,
        subDomainName: 'package_a',
      )
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.domainSubDomainAddValueObject(
          name: 'Foo',
          subDomainName: 'package_a',
          type: 'Triple<A, int, B>',
          generics: '<A, B>',
        ),
      ).called(1);
    });
  });
}
