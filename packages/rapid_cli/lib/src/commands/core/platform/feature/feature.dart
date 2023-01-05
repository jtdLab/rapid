import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template platform_feature_command}
/// Base class for TODO
/// {@endtemplate}
abstract class PlatformFeatureCommand extends Command<int> {
  /// {@macro platform_feature_command}
  PlatformFeatureCommand({
    required Platform platform,
    required PlatformFeatureAddCommand addCommand,
  }) : _platform = platform {
    addSubcommand(addCommand);
  }

  final Platform _platform;

  @override
  String get name => 'feature';

  @override
  List<String> get aliases => ['feat'];

  @override
  String get invocation => 'rapid ${_platform.name} features <subcommand>';

  @override
  String get description =>
      'Work with features of the ${_platform.prettyName} part of an existing Rapid project.';
}
