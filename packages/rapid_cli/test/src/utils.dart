import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/commands/runner.dart';

import 'mocks.dart';

RapidCommandRunner getCommandRunner({
  MockRapidProject? project,
}) {
  return RapidCommandRunner(
    project: project ?? getProject(),
  );
}

Rapid getRapid({
  MockRapidProject? project,
  MockRapidTool? tool,
  MockRapidLogger? logger,
}) {
  return Rapid(
    project: project ?? getProject(),
    tool: tool ?? MockRapidTool(),
    logger: logger ?? MockRapidLogger(),
  );
}
