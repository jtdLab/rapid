import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

import '../commands/runner.dart';
import '../logging.dart';
import '../project/project.dart';
import '../utils.dart';

/// {@template rapid_command}
/// Base class for all Rapid commands.
/// {@endtemplate}
abstract class RapidCommand extends Command<void> {
  RapidCommand([this.project]);

  final RapidProject? project;

  @override
  late final ArgParser argParser = ArgParser(
    usageLineLength: terminalWidth,
  );
}

/// {@template rapid_branch_command}
/// Base class for all Rapid commands that handle branching.
/// {@endtemplate}
abstract class RapidBranchCommand extends RapidCommand {
  /// {@macro rapid_branch_command}
  RapidBranchCommand([super.project]);
}

/// {@template rapid_leaf_command}
/// Base class for all Rapid commands executing functionality.
/// {@endtemplate}
abstract class RapidLeafCommand extends RapidCommand {
  /// {@macro rapid_leaf_command}
  RapidLeafCommand([super.project]);

  late final verbose = globalResults![globalOptionVerbose] as bool;

  late final logger = RapidLogger(
    level: verbose ? Level.verbose : Level.info,
  );

  /// [ArgResults] which can be overridden for testing.
  @visibleForTesting
  ArgResults? argResultOverrides;

  @override
  ArgResults get argResults => argResultOverrides ?? super.argResults!;

  /// [Rapid] which can be overridden for testing.
  @visibleForTesting
  Rapid? rapidOverrides;

  Rapid get rapid => rapidOverrides ?? Rapid(project: project, logger: logger);
}
