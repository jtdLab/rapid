import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// Completes when [platform] is deactivated in [project].
Future<void> platformIsDeactivated(
  Platform platform,
  Project project,
) async {
  final platformIsActivated = project.platformIsActivated(platform);

  if (platformIsActivated) {
    throw EnvironmentException(
      ExitCode.config.code,
      '${platform.prettyName} is already activated.',
    );
  }
}
