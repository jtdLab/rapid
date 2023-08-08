import 'dart:convert';

import 'package:yaml/yaml.dart';

import 'io/io.dart' hide Platform;
import 'project/language.dart';
import 'project/platform.dart';

export 'package:pubspec/pubspec.dart';

/// The regex for a dart package name, i.e. no capital letters.
/// https://dart.dev/guides/language/language-tour#important-concepts
final dartPackageRegExp = RegExp('[a-z_][a-z0-9_]*');

/// A constant representing the `version` global option of the CLI.
const globalOptionVersion = 'version';

/// A constant representing the `verbose` global option of the CLI.
const globalOptionVerbose = 'verbose';

/// Joins [lines] into a single multi-line string using '\n' as the separator.
String multiLine(List<String> lines) => lines.join('\n');

/// The environment variable key for specifying the terminal width.
///
/// Used to overrides terminal width in tests.
const envKeyRapidTerminalWidth = 'RAPID_TERMINAL_WIDTH';

/// Gets the terminal width for the current environment.
///
/// Can be overriden for testing by setting [envKeyRapidTerminalWidth] like:
///
/// ```dart main
/// runZoned(
///   () { /* code with custom terminal width here */ },
///   zoneValues: {
///     currentPlatformZoneKey: FakePlatform(
///       // Simulate terminal with width 1024
///       environment: {envKeyRapidTerminalWidth: '1024'},
///     ),
///   },
/// );
/// ```
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

/// Runs [cmd] asynchronously and returns the process result.
///
/// Use [workingDirectory] to set the working directory for the process.
///
/// Can be overriden for testing by setting [currentProcessManagerZoneKey] like:
///
/// ```dart main
/// final processManager = MockProcessManager();
/// runZoned(
///   () { /* code with mock process manager here */ },
///   zoneValues: {
///     currentProcessManagerZoneKey: processManager,
///   },
/// );
/// ```
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

/// Extension on the [Platform] class to provide some utility functions.
extension PlatformUtils on Platform {
  /// Returns a list of aliases for this platform used by commands to make
  /// their invocation simpler.
  List<String> get aliases {
    switch (this) {
      case Platform.android:
        return ['a'];
      case Platform.ios:
        return ['i'];
      case Platform.web:
        return [];
      case Platform.linux:
        return ['l', 'lin'];
      case Platform.macos:
        return ['mac'];
      case Platform.windows:
        return ['win'];
      case Platform.mobile:
        return [];
    }
  }

  /// Returns a human-readable representation of this platform.
  String get prettyName {
    switch (this) {
      case Platform.android:
        return 'Android';
      case Platform.ios:
        return 'iOS';
      case Platform.web:
        return 'Web';
      case Platform.linux:
        return 'Linux';
      case Platform.macos:
        return 'macOS';
      case Platform.windows:
        return 'Windows';
      case Platform.mobile:
        return 'Mobile';
    }
  }
}

/// Extension on the [Directory] class to provide some utility functions.
extension DirectoryUtils on Directory {
  /// Returns `true` if this directory contains nothing.
  bool isEmpty() {
    return listSync().isEmpty;
  }
}

/// Extension on the [YamlNode] class to provide some utility functions.
extension YamlUtils on YamlNode {
  /// Converts this yaml node to a regular mutable Dart object.
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

    return (node as YamlScalar).value as Object;
  }
}

/// Extension on the [Stream] class to provide some utility functions.
extension StreamUtils<T> on Stream<T> {
  /// Runs [convert] for each event in this stream and emits the result, while
  /// ensuring that no more events than specified by [parallelism] are being
  /// processed at any given time.
  ///
  /// If [parallelism] is `null`, the [currentPlatform]s `numberOfProcessors`
  /// is used.
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

/// Extension on the [Language] class to provide some utility functions.
extension LanguageUtils on Language {
  /// Returns `true` if this language requires a fallback language.
  bool get needsFallback => hasScriptCode || hasCountryCode;

  /// Returns the fallback language of this language.
  Language fallback() => Language(languageCode: languageCode);
}

/// Extension class to provide utility functions for lists of [DartPackage].
extension DartPackageListUtils on List<DartPackage> {
  /// Returns this list of [DartPackage]s without [packages].
  ///
  /// Elements are considered equal if their `packageName` matches.
  List<DartPackage> without(List<DartPackage> packages) {
    final packageNames = packages.map((e) => e.packageName);
    return where((e) => !packageNames.contains(e.packageName)).toList();
  }
}

/// Helper to generate a map of [platform]-related variables used when
/// generating files from templates using [mason](https://pub.dev/packages/mason).
///
/// If platform is `null` the returned map only contains an entry for each
/// platform name set to ` false`.
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
