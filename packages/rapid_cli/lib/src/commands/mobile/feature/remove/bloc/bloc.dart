import 'package:rapid_cli/src/commands/core/platform/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template mobile_feature_remove_bloc_command}
/// `rapid mobile feature remove bloc` command removes a bloc from a feature of the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileFeatureRemoveBlocCommand extends PlatformFeatureRemoveBlocCommand {
  /// {@macro mobile_feature_remove_bloc_command}
  MobileFeatureRemoveBlocCommand({
    super.logger,
    super.project,
    required super.featurePackage,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.mobile,
        );
}
