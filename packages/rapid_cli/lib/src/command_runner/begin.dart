import 'dart:async';

import 'base.dart';

/// {@template begin_command}
/// `rapid begin` command starts a group of Rapid command executions.
/// {@endtemplate}
class BeginCommand extends RapidLeafCommand {
  /// {@macro begin_command}
  BeginCommand(super.project);

  @override
  String get name => 'begin';

  @override
  String get invocation => 'rapid begin';

  @override
  String get description => 'Starts a group of Rapid command executions.';

  @override
  Future<void> run() {
    return rapid.begin();
  }
}
