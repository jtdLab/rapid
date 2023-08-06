import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

List<String> expectedUsage(String subInfrastructurePackage) => [
      'Work with the subinfrastructure $subInfrastructurePackage.',
      '',
      'Usage: rapid infrastructure $subInfrastructurePackage <command>',
      '-h, --help    Print this usage information.',
      '',
      'Available subcommands:',
      '  add      Add a component to the subinfrastructure $subInfrastructurePackage.',
      '  remove   Remove a component from the subinfrastructure $subInfrastructurePackage.',
      '',
      'Run "rapid help" to see global options.'
    ];

void main() {
  setUpAll(registerFallbackValues);

  group('infrastructure <sub_infrastructure>', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = setupProjectWithInfrastructurePackage('package_a');
        final commandRunner = getCommandRunner(project: project);

        await commandRunner.run(['infrastructure', 'package_a', '--help']);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner.run(['infrastructure', 'package_a', '-h']);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );
  });
}
