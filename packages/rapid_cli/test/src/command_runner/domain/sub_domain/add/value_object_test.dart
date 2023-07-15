import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/domain/sub_domain/add/value_object.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(String subDomainPackage) => [
      'Add a value object to the subdomain $subDomainPackage.\n'
          '\n'
          'Usage: rapid domain $subDomainPackage add value_object <name> [arguments]\n'
          '-h, --help          Print this usage information.\n'
          '\n'
          '\n'
          '-o, --output-dir    The output directory relative to <domain_package>/lib/ .\n'
          '                    (defaults to ".")\n'
          '    --type          The type that gets wrapped by this value object.\n'
          '                    Generics get escaped via "#" e.g Tuple<#A, #B, String>.\n'
          '                    (defaults to "String")\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  group('domain <sub_domain> add value_object', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final domainPackage = FakeDomainPackage(name: 'package_a');
        final project = getProject(domainPackages: [domainPackage]);
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

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.domainSubDomainAddValueObject(
          name: any(named: 'name'),
          subDomainName: any(named: 'subDomainName'),
          type: any(named: 'type'),
          generics: any(named: 'generics'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults['type']).thenReturn('Triple<#A, int, #B>');
      when(() => argResults.rest).thenReturn(['Foo']);
      final command = DomainSubDomainAddValueObjectCommand('package_a', null)
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
