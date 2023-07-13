import 'package:rapid_cli/src/command_runner.dart';

import 'mocks.dart';

RapidCommandRunner getCommandRunner({
  MockRapidProject? project,
}) {
  return RapidCommandRunner(
    project: project ?? getProject(),
  );
}
