import 'dart:convert';

import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:yaml/yaml.dart';

import 'io.dart';
import 'io.dart' as io;
import 'platform.dart';
import 'process.dart';
import 'project/project.dart';

export 'package:pubspec/pubspec.dart';

// The regex for a dart package name, i.e. no capital letters.
// https://dart.dev/guides/language/language-tour#important-concepts
final dartPackageRegExp = RegExp('[a-z_][a-z0-9_]*');

const globalOptionVersion = 'version';
const globalOptionVerbose = 'verbose';

String multiLine(List<String> lines) => lines.join('\n');

const envKeyRapidTerminalWidth = 'RAPID_TERMINAL_WIDTH';

bool dirExists(String directory) {
  final dir = Directory(directory);
  return dir.existsSync();
}

bool dirIsEmpty(String directory) {
  final dir = Directory(directory);
  return dir.listSync().isEmpty;
}

void replaceInFile(File file, String from, String replace) {
  final content = file.readAsStringSync();
  final updatedContent = content.replaceAll(from, replace);
  file.writeAsStringSync(updatedContent);
}

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

      if (pending.length < (parallelism ?? io.Platform.numberOfProcessors)) {
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

extension IosRootPackageUtils on IosRootPackage {
  void addLanguage(Language language) {
    // TODO edit plist
    nativeDirectory;
  }

  void removeLanguage(Language language) {
    // TODO edit plist
    nativeDirectory;
  }
}

extension MobileRootPackageUtils on MobileRootPackage {
  void addLanguage(Language language) {
    // TODO edit plist
    iosNativeDirectory;
  }

  void removeLanguage(Language language) {
    // TODO edit plist
    iosNativeDirectory;
  }
}

///  class InfoPlistFileImpl extends PlistFileImpl implements InfoPlistFile {
///   InfoPlistFileImpl({
///     required IosNativeDirectory iosNativeDirectory,
///   }) : super(
///           path: p.join(iosNativeDirectory.path, 'Runner'),
///           name: 'Info',
///         );
///
///   @override
///   void addLanguage({required Language language}) {
///     final dict = readDict();
///
///     var languages = ((dict['CFBundleLocalizations'] ?? []) as List)
///         .cast<String>()
///         .map((e) => Language.fromString(e));
///     if (!languages.contains(language)) {
///       dict['CFBundleLocalizations'] = {
///         ...languages,
///         language,
///       }.map((e) => e.toStringWithSeperator('-')).toList();
///     }
///
///     setDict(dict);
///   }
///
///   @override
///   void removeLanguage({required Language language}) {
///     final dict = readDict();
///
///     var languages = ((dict['CFBundleLocalizations'] ?? []) as List)
///         .cast<String>()
///         .map((e) => Language.fromString(e))
///         .toList();
///     if (languages.contains(language)) {
///       dict['CFBundleLocalizations'] = (languages..remove(language))
///           .map((e) => e.toStringWithSeperator('-'))
///           .toList();
///     }
///
///     languages = ((dict['CFBundleLocalizations'] ?? []) as List)
///         .cast<String>()
///         .map((e) => Language.fromString(e))
///         .toList();
///     if (!language.hasScriptCode && !language.hasCountryCode) {
///       dict['CFBundleLocalizations'] = (languages
///             ..removeWhere(
///               (e) => e.languageCode.startsWith(language.languageCode),
///             ))
///           .map((e) => e.toStringWithSeperator('-'))
///           .toList();
///     }
///
///     setDict(dict);
///   }
/// }
///

extension DartPackageListUtils on List<DartPackage> {
  List<DartPackage> without(List<DartPackage> packages) {
    // TODO maybe override euqalitty in DartPackage
    return this
      ..removeWhere(
        (e) => packages.map((e) => e.packageName).contains(e.packageName),
      );
  }
}

// TODO needed ?
extension LocaleUtils on String {
  Language toLanguageFromDartLocale() {
    final self = replaceAll('\r\n', '')
        .replaceAll('\n', '')
        .replaceAll(RegExp(r'\s\s+'), '');
    final RegExpMatch match;
    if (RegExp(r"Locale\('([A-z]+)',?\)").hasMatch(self)) {
      match = RegExp(r"Locale\('([A-z]+)',?\)").firstMatch(self)!;
      return Language(languageCode: match.group(1)!);
    } else if (RegExp(r"Locale\('([A-z]+)', '([A-z]+)',?\)").hasMatch(self)) {
      match = RegExp(r"Locale\('([A-z]+)', '([A-z]+)',?\)").firstMatch(self)!;
      return Language(
          languageCode: match.group(1)!, countryCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(,?\)").hasMatch(self)) {
      match = RegExp(r"Locale.fromSubtags\(,?\)").firstMatch(self)!;
      return Language(languageCode: 'und');
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(languageCode: match.group(1)!);
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(languageCode: 'und', countryCode: match.group(1)!);
    } else if (RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(languageCode: 'und', scriptCode: match.group(1)!);
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
          languageCode: match.group(1)!, countryCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
          languageCode: match.group(1)!, scriptCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
          countryCode: match.group(1)!, languageCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        languageCode: 'und',
        countryCode: match.group(1)!,
        scriptCode: match.group(2)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
          scriptCode: match.group(1)!, languageCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        languageCode: 'und',
        scriptCode: match.group(1)!,
        countryCode: match.group(2)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        languageCode: match.group(1)!,
        countryCode: match.group(2)!,
        scriptCode: match.group(3)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        languageCode: match.group(1)!,
        scriptCode: match.group(2)!,
        countryCode: match.group(3)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        countryCode: match.group(1)!,
        languageCode: match.group(2)!,
        scriptCode: match.group(3)!,
      );
    } else if (RegExp(
            r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        countryCode: match.group(1)!,
        scriptCode: match.group(2)!,
        languageCode: match.group(3)!,
      );
    } else if (RegExp(
            r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        scriptCode: match.group(1)!,
        languageCode: match.group(2)!,
        countryCode: match.group(3)!,
      );
    } else if (RegExp(
            r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        scriptCode: match.group(1)!,
        countryCode: match.group(2)!,
        languageCode: match.group(3)!,
      );
    }

    // TODO
    throw Error();
  }
}
