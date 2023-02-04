import 'dart:io';

import 'package:rapid_cli/src/command_runner.dart';

Future<void> main(List<String> args) async {
  await _flushThenExit(await RapidCommandRunner().run(args));
}

/// Flushes stdout and stderr streams, then exits the program with
/// [status] code.
Future<void> _flushThenExit(int status) {
  return Future.wait<void>([stdout.close(), stderr.close()])
      .then<void>((_) => exit(status));
}
