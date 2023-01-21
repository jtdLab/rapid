import 'dart:async';
import 'dart:convert';

import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:universal_io/io.dart';

part 'flutter_cli.dart';
part 'melos_cli.dart';

const _asyncRunZoned = runZoned;

/// Signature for [Process.run].
typedef RunProcess = Future<ProcessResult> Function(
  String executable,
  List<String> arguments, {
  String? workingDirectory,
  bool runInShell,
});

/// This class facilitates overriding [Process.run].
/// It should be extended by another class in client code with overrides
/// that construct a custom implementation.
@visibleForTesting
abstract class ProcessOverrides {
  static final _token = Object();

  /// Returns the current [ProcessOverrides] instance.
  ///
  /// This will return `null` if the current [Zone] does not contain
  /// any [ProcessOverrides].
  ///
  /// See also:
  /// * [ProcessOverrides.runZoned] to provide [ProcessOverrides]
  /// in a fresh [Zone].
  ///
  static ProcessOverrides? get current {
    return Zone.current[_token] as ProcessOverrides?;
  }

  /// Runs [body] in a fresh [Zone] using the provided overrides.
  static R runZoned<R>(
    R Function() body, {
    RunProcess? runProcess,
  }) {
    final overrides = _ProcessOverridesScope(runProcess);
    return _asyncRunZoned(body, zoneValues: {_token: overrides});
  }

  /// The method used to run a [Process].
  RunProcess get runProcess => Process.run;
}

class _ProcessOverridesScope extends ProcessOverrides {
  _ProcessOverridesScope(this._runProcess);

  final ProcessOverrides? _previous = ProcessOverrides.current;
  final RunProcess? _runProcess;

  @override
  RunProcess get runProcess {
    return _runProcess ?? _previous?.runProcess ?? super.runProcess;
  }
}

/// Abstraction for running commands via command-line.
abstract class _Cmd {
  /// Runs the specified [cmd] with the provided [args].
  static Future<int> run(
    String cmd,
    List<String> args, {
    bool throwOnError = true,
    String? workingDirectory,
    required Logger logger,
  }) async {
    logger.detail('Running: $cmd with $args');
    final process = await Process.start(
      cmd,
      args,
      workingDirectory: workingDirectory,
      runInShell: true,
    );
    process.stdout.listen((event) {
      logger.detail(utf8.decode(event));
    });
    process.stderr.listen((event) {
      logger.detail(utf8.decode(event));
    });

    final exitCode = await process.exitCode;
    return exitCode;
    /*  final runProcess = ProcessOverrides.current?.runProcess ?? Process.run;
    final result = await runProcess(
      cmd,
      args,
      workingDirectory: workingDirectory,
      runInShell: true,
    );
    logger
      ..detail('stdout:\n${result.stdout}')
      ..detail('stderr:\n${result.stderr}'); 

    if (throwOnError) {
      _throwIfProcessFailed(result, cmd, args);
    }
    return result;
    */
  }

  static void _throwIfProcessFailed(
    ProcessResult result,
    String cmd,
    List<String> args,
  ) {
    if (result.exitCode != 0) {
      final values = {
        'Standard out': result.stdout.toString().trim(),
        'Standard error': result.stderr.toString().trim()
      }..removeWhere((k, v) => v.isEmpty);

      var message = 'Unknown error';
      if (values.isNotEmpty) {
        message = values.entries.map((e) => '${e.key}\n${e.value}').join('\n');
      }

      throw ProcessException(cmd, args, message, result.exitCode);
    }
  }
}
