import 'package:rapid_cli/src/commands/core/platform/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template macos_feature_add_bloc_command}
/// `rapid macos feature add bloc` command adds a bloc to a feature of the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosFeatureAddBlocCommand extends PlatformFeatureAddBlocCommand {
  /// {@macro macos_feature_add_bloc_command}
  MacosFeatureAddBlocCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.macos,
        );
}
