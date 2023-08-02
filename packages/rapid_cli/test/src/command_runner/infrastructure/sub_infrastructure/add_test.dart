import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(String subInfrastructurePackage) => [
      'Add a component to the subinfrastructure $subInfrastructurePackage.\n'
          '\n'
          'Usage: rapid infrastructure $subInfrastructurePackage add <component>\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          'Available subcommands:\n'
          '  data_transfer_object     Add a data transfer object to the subinfrastructure $subInfrastructurePackage.\n'
          '  service_implementation   Add a service implementation to the subinfrastructure $subInfrastructurePackage.\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

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
