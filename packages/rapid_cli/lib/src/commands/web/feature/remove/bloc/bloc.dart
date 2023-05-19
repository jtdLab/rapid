import 'package:rapid_cli/src/commands/core/platform/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template web_feature_remove_bloc_command}
/// `rapid web feature remove bloc` command removes a bloc from a feature of the Web part of an existing Rapid project.
/// {@endtemplate}
class WebFeatureRemoveBlocCommand extends PlatformFeatureRemoveBlocCommand {
  /// {@macro web_feature_remove_bloc_command}
  WebFeatureRemoveBlocCommand({
    super.logger,
    super.project,
    required super.featurePackage,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.web,
        );
}
