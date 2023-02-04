import 'dart:async';
import 'dart:convert';

import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'dart:io';

part 'dart_cli.dart';
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

/// Signature for [Process.start].
typedef StartProcess = Future<Process> Function(
  String executable,
  List<String> arguments, {
  String? workingDirectory,
  bool runInShell,
});

/// This class facilitates overriding [Process.start] and [Process.run].
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
    StartProcess? startProcess,
    RunProcess? runProcess,
  }) {
    final overrides = _ProcessOverridesScope(startProcess, runProcess);
    return _asyncRunZoned(body, zoneValues: {_token: overrides});
  }

  /// The method used to start a [Process].
  StartProcess get startProcess => Process.start;

  /// The method used to run a [Process].
  RunProcess get runProcess => Process.run;
}

class _ProcessOverridesScope extends ProcessOverrides {
  _ProcessOverridesScope(this._startProcess, this._runProcess);

  final ProcessOverrides? _previous = ProcessOverrides.current;
  final StartProcess? _startProcess;
  final RunProcess? _runProcess;

  @override
  StartProcess get startProcess {
    return _startProcess ?? _previous?.startProcess ?? super.startProcess;
  }

  @override
  RunProcess get runProcess {
    return _runProcess ?? _previous?.runProcess ?? super.runProcess;
  }
}

/// Abstraction for running commands via command-line.
abstract class _Cmd {
  /// Runs the specified [cmd] with the provided [args].
  static Future<ProcessResult> run(
    String cmd,
    List<String> args, {
    bool throwOnError = true,
    String? workingDirectory,
    required Logger logger,
  }) async {
    final startProcess =
        ProcessOverrides.current?.startProcess ?? Process.start;
    final process = await startProcess(
      cmd,
      args,
      workingDirectory: workingDirectory,
      runInShell: true,
    );

    final stdout = <String>[];
    final stderr = <String>[];
    process.stdout.listen((event) {
      final msg = utf8.decode(event);
      stdout.add(msg);
      logger.detail(msg);
    });
    process.stderr.listen((event) {
      final msg = utf8.decode(event);
      stdout.add(msg);
      logger.detail(red.wrap(msg));
    });

    final exitCode = await process.exitCode;

    if (throwOnError) {
      _throwIfProcessFailed(exitCode, stdout, stderr, cmd, args);
    }

    return ProcessResult(process.pid, exitCode, stdout, stderr);
  }

  static void _throwIfProcessFailed(
    int exitCode,
    List<String> stdout,
    List<String> stderr,
    String cmd,
    List<String> args,
  ) {
    if (exitCode != 0) {
      final values = {
        'Stdout:': stdout.join('\n').trim(),
        'Stderr:': stderr.join('\n').trim(),
      }..removeWhere((k, v) => v.isEmpty);

      var message = 'Unknown error';
      if (values.isNotEmpty) {
        message = values.entries.map((e) => '${e.key}\n${e.value}').join('\n');
      }

      throw ProcessException(cmd, args, message, exitCode);
    }
  }
}
