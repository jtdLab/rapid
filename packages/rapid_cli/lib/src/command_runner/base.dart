import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

import '../commands/runner.dart';
import '../logging.dart';
import '../project/platform.dart';
import '../project/project.dart';
import '../utils.dart';

/// {@template rapid_command}
/// Base class for all Rapid commands.
/// {@endtemplate}
abstract class RapidCommand extends Command<void> {
  /// {@macro rapid_command}
  RapidCommand(this.project);

  /// The project this command should be run on.
  ///
  /// Can be null because certain commands might not have a project available.
  /// This currently is only true for `rapid create` command.
  final RapidProject? project;

  @override
  late final ArgParser argParser = ArgParser(
    usageLineLength: terminalWidth,
  );
}

/// {@template rapid_branch_command}
/// Base class for all Rapid commands that handle branching.
///
/// A branching command is one that holds one or more subcommands and does not
/// run its own functionality.
///
/// {@endtemplate}
abstract class RapidBranchCommand extends RapidCommand {
  /// {@macro rapid_branch_command}
  RapidBranchCommand(super.project);
}

/// {@template rapid_leaf_command}
/// Base class for all Rapid commands executing functionality.
/// {@endtemplate}
abstract class RapidLeafCommand extends RapidCommand {
  /// {@macro rapid_leaf_command}
  RapidLeafCommand([super.project]);

  /// Returns wether verbose logging is enabled for this command.
  late final verbose = globalResults![globalOptionVerbose] as bool;

  /// The [RapidLogger] instance used by this command to communicate messages
  /// to the user.
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

  /// The [Rapid] instance used by this command to execute its functionality.
  Rapid get rapid => rapidOverrides ?? Rapid(project: project, logger: logger);
}

/// {@template rapid_platform_branch_command}
/// Base class for all Rapid branch commands which are associated with a
/// platform.
/// {@endtemplate}
abstract class RapidPlatformBranchCommand extends RapidBranchCommand {
  /// {@macro rapid_platform_branch_command}
  RapidPlatformBranchCommand(
    super.project, {
    required this.platform,
  });

  /// The platform this command is associated with.
  final Platform platform;
}

/// {@template rapid_platform_leaf_command}
/// Base class for all Rapid leaf commands which are associated with a platform.
/// {@endtemplate}
abstract class RapidPlatformLeafCommand extends RapidLeafCommand {
  /// {@macro rapid_platform_leaf_command}
  RapidPlatformLeafCommand(
    super.project, {
    required this.platform,
  });

  /// The platform this command is associated with.
  final Platform platform;
}

/// {@template rapid_platform_feature_branch_command}
/// Base class for all Rapid branch commands which are associated with a
/// platform and feature.
/// {@endtemplate}
abstract class RapidPlatformFeatureBranchCommand
    extends RapidPlatformBranchCommand {
  /// {@macro rapid_platform_feature_branch_command}
  RapidPlatformFeatureBranchCommand(
    super.project, {
    required super.platform,
    required this.featureName,
  });

  /// The name of the feature this command is associated with.
  final String featureName;
}

/// {@template rapid_platform_feature_leaf_command}
/// Base class for all Rapid leaf commands which are associated with a platform
/// and feature.
/// {@endtemplate}
abstract class RapidPlatformFeatureLeafCommand
    extends RapidPlatformLeafCommand {
  /// {@macro rapid_platform_feature_leaf_command}
  RapidPlatformFeatureLeafCommand(
    super.project, {
    required super.platform,
    required this.featureName,
  });

  /// The name of the feature this command is associated with.
  final String featureName;
}

/// {@template rapid_sub_domain_branch_command}
/// Base class for all Rapid branch commands which are associated with a
/// subdomain.
/// {@endtemplate}
abstract class RapidSubDomainBranchCommand extends RapidBranchCommand {
  /// {@macro rapid_sub_domain_branch_command}
  RapidSubDomainBranchCommand(
    super.project, {
    required this.subDomainName,
  });

  /// The name of subdomain this command is associated with.
  final String subDomainName;
}

/// {@template rapid_sub_domain_leaf_command}
/// Base class for all Rapid leaf commands which are associated with a
/// subdomain.
/// {@endtemplate}
abstract class RapidSubDomainLeafCommand extends RapidLeafCommand {
  /// {@macro rapid_sub_domain_leaf_command}
  RapidSubDomainLeafCommand(
    super.project, {
    required this.subDomainName,
  });

  /// The name of subdomain this command is associated with.
  final String subDomainName;
}

/// {@template rapid_sub_infrastructure_branch_command}
/// Base class for all Rapid branch commands which are associated with a
/// subinfrastructure.
/// {@endtemplate}
abstract class RapidSubInfrastructureBranchCommand extends RapidBranchCommand {
  /// {@macro rapid_sub_infrastructure_branch_command}
  RapidSubInfrastructureBranchCommand(
    super.project, {
    required this.subInfrastructureName,
  });

  /// The name of subinfrastructure this command is associated with.
  final String subInfrastructureName;
}

/// {@template rapid_sub_infrastructure_leaf_command}
/// Base class for all Rapid leaf commands which are associated with a
/// subinfrastructure.
/// {@endtemplate}
abstract class RapidSubInfrastructureLeafCommand extends RapidLeafCommand {
  /// {@macro rapid_sub_infrastructure_leaf_command}
  RapidSubInfrastructureLeafCommand(
    super.project, {
    required this.subInfrastructureName,
  });

  /// The name of subinfrastructure this command is associated with.
  final String subInfrastructureName;
}
