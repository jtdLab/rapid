import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_remove_feature_command}
/// `rapid android remove feature` command removes a feature from the Android part of an existing Rapid project.
/// {@endtemplate}
class FeatureCommand extends PlatformRemoveFeatureCommand {
  /// {@macro android_remove_feature_command}
  FeatureCommand({
    super.logger,
    required super.project,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
  }) : super(
          platform: Platform.android,
          melosBootstrap: Melos.bootstrap,
          melosClean: Melos.clean,
        );
}
