import 'package:rapid_cli/src/commands/core/platform/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ios_feature_add_cubit_command}
/// `rapid ios add feature` command adds a cubit to a feature of the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosFeatureAddCubitCommand extends PlatformFeatureAddCubitCommand {
  /// {@macro ios_feature_add_cubit_command}
  IosFeatureAddCubitCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.ios,
        );
}
