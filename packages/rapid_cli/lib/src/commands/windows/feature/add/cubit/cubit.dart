import 'package:rapid_cli/src/commands/core/platform/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template windows_feature_add_cubit_command}
/// `rapid windows add feature` command adds a cubit to a feature of the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsFeatureAddCubitCommand extends PlatformFeatureAddCubitCommand {
  /// {@macro windows_feature_add_cubit_command}
  WindowsFeatureAddCubitCommand({
    super.logger,
    required super.project,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.generator,
  }) : super(
          platform: Platform.windows,
        );
}
