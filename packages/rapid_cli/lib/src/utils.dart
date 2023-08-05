import 'dart:convert';

import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:yaml/yaml.dart';

import 'io.dart';
import 'platform.dart';
import 'process.dart';

export 'package:pubspec/pubspec.dart';

// The regex for a dart package name, i.e. no capital letters.
// https://dart.dev/guides/language/language-tour#important-concepts
final dartPackageRegExp = RegExp('[a-z_][a-z0-9_]*');

const globalOptionVersion = 'version';
const globalOptionVerbose = 'verbose';

String multiLine(List<String> lines) => lines.join('\n');

const envKeyRapidTerminalWidth = 'RAPID_TERMINAL_WIDTH';

int get terminalWidth {
  if (currentPlatform.environment.containsKey(envKeyRapidTerminalWidth)) {
    return int.tryParse(
          currentPlatform.environment[envKeyRapidTerminalWidth]!,
          radix: 10,
        ) ??
        80;
  }

  return stdout.hasTerminal ? stdout.terminalColumns : 80;
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

// TODO rm or keep
/* Future<Process> startCommand(
  List<String> cmd, {
  String? workingDirectory,
}) async {
  return currentProcessManager.start(
    cmd,
    workingDirectory: workingDirectory,
    runInShell: true,
  );
} */

extension DirectoryUtils on Directory {
  bool isEmpty() {
    return listSync().isEmpty;
  }
}

extension YamlUtils on YamlNode {
  /// Converts a YAML node to a regular mutable Dart object.
  Object toPlainObject() {
    final node = this;
    if (node is YamlMap) {
      return {
        for (final entry in node.nodes.entries)
          (entry.key as YamlNode).toPlainObject(): entry.value.toPlainObject(),
      };
    }
    if (node is YamlList) {
      return node.nodes.map((node) => node.toPlainObject()).toList();
    }

    return (node as YamlScalar).value;
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

      final numberOfProcessors = currentPlatform.numberOfProcessors;
      if (pending.length < (parallelism ?? numberOfProcessors)) {
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

extension LanguageUtils on Language {
  bool get needsFallback => hasScriptCode || hasCountryCode;

  Language fallback() => Language(languageCode: languageCode);
}

extension DartPackageListUtils on List<DartPackage> {
  List<DartPackage> without(List<DartPackage> packages) {
    // TODO maybe override euqality in DartPackage
    return this
      ..removeWhere(
        (e) => packages.map((e) => e.packageName).contains(e.packageName),
      );
  }
}

Map<String, dynamic> platformVars(Platform? platform) {
  return {
    if (platform != null) 'platform': platform.name,
    'android': false,
    'ios': false,
    'linux': false,
    'macos': false,
    'web': false,
    'windows': false,
    'mobile': false,
    if (platform != null) platform.name: true
  };
}
