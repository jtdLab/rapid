import 'package:rapid_cli/src/commands/core/platform/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ios_feature_remove_cubit_command}
/// `rapid ios feature remove cubit` command removes a cubit from a feature of the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosFeatureRemoveCubitCommand extends PlatformFeatureRemoveCubitCommand {
  /// {@macro ios_feature_remove_cubit_command}
  IosFeatureRemoveCubitCommand({
    super.logger,
    super.project,
    required super.featurePackage,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.ios,
        );
}
