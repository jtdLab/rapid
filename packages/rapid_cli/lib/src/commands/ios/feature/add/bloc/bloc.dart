import 'package:rapid_cli/src/commands/core/platform/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template ios_feature_add_bloc_command}
/// `rapid ios feature add bloc` command adds a bloc to a feature of the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosFeatureAddBlocCommand extends PlatformFeatureAddBlocCommand {
  /// {@macro ios_feature_add_bloc_command}
  IosFeatureAddBlocCommand({
    super.logger,
    required super.project,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.generator,
  }) : super(
          platform: Platform.ios,
        );
}
