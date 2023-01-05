import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/platform/add/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_add_feature_command}
/// `rapid android add feature` command adds a feature to the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidAddFeatureCommand extends PlatformAddFeatureCommand {
  /// {@macro android_add_feature_command}
  AndroidAddFeatureCommand({
    Logger? logger,
    required super.project,
    GeneratorBuilder? generator,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
  }) : super(
          platform: Platform.android,
          logger: logger ?? Logger(),
          generator: generator ?? MasonGenerator.fromBundle,
          melosBootstrap: melosBootstrap ?? Melos.bootstrap,
          melosClean: melosClean ?? Melos.clean,
        );
}
