import 'package:rapid_cli/src/commands/core/platform/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template mobile_feature_remove_cubit_command}
/// `rapid mobile feature remove cubit` command removes a cubit from a feature of the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileFeatureRemoveCubitCommand
    extends PlatformFeatureRemoveCubitCommand {
  /// {@macro mobile_feature_remove_cubit_command}
  MobileFeatureRemoveCubitCommand({
    super.logger,
    super.project,
    required super.featurePackage,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.mobile,
        );
}
