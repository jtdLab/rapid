import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:math';
import 'dart:typed_data';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:propertylistserialization/propertylistserialization.dart';
import 'package:pubspec/pubspec.dart';
import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

export 'dart:io' hide Directory, File, Platform;

export 'package:platform/platform.dart';
export 'package:process/process.dart';
export 'package:pub_semver/pub_semver.dart';
export 'package:pubspec/pubspec.dart'
    show
        DependencyReference,
        ExternalHostedReference,
        GitReference,
        HostedReference,
        PathReference,
        SdkReference;

part 'platform.dart';
part 'process.dart';

abstract class FileSystemEntityCollection {
  Iterable<io.FileSystemEntity> get entities;

  bool get existsAny => entities.any((e) => e.existsSync());

  bool get existsAll => entities.every((e) => e.existsSync());

  void delete() {
    for (final entity in entities.where((e) => e.existsSync())) {
      entity.deleteSync(recursive: true);
    }
  }
}

class Directory implements io.Directory {
  Directory(String path)
      : _directory = directoryOverrides ?? io.Directory(p.normalize(path));

  Directory._fromIO(io.Directory directory) : _directory = directory;

  /// Overrides the underlying directory from dart:io for testing.
  @visibleForTesting
  static io.Directory? directoryOverrides;

  // ignore: prefer_constructors_over_static_methods
  static Directory get current => Directory._fromIO(io.Directory.current);

  static set current(dynamic path) {
    io.Directory.current = path;
  }

  static Future<Directory> _fromIOAsync(Future<io.Directory> directory) async =>
      Directory._fromIO(await directory);

  final io.Directory _directory;

  @override
  Directory get absolute => Directory._fromIO(_directory.absolute);

  @override
  Future<Directory> create({bool recursive = false}) =>
      _fromIOAsync(_directory.create(recursive: recursive));

  @override
  void createSync({bool recursive = false}) =>
      _directory.createSync(recursive: recursive);

  @override
  Future<Directory> createTemp([String? prefix]) =>
      _fromIOAsync(_directory.createTemp(prefix));

  @override
  Directory createTempSync([String? prefix]) =>
      Directory._fromIO(_directory.createTempSync(prefix));

  @override
  Future<io.FileSystemEntity> delete({bool recursive = false}) =>
      _entityFromIOAsync(_directory.delete(recursive: recursive));

  @override
  void deleteSync({bool recursive = false}) =>
      _directory.deleteSync(recursive: recursive);

  @override
  // ignore: avoid_slow_async_io
  Future<bool> exists() => _directory.exists();

  @override
  bool existsSync() => _directory.existsSync();

  @override
  bool get isAbsolute => _directory.isAbsolute;

  @override
  Stream<io.FileSystemEntity> list({
    bool recursive = false,
    bool followLinks = true,
  }) =>
      _directory
          .list(recursive: recursive, followLinks: followLinks)
          .map(_entityFromIO);

  @override
  List<io.FileSystemEntity> listSync({
    bool recursive = false,
    bool followLinks = true,
  }) =>
      _directory
          .listSync(recursive: recursive, followLinks: followLinks)
          .map(_entityFromIO)
          .toList();

  @override
  Directory get parent => Directory._fromIO(_directory.parent);

  @override
  String get path => _directory.path;

  @override
  Future<Directory> rename(String newPath) =>
      Directory._fromIOAsync(_directory.rename(newPath));

  @override
  Directory renameSync(String newPath) =>
      Directory._fromIO(_directory.renameSync(newPath));

  @override
  Future<String> resolveSymbolicLinks() => _directory.resolveSymbolicLinks();

  @override
  String resolveSymbolicLinksSync() => _directory.resolveSymbolicLinksSync();

  @override
  // ignore: avoid_slow_async_io
  Future<io.FileStat> stat() => _directory.stat();

  @override
  io.FileStat statSync() => _directory.statSync();

  @override
  Uri get uri => _directory.uri;

  @override
  Stream<io.FileSystemEvent> watch({
    int events = io.FileSystemEvent.all,
    bool recursive = false,
  }) =>
      _directory.watch(events: events, recursive: recursive);
}

class File implements io.File {
  File(String path) : _file = fileOverrides ?? io.File(p.normalize(path));

  File._fromIO(io.File file) : _file = file;

  /// Overrides the underlying file from dart:io for testing.
  @visibleForTesting
  static io.File? fileOverrides;

  static Future<File> _fromIOAsync(Future<io.File> file) async =>
      File._fromIO(await file);

  final io.File _file;

  @override
  File get absolute => File._fromIO(_file.absolute);

  @override
  Future<File> copy(String newPath) => File._fromIOAsync(_file.copy(newPath));

  @override
  File copySync(String newPath) => File._fromIO(_file.copySync(newPath));

  @override
  Future<File> create({bool recursive = false, bool exclusive = false}) =>
      File._fromIOAsync(
        _file.create(recursive: recursive, exclusive: exclusive),
      );

  @override
  void createSync({bool recursive = false, bool exclusive = false}) =>
      _file.createSync(recursive: recursive, exclusive: exclusive);

  @override
  Future<io.FileSystemEntity> delete({bool recursive = false}) =>
      _entityFromIOAsync(_file.delete(recursive: recursive));

  @override
  void deleteSync({bool recursive = false}) =>
      _file.deleteSync(recursive: recursive);

  @override
  // ignore: avoid_slow_async_io
  Future<bool> exists() => _file.exists();

  @override
  bool existsSync() => _file.existsSync();

  @override
  bool get isAbsolute => _file.isAbsolute;

  @override
  Future<DateTime> lastAccessed() => _file.lastAccessed();

  @override
  DateTime lastAccessedSync() => _file.lastAccessedSync();

  @override
  // ignore: avoid_slow_async_io
  Future<DateTime> lastModified() => _file.lastModified();

  @override
  DateTime lastModifiedSync() => _file.lastModifiedSync();

  @override
  Future<int> length() => _file.length();

  @override
  int lengthSync() => _file.lengthSync();

  @override
  Future<io.RandomAccessFile> open({io.FileMode mode = io.FileMode.read}) =>
      _file.open(mode: mode);

  @override
  Stream<List<int>> openRead([int? start, int? end]) =>
      _file.openRead(start, end);

  @override
  io.RandomAccessFile openSync({io.FileMode mode = io.FileMode.read}) =>
      _file.openSync(mode: mode);

  @override
  io.IOSink openWrite({
    io.FileMode mode = io.FileMode.write,
    Encoding encoding = utf8,
  }) =>
      _file.openWrite(mode: mode, encoding: encoding);

  @override
  Directory get parent => Directory._fromIO(_file.parent);

  @override
  String get path => _file.path;

  @override
  Future<Uint8List> readAsBytes() => _file.readAsBytes();

  @override
  Uint8List readAsBytesSync() => _file.readAsBytesSync();

  @override
  Future<List<String>> readAsLines({Encoding encoding = utf8}) =>
      _file.readAsLines(encoding: encoding);

  @override
  List<String> readAsLinesSync({Encoding encoding = utf8}) =>
      _file.readAsLinesSync(encoding: encoding);

  @override
  Future<String> readAsString({Encoding encoding = utf8}) =>
      _file.readAsString(encoding: encoding);

  @override
  String readAsStringSync({Encoding encoding = utf8}) =>
      _file.readAsStringSync(encoding: encoding);

  @override
  Future<File> rename(String newPath) =>
      File._fromIOAsync(_file.rename(newPath));

  @override
  File renameSync(String newPath) => File._fromIO(_file.renameSync(newPath));

  @override
  Future<String> resolveSymbolicLinks() => _file.resolveSymbolicLinks();

  @override
  String resolveSymbolicLinksSync() => _file.resolveSymbolicLinksSync();

  @override
  Future<dynamic> setLastAccessed(DateTime time) => _file.setLastAccessed(time);

  @override
  void setLastAccessedSync(DateTime time) => _file.setLastAccessedSync(time);

  @override
  Future<dynamic> setLastModified(DateTime time) => _file.setLastModified(time);

  @override
  void setLastModifiedSync(DateTime time) => _file.setLastModifiedSync(time);

  @override
  // ignore: avoid_slow_async_io
  Future<io.FileStat> stat() => _file.stat();

  @override
  io.FileStat statSync() => _file.statSync();

  @override
  Uri get uri => _file.uri;

  @override
  Stream<io.FileSystemEvent> watch({
    int events = io.FileSystemEvent.all,
    bool recursive = false,
  }) =>
      _file.watch(
        events: events,
        recursive: recursive,
      );

  @override
  Future<File> writeAsBytes(
    List<int> bytes, {
    io.FileMode mode = io.FileMode.write,
    bool flush = false,
  }) =>
      File._fromIOAsync(
        _file.writeAsBytes(
          bytes,
          mode: mode,
          flush: flush,
        ),
      );

  @override
  void writeAsBytesSync(
    List<int> bytes, {
    io.FileMode mode = io.FileMode.write,
    bool flush = false,
  }) =>
      _file.writeAsBytesSync(
        bytes,
        mode: mode,
        flush: flush,
      );

  @override
  Future<File> writeAsString(
    String contents, {
    io.FileMode mode = io.FileMode.write,
    Encoding encoding = utf8,
    bool flush = false,
  }) =>
      File._fromIOAsync(
        _file.writeAsString(
          contents,
          mode: mode,
          encoding: encoding,
          flush: flush,
        ),
      );

  @override
  void writeAsStringSync(
    String contents, {
    io.FileMode mode = io.FileMode.write,
    Encoding encoding = utf8,
    bool flush = false,
  }) =>
      _file.writeAsStringSync(
        contents,
        mode: mode,
        encoding: encoding,
        flush: flush,
      );
}

abstract class DartPackage extends Directory {
  DartPackage(super.path);

  PubspecYamlFile get pubSpecFile =>
      PubspecYamlFile(p.join(path, 'pubspec.yaml'));

  String get packageName => pubSpecFile.name;
}

class YamlFile extends File {
  YamlFile(super.path)
      : assert(
          path.endsWith('.yaml') || path.endsWith('.yml'),
          'YamlFile requires .yaml or .yml extension.',
        );

  T read<T>(String key) => loadYaml(readAsStringSync())[key] as T;

  /// Sets the field at [path] to [value].
  ///
  /// Hint: The [path] must exists. This method can not create not existing paths.
  void set<T>(
    List<String> path,
    T? value, {
    bool blankIfValueNull = false,
  }) {
    final editor = YamlEditor(readAsStringSync());
    editor.update(path, value);

    var output = editor.toString();
    if (value == null && blankIfValueNull) {
      final replacement = editor.edits.first.replacement;
      output =
          output.replaceAll(replacement, replacement.replaceAll(' null', ''));
    }

    writeAsStringSync(output);
  }
}

class PubspecYamlFile extends YamlFile {
  PubspecYamlFile(super.path);

  PubSpec get _pubSpec => PubSpec.fromYamlString(readAsStringSync());

  String get name {
    final name = _pubSpec.name;
    if (name != null) {
      return name;
    }

    throw StateError('Name not found.');
  }

  bool hasDependency({required String name}) {
    return _pubSpec.allDependencies.containsKey(name);
  }

  void setDependency({
    required String name,
    required DependencyReference dependency,
    bool dev = false,
  }) {
    final editor = YamlEditor(readAsStringSync());
    final json = dependency.toJson();

    if (dev) {
      editor.update(['dev_dependencies', name], json);
    } else {
      editor.update(['dependencies', name], json);
    }

    var output = editor.toString();
    final replacement = editor.edits.first.replacement;
    output =
        output.replaceAll(replacement, replacement.replaceAll(' <empty>', ''));

    writeAsStringSync(output);
  }

  void removeDependency({
    required String name,
  }) {
    final editor = YamlEditor(readAsStringSync());

    try {
      editor.remove(['dev_dependencies', name]);
    } catch (_) {}

    try {
      editor.remove(['dependencies', name]);
    } catch (_) {}

    writeAsStringSync(editor.toString());
  }
}

class DartFile extends File {
  DartFile(super.path)
      : assert(
          path.endsWith('.dart'),
          'DartFile requires .dart extension.',
        );

  final DartFormatter _formatter = DartFormatter();

  void addImport(String import) => _modifyImportsOrExports(
        (importsAndExports) => [...importsAndExports, "import '$import';"],
      );

  void addExport(String export) => _modifyImportsOrExports(
        (importsAndExports) => [...importsAndExports, "export '$export';"],
      );

  void _modifyImportsOrExports(
    List<String> Function(List<String> importsAndExports)
        updateImportsAndExports,
  ) {
    final contents = _formatter.format(readAsStringSync());
    final lines = contents.split('\n');

    final libraryDirectiveIndex = lines.indexWhere(_libraryRegExp.hasMatch);

    final firstExportLineIndex = lines
        .indexWhere(
          _exportRegExp.hasMatch,
        )
        .replaceWhenNegative(
          libraryDirectiveIndex == -1 ? 0 : libraryDirectiveIndex + 1,
        );
    final firstImportLineIndex = lines
        .indexWhere(
          _importRegExp.hasMatch,
        )
        .replaceWhenNegative(
          libraryDirectiveIndex == -1 ? 0 : libraryDirectiveIndex + 1,
        );
    final lastExportLineIndex = lines
        .lastIndexWhere(
          _exportRegExp.hasMatch,
        )
        .replaceWhenNegative(
          libraryDirectiveIndex == -1 ? 0 : libraryDirectiveIndex + 1,
        );
    final lastImportLineIndex = lines
        .lastIndexWhere(
          _importRegExp.hasMatch,
        )
        .replaceWhenNegative(
          libraryDirectiveIndex == -1 ? 0 : libraryDirectiveIndex + 1,
        );

    // All lines between the first import/export and the last import/export
    final firstExportOrImportLineIndex =
        min(firstExportLineIndex, firstImportLineIndex);
    final lastExportOrImportLineIndex =
        max(lastExportLineIndex, lastImportLineIndex);
    var importExportLines = lines
        .getRange(firstExportOrImportLineIndex, lastExportOrImportLineIndex + 1)
        .where(
          (line) =>
              _importRegExp.hasMatch(line) || _exportRegExp.hasMatch(line),
        )
        .toList();

    // Add new import/export
    importExportLines = updateImportsAndExports(importExportLines);

    // Make imports appear before exports
    // Separate dart and package imports/exports
    // Sort each section alphabetically
    final dartImportLines = importExportLines
        .where((line) => line.startsWith("import 'dart:"))
        .sorted()
        .toSet();
    final packageImportLines = importExportLines
        .where((line) => line.startsWith("import 'package:"))
        .sorted()
        .toSet();
    final localImportLines = importExportLines
        .where(
          (line) =>
              !line.startsWith("import 'dart:") &&
              !line.startsWith("import 'package:") &&
              line.startsWith("import '"),
        )
        .sorted()
        .toSet();
    final dartExportLines = importExportLines
        .where((line) => line.startsWith("export 'dart:"))
        .sorted()
        .toSet();
    final packageExportLines = importExportLines
        .where((line) => line.startsWith("export 'package:"))
        .sorted()
        .toSet();
    final localExportLines = importExportLines
        .where(
          (line) =>
              !line.startsWith("export 'dart:") &&
              !line.startsWith("export 'package:") &&
              line.startsWith("export '"),
        )
        .sorted()
        .toSet();
    importExportLines = [
      ...dartImportLines,
      if (dartImportLines.isNotEmpty) '',
      ...packageImportLines,
      if (packageImportLines.isNotEmpty) '',
      ...localImportLines,
      if (localImportLines.isNotEmpty) '',
      ...dartExportLines,
      if (dartExportLines.isNotEmpty) '',
      ...packageExportLines,
      if (packageExportLines.isNotEmpty) '',
      ...localExportLines,
      if (localExportLines.isNotEmpty) '',
    ];

    lines.replaceRange(
      firstExportOrImportLineIndex,
      lastExportOrImportLineIndex + 1,
      importExportLines,
    );

    final output = _formatter.format(lines.join('\n'));
    writeAsStringSync(output);
  }

  /// Returns `true` when this contains any dart statemens.
  bool containsStatements() {
    final content = readAsStringSync();

    final lines = content
        // remove multi line comments
        .replaceAll(RegExp(r'\/\*(.|[\r\n])*?\*\/'), '')
        .split('\n')
        // remove single line comments
        .where((e) => !e.trim().startsWith('//'))
        // remove empty lines
        .where((e) => e.trim().isNotEmpty);

    return lines.isNotEmpty;
  }

  Set<String> readImports() {
    final content = _formatter.format(readAsStringSync());
    final lines = content.split('\n');

    final output = <String>{};
    for (final line in lines) {
      final match = _importRegExp.firstMatch(line);
      if (match != null) {
        output.add(match.group(1)!);
      }
    }

    return output;
  }

  List<String> readListVarOfClass({
    required String name,
    required String parentClass,
  }) {
    final contents = readAsStringSync();

    final declarations = _getTopLevelDeclarations(contents);

    final clazz = declarations.firstWhere(
      (e) => e is ClassDeclaration && e.name.lexeme == parentClass,
    ) as ClassDeclaration;

    final fieldDeclaration =
        clazz.members.whereType<FieldDeclaration>().firstWhere(
              (e) => e.childEntities.any(
                (e) =>
                    e is VariableDeclarationList &&
                    e.variables.first.name.lexeme == name,
              ),
            );

    final declarationList = fieldDeclaration.childEntities
        .whereType<VariableDeclarationList>()
        .first;

    final listLiteral = declarationList.variables.first.childEntities
        .firstWhere((e) => e is ListLiteral) as ListLiteral;

    return listLiteral.elements
        .map((e) => contents.substring(e.offset, e.end))
        .toList();
  }

  List<String> readTopLevelListVar({required String name}) {
    final contents = readAsStringSync();

    final declarations = _getTopLevelDeclarations(contents);

    final topLevelVariables =
        declarations.whereType<TopLevelVariableDeclaration>();

    final topLevelVariable = topLevelVariables.firstWhere(
      (e) => e.childEntities.any(
        (e) =>
            e is VariableDeclarationList &&
            e.childEntities.any(
              (e) => e is VariableDeclaration && e.name.lexeme == name,
            ),
      ),
    );

    final variableDeclaration = topLevelVariable.childEntities
        .whereType<VariableDeclarationList>()
        .first
        .childEntities
        .whereType<VariableDeclaration>()
        .first;

    final listLiteral =
        variableDeclaration.childEntities.whereType<ListLiteral>().first;

    return listLiteral.elements
        .map((e) => contents.substring(e.offset, e.end))
        .toList();
  }

  List<String> readTypeListFromAnnotationParamOfClass({
    required String property,
    required String annotation,
    required String className,
  }) {
    final contents = readAsStringSync();

    final declarations = _getTopLevelDeclarations(contents);

    final function = declarations.firstWhere(
      (e) => e is ClassDeclaration && e.name.lexeme == className,
    );
    final anot = function.metadata.firstWhere((e) => e.name.name == annotation);
    final value = anot.arguments!.childEntities.firstWhere(
      (e) => e is NamedExpression && e.name.label.name == property,
    );

    return value
        .toString()
        .split(':')
        .last
        .trim()
        .replaceAll(RegExp(r'[\s\[\]]+'), '')
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .toList();
  }

  List<String> readTypeListFromAnnotationParamOfTopLevelFunction({
    required String property,
    required String annotation,
    required String functionName,
  }) {
    final contents = readAsStringSync();

    final declarations = _getTopLevelDeclarations(contents);

    final function = declarations.firstWhere(
      (e) => e is FunctionDeclaration && e.name.lexeme == functionName,
    );
    final anot = function.metadata.firstWhere((e) => e.name.name == annotation);
    final value = anot.arguments!.childEntities.firstWhere(
      (e) => e is NamedExpression && e.name.label.name == property,
    );

    return value
        .toString()
        .split(':')
        .last
        .trim()
        .replaceAll(RegExp(r'[\s\[\]]+'), '')
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .toList();
  }

  void removeImport(String import) {
    final regExp = RegExp(
      r"import[\s]+\'" + import + r"\'([\s]+as[\s]+[a-z]+)?;",
    );
    _modifyImportsOrExports(
      (importsAndExports) =>
          importsAndExports.where((e) => !regExp.hasMatch(e)).toList(),
    );
  }

  void removeExport(String export) {
    final regExp = RegExp(
      r"export[\s]+\'" +
          export +
          r"\'([\s]+(:?hide|show)[\s]+[A-Z]+[A-z1-9]*)?;",
    );
    _modifyImportsOrExports(
      (importsAndExports) =>
          importsAndExports.where((e) => !regExp.hasMatch(e)).toList(),
    );
  }

  void setTopLevelListVar({required String name, required List<String> value}) {
    final contents = readAsStringSync();

    final declarations = _getTopLevelDeclarations(contents);

    final topLevelVariables =
        declarations.whereType<TopLevelVariableDeclaration>();

    final topLevelVariable = topLevelVariables.firstWhere(
      (e) => e.childEntities.any(
        (e) =>
            e is VariableDeclarationList &&
            e.childEntities.any(
              (e) => e is VariableDeclaration && e.name.lexeme == name,
            ),
      ),
    );

    final variableDeclaration = topLevelVariable.childEntities
        .whereType<VariableDeclarationList>()
        .first
        .childEntities
        .whereType<VariableDeclaration>()
        .first;

    final listLiteral =
        variableDeclaration.childEntities.whereType<ListLiteral>().first;

    final listText =
        '${listLiteral.typeArguments ?? ''}[${value.join(',')}${value.isEmpty ? '' : ','}]';

    final output = contents.replaceRange(
      listLiteral.offset,
      listLiteral.end,
      listText,
    );

    writeAsStringSync(output);
  }

  void setTypeListOfAnnotationParamOfClass({
    required String property,
    required String annotation,
    required String className,
    required List<String> value,
  }) {
    final contents = readAsStringSync();

    final declarations = _getTopLevelDeclarations(contents);

    final function = declarations.firstWhere(
      (e) => e is ClassDeclaration && e.name.lexeme == className,
    );
    final anot = function.metadata.firstWhere((e) => e.name.name == annotation);
    final val = anot.arguments!.childEntities.firstWhere(
      (e) => e is NamedExpression && e.name.label.name == property,
    ) as NamedExpression;

    final start = val.offset;
    final end = val.end;

    final output = contents.replaceRange(
      start,
      end,
      '$property: [${value.join(',')}${value.isEmpty ? '' : ','}]',
    );

    writeAsStringSync(output);
  }

  void setTypeListOfAnnotationParamOfTopLevelFunction({
    required String property,
    required String annotation,
    required String functionName,
    required List<String> value,
  }) {
    final contents = readAsStringSync();

    final declarations = _getTopLevelDeclarations(contents);

    final function = declarations.firstWhere(
      (e) => e is FunctionDeclaration && e.name.lexeme == functionName,
    );
    final anot = function.metadata.firstWhere((e) => e.name.name == annotation);
    final val = anot.arguments!.childEntities.firstWhere(
      (e) => e is NamedExpression && e.name.label.name == property,
    ) as NamedExpression;

    final start = val.offset;
    final end = val.end;

    final output = contents.replaceRange(
      start,
      end,
      '$property: [${value.join(',')}${value.isEmpty ? '' : ','}]',
    );

    writeAsStringSync(output);
  }

  List<Declaration> _getTopLevelDeclarations(String source) {
    final unit = parseString(content: source).unit;
    return unit.declarations;
  }

  final _importRegExp = RegExp("import '([a-z_/.:]+)'( as [a-z]+)?;");
  final _exportRegExp =
      RegExp("export '([a-z_/.:]+)'( (:?hide|show) [A-Z]+[A-z1-9]*;)?");
  final _libraryRegExp = RegExp(r'library[\s]+[A-z][A-z_]*;');
}

class PlistFile extends File {
  PlistFile(super.path);

  Map<String, Object> readDict() {
    final contents = readAsStringSync();

    final plist = PropertyListSerialization.propertyListWithString(contents);

    if (PropertyListSerialization.propertyListWithString(contents)
        is! Map<String, Object>) {
      throw PlistFileError.rootIsNotDict(plistFile: this);
    }

    return plist as Map<String, Object>;
  }

  void setDict(Map<String, Object> map) {
    final contents = readAsStringSync();

    if (PropertyListSerialization.propertyListWithString(contents)
        is! Map<String, Object>) {
      throw PlistFileError.rootIsNotDict(plistFile: this);
    }

    final output = PropertyListSerialization.stringWithPropertyList(map);
    writeAsStringSync(XmlDocument.parse(output).toXmlString(pretty: true));
  }
}

class ArbFile extends File {
  ArbFile(super.path)
      : assert(path.endsWith('.arb'), 'ArbFile requires .arb extension.');

  static const _encoder = JsonEncoder.withIndent('  ');

  void setValue<T extends Object?>(String key, T? value) {
    final contents = readAsStringSync();

    final json = jsonDecode(contents) as Map<String, dynamic>;
    json[key] = value;

    final output = _encoder.convert(json);
    writeAsStringSync(output);
  }
}

class PlistFileError extends Error {
  PlistFileError._(this.message);

  factory PlistFileError.rootIsNotDict({
    required PlistFile plistFile,
  }) =>
      PlistFileError._(
        'Invalid Plist file: Root element in ${plistFile.path} must be a dictionary, '
        'but a non-dictionary element was found.',
      );

  final String message;

  @override
  String toString() => message;
}

io.FileSystemEntity _entityFromIO(io.FileSystemEntity entity) =>
    entity is io.Directory
        ? Directory._fromIO(entity)
        : entity is io.File
            ? File._fromIO(entity)
            : entity;

Future<io.FileSystemEntity> _entityFromIOAsync(
  Future<io.FileSystemEntity> entity,
) async {
  final result = await entity;
  return result is io.Directory
      ? Directory._fromIO(result)
      : result is io.File
          ? File._fromIO(result)
          : result;
}

extension on int {
  int replaceWhenNegative(int replacement) {
    if (this < 0) {
      return replacement;
    } else {
      return this;
    }
  }
}
