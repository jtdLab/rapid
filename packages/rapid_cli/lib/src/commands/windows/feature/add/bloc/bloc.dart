import 'package:rapid_cli/src/commands/core/platform/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template windows_feature_add_bloc_command}
/// `rapid windows feature add bloc` command adds a bloc to a feature of the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsFeatureAddBlocCommand extends PlatformFeatureAddBlocCommand {
  /// {@macro windows_feature_add_bloc_command}
  WindowsFeatureAddBlocCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.windows,
        );
}
