import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'platform.dart';
import 'process.dart';

const globalOptionVersion = 'version';
const globalOptionVerbose = 'verbose';

String multiLine(List<String> lines) => lines.join('\n');

const envKeyRapidTerminalWidth = 'RAPID_TERMINAL_WIDTH';

String pubspecYamlPathForDirectory(String directory) =>
    p.join(directory, 'pubspec.yaml');

int get terminalWidth {
  if (currentPlatform.environment.containsKey(envKeyRapidTerminalWidth)) {
    return int.tryParse(
          currentPlatform.environment[envKeyRapidTerminalWidth]!,
          radix: 10,
        ) ??
        80;
  }

  if (stdout.hasTerminal) {
    return stdout.terminalColumns;
  }

  return 80;
}

Future<ProcessResult> runCommand(
  List<String> cmd, {
  String? workingDirectory,
}) async {
  return currentProcessManager.run(
    cmd,
    workingDirectory: workingDirectory,
    runInShell: true,
    stderrEncoding: utf8,
    stdoutEncoding: utf8,
  );
}

Future<Process> startCommand(
  List<String> cmd, {
  String? workingDirectory,
}) async {
  return currentProcessManager.start(
    cmd,
    workingDirectory: workingDirectory,
    runInShell: true,
  );
}

extension YamlUtils on YamlNode {
  /// Converts a YAML node to a regular mutable Dart object.
  Object? toPlainObject() {
    final node = this;
    if (node is YamlScalar) {
      return node.value;
    }
    if (node is YamlMap) {
      return {
        for (final entry in node.nodes.entries)
          (entry.key as YamlNode).toPlainObject(): entry.value.toPlainObject(),
      };
    }
    if (node is YamlList) {
      return node.nodes.map((node) => node.toPlainObject()).toList();
    }
    throw FormatException(
      'Unsupported YAML node type encountered: ${node.runtimeType}',
      this,
    );
  }
}

extension StreamUtils<T> on Stream<T> {
  /// Runs [convert] for each event in this stream and emits the result, while
  /// ensuring that no more events than specified by [parallelism] are being
  /// processed at any given time.
  ///
  /// If [parallelism] is `null`, [Platform.numberOfProcessors] is used.
  Stream<R> parallel<R>(
    Future<R> Function(T) convert, {
    int? parallelism,
  }) async* {
    final pending = <Future<R>>[];
    final done = <Future<R>>[];

    await for (final value in this) {
      late final Future<R> future;
      future = Future(() async {
        try {
          return await convert(value);
        } finally {
          pending.remove(future);
          done.add(future);
        }
      });
      pending.add(future);

      if (pending.length < (parallelism ?? Platform.numberOfProcessors)) {
        continue;
      }

      await Future.any(pending);

      for (final future in done) {
        yield await future;
      }
      done.clear();
    }

    for (final result in await Future.wait(pending)) {
      yield result;
    }
  }
}
