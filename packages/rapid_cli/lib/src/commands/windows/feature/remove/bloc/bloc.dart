import 'package:rapid_cli/src/commands/core/platform/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template windows_feature_remove_bloc_command}
/// `rapid windows feature remove bloc` command removes a bloc from a feature of the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsFeatureRemoveBlocCommand extends PlatformFeatureRemoveBlocCommand {
  /// {@macro windows_feature_remove_bloc_command}
  WindowsFeatureRemoveBlocCommand({
    super.logger,
    super.project,
    required super.featurePackage,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.windows,
        );
}
