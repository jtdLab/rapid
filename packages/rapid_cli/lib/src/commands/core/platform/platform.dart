import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
/* import 'package:rapid_cli/src/commands/ios/ios.dart';
import 'package:rapid_cli/src/commands/linux/linux.dart';
import 'package:rapid_cli/src/commands/web/web.dart';
import 'package:rapid_cli/src/commands/macos/macos.dart';
import 'package:rapid_cli/src/commands/linux/linux.dart'; */
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/platform/add/add.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO sort vars and methods alphabetically

/// {@template platform_command}
/// Base class for // TODO
/// {@endtemplate}
abstract class PlatformCommand extends Command<int> with OverridableArgResults {
  /// {@macro platform_command}
  PlatformCommand({
    required Platform platform,
    required Logger logger,
    required Project project,
    required PlatformAddCommand addCommand,
    required PlatformFeatureCommand featureCommand,
    required PlatformRemoveCommand removeCommand,
  }) : _platform = platform {
    addSubcommand(addCommand);
    addSubcommand(featureCommand);
    addSubcommand(removeCommand);
  }

  final Platform _platform;

  @override
  String get name => _platform.name;

  @override
  String get description =>
      'Work with the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  String get invocation => 'rapid ${_platform.name} <subcommand>';

  @override
  List<String> get aliases => _platform.aliases;
}
