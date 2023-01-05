import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file.dart';
import 'package:rapid_cli/src/project/platform_directory.dart';
import 'package:universal_io/io.dart';

// TODO this class has a diffrent abstraction level then all other project/filesystem related classes
// in future either this class should have the same abstraction level than them or they should have the
// same than this (tending to second) -> leads to major refactors in tests and commands

/// Thrown when [Feature.findArbFileByLanguage] fails to find the arb file related to language on disk.
class ArbFileNotExisting implements Exception {}

/// {@template feature}
/// Abstraction of a feature of a Rapid project.
/// {@endtemplate}
class Feature {
  /// {@macro feature}
  Feature({
    required this.name,
    required PlatformDirectory platformDirectory,
  })  : _l10nFile = L10nFile(
          path: p.join(
            platformDirectory.path,
            '${platformDirectory.project.melosFile.name()}_${platformDirectory.platform.name}_$name',
          ),
        ),
        _package = DartPackage(
          path: p.join(
            platformDirectory.path,
            '${platformDirectory.project.melosFile.name()}_${platformDirectory.platform.name}_$name',
          ),
        ),
        _platformDirectory = platformDirectory;

  final L10nFile _l10nFile;

  /// The underlying package file.
  final DartPackage _package;

  final PlatformDirectory _platformDirectory;

  Set<ArbFile> _arbFiles() {
    final arbDir = Directory(
      p.join(path, 'lib', 'src', 'presentation', 'l10n', 'arb'),
    );

    final arbFiles = arbDir
        .listSync()
        .whereType<File>()
        .where((e) => e.path.endsWith('.arb'))
        .map(
          (e) => ArbFile(
            language: e.path.split('.').first.split('_').last,
            feature: this,
          ),
        )
        .toList();
    arbFiles.sort((a, b) => a.language.compareTo(b.language));

    return arbFiles.toSet();
  }

  void delete() => _package.delete();

  String defaultLanguage() {
    final l10nFile = _l10nFile;
    final templateArbFile = l10nFile.templateArbFile();

    return templateArbFile.split('.').first.split('_').last;
  }

  bool exists() => _package.exists();

  ArbFile findArbFileByLanguage(String language) {
    try {
      Set arbFiles = _arbFiles();
      return arbFiles.firstWhere((e) => e.language == language);
    } catch (_) {
      throw ArbFileNotExisting();
    }
  }

  Set<String> supportedLanguages() =>
      _arbFiles().map((e) => e.language).toSet();

  bool supportsLanguage(String language) =>
      supportedLanguages().contains(language);

  final String name;

  String get path => _package.path;

  Platform get platform => _platformDirectory.platform;
}

/// {@template arb_file}
/// Abstraction of a arb file of a feature of a Rapid project.
/// {@endtemplate}
class ArbFile {
  /// {@macro arb_file}
  ArbFile({
    required this.language,
    required Feature feature,
  }) : _file = File(
          p.join(
            feature.path,
            'lib',
            'src',
            'presentation',
            'l10n',
            'arb',
            '${feature.name}_$language.arb',
          ),
        );

  final File _file;

  final String language;

  String get path => _file.path;

  void delete() => _file.deleteSync(recursive: true);
}

/// Thrown when [L10nFile.templateArbFile] fails to read the `template-arb-file` property.
class ReadTemplateArbFileFailure implements Exception {}

/// {@template l10n_file}
/// Abstraction of the l10n file of a feature of an existing Rapid project.
/// {@endtemplate}
class L10nFile {
  /// {@macro l10n_file}
  L10nFile({String path = '.'}) : _file = YamlFile(path: path, name: 'l10n');

  /// The underlying yaml file.
  final YamlFile _file;

  String get path => _file.path;

  /// The `template-arb-file` property.
  String templateArbFile() {
    try {
      return _file.readValue(['template-arb-file']);
    } catch (_) {
      throw ReadTemplateArbFileFailure();
    }
  }
}
