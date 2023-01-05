import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_remove_feature_command}
/// `rapid android remove feature` command removes a feature from the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidRemoveFeatureCommand extends PlatformRemoveFeatureCommand {
  /// {@macro android_remove_feature_command}
  AndroidRemoveFeatureCommand({
    Logger? logger,
    required super.project,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
  }) : super(
          platform: Platform.android,
          logger: logger ?? Logger(),
          melosBootstrap: melosBootstrap ?? Melos.bootstrap,
          melosClean: melosClean ?? Melos.clean,
        );
}
