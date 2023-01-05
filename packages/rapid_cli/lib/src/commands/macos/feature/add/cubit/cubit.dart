import 'package:rapid_cli/src/commands/core/platform/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template macos_feature_add_cubit_command}
/// `rapid macos add feature` command adds a cubit to a feature of the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosFeatureAddCubitCommand extends PlatformFeatureAddCubitCommand {
  /// {@macro macos_feature_add_cubit_command}
  MacosFeatureAddCubitCommand({
    super.logger,
    required super.project,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.generator,
  }) : super(
          platform: Platform.macos,
        );
}
