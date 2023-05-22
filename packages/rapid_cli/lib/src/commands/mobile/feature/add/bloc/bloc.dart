import 'package:rapid_cli/src/commands/core/platform/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template mobile_feature_add_bloc_command}
/// `rapid mobile feature add bloc` command adds a bloc to a feature of the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileFeatureAddBlocCommand extends PlatformFeatureAddBlocCommand {
  /// {@macro mobile_feature_add_bloc_command}
  MobileFeatureAddBlocCommand({
    super.logger,
    super.project,
    required super.featurePackage,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.mobile,
        );
}
