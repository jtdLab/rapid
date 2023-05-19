import 'package:rapid_cli/src/commands/core/platform/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template web_feature_add_bloc_command}
/// `rapid web feature add bloc` command adds a bloc to a feature of the Web part of an existing Rapid project.
/// {@endtemplate}
class WebFeatureAddBlocCommand extends PlatformFeatureAddBlocCommand {
  /// {@macro web_feature_add_bloc_command}
  WebFeatureAddBlocCommand({
    super.logger,
    super.project,
    required super.featurePackage,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.web,
        );
}
