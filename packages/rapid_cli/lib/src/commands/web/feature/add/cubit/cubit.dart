import 'package:rapid_cli/src/commands/core/platform/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template web_feature_add_cubit_command}
/// `rapid web add feature` command adds a cubit to a feature of the Web part of an existing Rapid project.
/// {@endtemplate}
class WebFeatureAddCubitCommand extends PlatformFeatureAddCubitCommand {
  /// {@macro web_feature_add_cubit_command}
  WebFeatureAddCubitCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.web,
        );
}
