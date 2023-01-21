import 'package:rapid_cli/src/commands/core/platform/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template linux_feature_add_cubit_command}
/// `rapid linux add feature` command adds a cubit to a feature of the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxFeatureAddCubitCommand extends PlatformFeatureAddCubitCommand {
  /// {@macro linux_feature_add_cubit_command}
  LinuxFeatureAddCubitCommand({
    super.logger,
    required super.project,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.generator,
  }) : super(
          platform: Platform.linux,
        );
}
