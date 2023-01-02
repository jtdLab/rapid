import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_feature_add_cubit_command}
/// `rapid android add feature` command adds a cubit to a feature of the Android part of an existing Rapid project.
/// {@endtemplate}
class CubitCommand extends PlatformFeatureAddCubitCommand {
  /// {@macro android_feature_add_cubit_command}
  CubitCommand({
    Logger? logger,
    required super.project,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    GeneratorBuilder? generator,
  }) : super(
          platform: Platform.android,
          logger: logger ?? Logger(),
          flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
              flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                  Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
          generator: generator ?? MasonGenerator.fromBundle,
        );
}
