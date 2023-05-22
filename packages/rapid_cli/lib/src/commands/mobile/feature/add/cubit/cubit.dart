import 'package:rapid_cli/src/commands/core/platform/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template mobile_feature_add_cubit_command}
/// `rapid mobile add feature` command adds a cubit to a feature of the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileFeatureAddCubitCommand extends PlatformFeatureAddCubitCommand {
  /// {@macro mobile_feature_add_cubit_command}
  MobileFeatureAddCubitCommand({
    super.logger,
    super.project,
    required super.featurePackage,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.mobile,
        );
}
