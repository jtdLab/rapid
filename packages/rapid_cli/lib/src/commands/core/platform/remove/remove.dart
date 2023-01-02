import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template platform_remove_command}
/// Base class for // TODO
/// {@endtemplate}
abstract class PlatformRemoveCommand extends Command<int> {
  /// {@macro platform_remove_command}
  PlatformRemoveCommand({
    required Platform platform,
    required PlatformRemoveFeatureCommand featureCommand,
    required PlatformRemoveLanguageCommand languageCommand,
  }) : _platform = platform {
    addSubcommand(featureCommand);
    addSubcommand(languageCommand);
  }

  final Platform _platform;

  @override
  String get name => 'remove';

  @override
  String get description =>
      'Removes features or languages from the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  String get invocation => 'rapid ${_platform.name} remove <subcommand>';
}
