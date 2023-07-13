import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/domain/sub_domain/add/service_interface.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(String subDomainPackage) => [
      'Add a service interface to the subdomain $subDomainPackage.\n'
          '\n'
          'Usage: rapid domain $subDomainPackage add service_interface <name> [arguments]\n'
          '-h, --help          Print this usage information.\n'
          '\n'
          '\n'
          '-o, --output-dir    The output directory relative to <domain_package>/lib/ .\n'
          '                    (defaults to ".")\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  group('domain <sub_domain> add service_interface', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final domainPackage = MockDomainPackage(name: 'package_a');
        final project = getProject(domainPackages: [domainPackage]);
        final commandRunner = getCommandRunner(project: project);

        await commandRunner
            .run(['domain', 'package_a', 'add', 'service_interface', '--help']);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner
            .run(['domain', 'package_a', 'add', 'service_interface', '-h']);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.domainSubDomainAddServiceInterface(
          name: any(named: 'name'),
          subDomainName: any(named: 'subDomainName'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults.rest).thenReturn(['Foo']);
      final command =
          DomainSubDomainAddServiceInterfaceCommand('package_a', null)
            ..argResultOverrides = argResults
            ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.domainSubDomainAddServiceInterface(
          name: 'Foo',
          subDomainName: 'package_a',
        ),
      ).called(1);
    });
  });
}
