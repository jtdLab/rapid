import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_feature_add_bloc_command}
/// `rapid android feature add bloc` command adds a bloc to a feature of the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidFeatureAddBlocCommand extends PlatformFeatureAddBlocCommand {
  /// {@macro android_feature_add_bloc_command}
  AndroidFeatureAddBlocCommand({
    super.logger,
    required super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.android,
        );
}
