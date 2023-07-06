import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/project/project.dart';

import '../commands/runner.dart';
import '../logging.dart';
import '../utils.dart';

/// {@template rapid_command}
/// Base class for all Rapid commands.
/// {@endtemplate}
abstract class RapidCommand extends Command<void> {
  /// {@macro rapid_command}
  RapidCommand([this.project]);

  final RapidProject? project;
}

abstract class RapidBranchCommand extends RapidCommand {
  RapidBranchCommand([super.project]);
}

abstract class RapidLeafCommand extends RapidCommand {
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
