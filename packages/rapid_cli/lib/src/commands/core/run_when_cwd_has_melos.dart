import 'package:mason/mason.dart';
import 'package:rapid_cli/src/project/project.dart';

/// Runs [callback] when [project] has an existing melos file.
///
/// This function is commonly used in rapid commands that only run from the root of a rapid project.
Future<int> runWhenCwdHasMelos(
  Project project,
  Logger logger,
  Future<int> Function() callback,
) async {
  final cwdHasMelos = project.melosFile.exists();

  if (cwdHasMelos) {
    return callback();
  } else {
    logger.err(
      '''
 Could not find a melos.yaml.
 This command should be run from the root of your Rapid project.''',
    );
    return ExitCode.noInput.code;
  }
}
