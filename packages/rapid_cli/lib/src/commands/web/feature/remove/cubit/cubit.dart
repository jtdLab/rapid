import 'package:rapid_cli/src/commands/core/platform/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template web_feature_remove_cubit_command}
/// `rapid web feature remove cubit` command removes a cubit from a feature of the Web part of an existing Rapid project.
/// {@endtemplate}
class WebFeatureRemoveCubitCommand extends PlatformFeatureRemoveCubitCommand {
  /// {@macro web_feature_remove_cubit_command}
  WebFeatureRemoveCubitCommand({
    super.logger,
    super.project,
    required super.featurePackage,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.web,
        );
}
