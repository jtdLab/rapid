import 'package:test/test.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(String subInfrastructurePackage) => [
      'Add a component to the subinfrastructure $subInfrastructurePackage.',
      '',
      'Usage: rapid infrastructure $subInfrastructurePackage add <component>',
      '-h, --help    Print this usage information.',
      '',
      'Available subcommands:',
      '''  data_transfer_object     Add a data transfer object to the subinfrastructure $subInfrastructurePackage.''',
      '''  service_implementation   Add a service implementation to the subinfrastructure $subInfrastructurePackage.''',
      '',
      'Run "rapid help" to see global options.',
    ];

void main() {
  setUpAll(registerFallbackValues);

  group('infrastructure <sub_infrastructure> add', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = setupProjectWithInfrastructurePackage('package_a');
        final commandRunner = getCommandRunner(project: project);

        await commandRunner
            .run(['infrastructure', 'package_a', 'add', '--help']);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner.run(['infrastructure', 'package_a', 'add', '-h']);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );
  });
}
