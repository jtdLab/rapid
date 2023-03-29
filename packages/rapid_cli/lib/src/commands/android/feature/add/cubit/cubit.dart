import 'package:rapid_cli/src/commands/core/platform/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_feature_add_cubit_command}
/// `rapid android add feature` command adds a cubit to a feature of the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidFeatureAddCubitCommand extends PlatformFeatureAddCubitCommand {
  /// {@macro android_feature_add_cubit_command}
  AndroidFeatureAddCubitCommand({
    super.logger,
    required super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.android,
        );
}
