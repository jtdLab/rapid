import 'package:test/test.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(String subInfrastructurePackage) => [
      '''Remove a component from the subinfrastructure $subInfrastructurePackage.''',
      '',
      '''Usage: rapid infrastructure $subInfrastructurePackage remove <component>''',
      '-h, --help    Print this usage information.',
      '',
      'Available subcommands:',
      '''  data_transfer_object     Remove a data transfer object from the subinfrastructure $subInfrastructurePackage.''',
      '''  service_implementation   Remove a service implementation from the subinfrastructure $subInfrastructurePackage.''',
      '',
      'Run "rapid help" to see global options.',
    ];

void main() {
  setUpAll(registerFallbackValues);

  group('infrastructure <sub_infrastructure> remove', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = setupProjectWithInfrastructurePackage('package_a');
        final commandRunner = getCommandRunner(project: project);

        await commandRunner
            .run(['infrastructure', 'package_a', 'remove', '--help']);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner
            .run(['infrastructure', 'package_a', 'remove', '-h']);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );
  });
}
