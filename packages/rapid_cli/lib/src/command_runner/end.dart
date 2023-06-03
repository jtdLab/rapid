import 'dart:async';

import 'base.dart';

// TODO: e2e test

/// {@template end_command}
/// `rapid end` command starts a group of Rapid command executions.
class EndCommand extends RapidLeafCommand {
  /// {@macro end_command}
  EndCommand(super.project);

  @override
  String get name => 'end';

  @override
  String get invocation => 'rapid end';

  @override
  String get description => 'Ends a group of Rapid command executions.';

  @override
  Future<void> run() {
    return rapid.end();
  }
}
