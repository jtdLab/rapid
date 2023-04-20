import 'package:rapid_cli/src/commands/core/platform/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template linux_feature_add_bloc_command}
/// `rapid linux feature add bloc` command adds a bloc to a feature of the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxFeatureAddBlocCommand extends PlatformFeatureAddBlocCommand {
  /// {@macro linux_feature_add_bloc_command}
  LinuxFeatureAddBlocCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.linux,
        );
}
