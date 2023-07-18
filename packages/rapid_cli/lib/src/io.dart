import 'dart:convert';
import 'dart:io' hide Directory, File;
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as p;
import 'package:propertylistserialization/propertylistserialization.dart';
import 'package:pubspec/pubspec.dart';
import 'package:rapid_cli/src/validation.dart';
import 'package:xml/xml.dart' show XmlDocument;
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

export 'dart:io' hide Directory, File;

export 'package:pub_semver/pub_semver.dart';
export 'package:pubspec/pubspec.dart'
    show
        DependencyReference,
        GitReference,
        PathReference,
        HostedReference,
        ExternalHostedReference,
        SdkReference;

abstract class FileSystemEntityCollection {
  Iterable<FileSystemEntity> get entities;

  bool get existsAny => entities.any((e) => e.existsSync());

  bool get existsAll => entities.every((e) => e.existsSync());

  void delete() {
    for (final entity in entities.where((e) => e.existsSync())) {
      entity.deleteSync(recursive: true);
    }
  }
}

class Directory implements io.Directory {
  Directory(String path) : _directory = io.Directory(p.normalize(path));

  static Directory get current => Directory._fromIO(io.Directory.current);

  static set current(path) {
    io.Directory.current = path;
  }

  Directory._fromIO(io.Directory directory) : _directory = directory;

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
  Future<FileSystemEntity> delete({bool recursive = false}) =>
      _entityFromIOAsync(_directory.delete(recursive: recursive));

  @override
  void deleteSync({bool recursive = false}) =>
      _directory.deleteSync(recursive: recursive);

  @override
  Future<bool> exists() => _directory.exists();

  @override
  bool existsSync() => _directory.existsSync();

  @override
  bool get isAbsolute => _directory.isAbsolute;

  @override
  Stream<FileSystemEntity> list({
    bool recursive = false,
    bool followLinks = true,
  }) =>
      _directory
          .list(recursive: recursive, followLinks: followLinks)
          .map(_entityFromIO);

  @override
  List<FileSystemEntity> listSync({
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
  Future<FileStat> stat() => _directory.stat();

  @override
  FileStat statSync() => _directory.statSync();

  @override
  Uri get uri => _directory.uri;

  @override
  Stream<FileSystemEvent> watch({
    int events = FileSystemEvent.all,
    bool recursive = false,
  }) =>
      _directory.watch(events: events, recursive: recursive);
}

class File implements io.File {
  File(String path) : _file = io.File(p.normalize(path));

  File._fromIO(io.File file) : _file = file;

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
  Future<FileSystemEntity> delete({bool recursive = false}) =>
      _entityFromIOAsync(_file.delete(recursive: recursive));

  @override
  void deleteSync({bool recursive = false}) =>
      _file.deleteSync(recursive: recursive);

  @override
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
  Future<DateTime> lastModified() => _file.lastModified();

  @override
  DateTime lastModifiedSync() => _file.lastModifiedSync();

  @override
  Future<int> length() => _file.length();

  @override
  int lengthSync() => _file.lengthSync();

  @override
  Future<RandomAccessFile> open({FileMode mode = FileMode.read}) =>
      _file.open(mode: mode);

  @override
  Stream<List<int>> openRead([int? start, int? end]) =>
      _file.openRead(start, end);

  @override
  RandomAccessFile openSync({FileMode mode = FileMode.read}) =>
      _file.openSync(mode: mode);

  @override
  IOSink openWrite({
    FileMode mode = FileMode.write,
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
  Future setLastAccessed(DateTime time) => _file.setLastAccessed(time);

  @override
  void setLastAccessedSync(DateTime time) => _file.setLastAccessedSync(time);

  @override
  Future setLastModified(DateTime time) => _file.setLastModified(time);

  @override
  void setLastModifiedSync(DateTime time) => _file.setLastModifiedSync(time);

  @override
  Future<FileStat> stat() => _file.stat();

  @override
  FileStat statSync() => _file.statSync();

  @override
  Uri get uri => _file.uri;

  @override
  Stream<FileSystemEvent> watch({
    int events = FileSystemEvent.all,
    bool recursive = false,
  }) =>
      _file.watch(
        events: events,
        recursive: recursive,
      );

  @override
  Future<File> writeAsBytes(
    List<int> bytes, {
    FileMode mode = FileMode.write,
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
    FileMode mode = FileMode.write,
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
    FileMode mode = FileMode.write,
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
    FileMode mode = FileMode.write,
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
      : assert(path.endsWith('.yaml') || path.endsWith('.yml'));

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
  PubspecYamlFile(super.path) : assert(path.endsWith('pubspec.yaml'));

  PubSpec get _pubSpec => PubSpec.fromYamlString(readAsStringSync());

  String get name => assertNotNull(_pubSpec.name);

  bool hasDependency({required String name}) {
    return _pubSpec.allDependencies.containsKey(name);
  }

  void setDependency({
    required String name,
    required DependencyReference dependency,
    bool dev = false,
  }) {
    final editor = YamlEditor(readAsStringSync());
    var json = dependency.toJson();

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
  DartFile(super.path) : assert(path.endsWith('.dart'));

  void addImport(String import, {String? alias}) {
    final contents = readAsStringSync();

    final existingImports =
        contents.split('\n').where((line) => _importRegExp.hasMatch(line));
    if (existingImports
        .contains('import \'$import\'${alias != null ? ' as $alias' : ''};')) {
      return;
    }

    final updatedImports = [
      ...existingImports,
      'import \'$import\'${alias != null ? ' as $alias' : ''};'
    ];
    updatedImports.sort(_compareImports);

    final output = contents.replaceRange(
      // start of old imports
      contents.indexOf(_importRegExp),
      // end of old imports
      // TODO if code is not formatted this might fail
      contents.indexOf('\n', contents.lastIndexOf(_importRegExp)) + 1,
      // add empty line after last dart and package import
      updatedImports
          .expand(
            (e) => updatedImports.indexOf(e) ==
                        updatedImports.lastIndexWhere(
                            (e) => e.startsWith('import \'dart:')) ||
                    updatedImports.indexOf(e) ==
                        updatedImports.lastIndexWhere(
                            (e) => e.startsWith('import \'package:'))
                ? [e, '']
                : [e],
          )
          .join('\n'),
    );
    writeAsStringSync(output);
  }

  void addExport(String export) {
    final contents = readAsStringSync();

    if (contents.isEmpty) {
      writeAsStringSync('export \'$export\';');
      return;
    }

    final existingExports =
        contents.split('\n').where((line) => _exportRegExp.hasMatch(line));
    if (existingExports.contains('export \'$export\';')) {
      return;
    }

    final updatedExports = [...existingExports, 'export \'$export\';'];
    updatedExports.sort(_compareExports);

    final startOldImportsIndex = contents.indexOf(_exportRegExp);
    if (startOldImportsIndex == -1) {
      // no existing exports -> just append new export to file
      writeAsStringSync('$contents\nexport \'$export\';');
      return;
    }

    final output = contents.replaceRange(
      // start of old exports
      startOldImportsIndex,
      // TODO if code is not formatted this might fail
      // end of old exports
      contents.indexOf('\n', contents.lastIndexOf(_exportRegExp)) + 1,
      // add empty line after last dart and package export
      updatedExports
          .expand(
            (e) => updatedExports.indexOf(e) ==
                        updatedExports.lastIndexWhere(
                            (e) => e.startsWith('export \'dart:')) ||
                    updatedExports.indexOf(e) ==
                        updatedExports.lastIndexWhere(
                            (e) => e.startsWith('export \'package:'))
                ? [e, '']
                : [e],
          )
          .join('\n'),
    );
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
    final contents = readAsStringSync();

    // TODO this might fail if the file is not formatted
    final regExp =
        RegExp('import \'([a-z0-9_:./]+)\'( as [a-z]+)?;' r'[\s]{1}');
    final matches = regExp.allMatches(contents);
    final output = <String>{};
    for (final match in matches) {
      output.add(match.group(1)!);
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
              (e) => e.childEntities.any((e) =>
                  e is VariableDeclarationList &&
                  e.variables.first.name.lexeme == name),
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
        (e) => e is NamedExpression && e.name.label.name == property);

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
        (e) => e is NamedExpression && e.name.label.name == property);

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
    final contents = readAsStringSync();

    // TODO this fails if the file is not formatted
    final regExp = RegExp(
      r"import[\s]+\'" + import + r"\'([\s]+as[\s]+[a-z]+)?;" + r"[\s]{1}",
    );
    final match = regExp.firstMatch(contents);
    if (match == null) {
      return;
    }
    final output = contents.replaceRange(match.start, match.end + 1, '');

    writeAsStringSync(output);
  }

  // TODO the export should be better abstracted maybe using code builder or smth
  void removeExport(String export) {
    final contents = readAsStringSync();

    // TODO this fails if the file is not formatted
    final regExp = RegExp(
      r"export[\s]+\'" +
          export +
          r"\'([\s]+(:?hide|show)[\s]+[A-Z]+[A-z1-9]*)?;" +
          r"[\s]{1}",
    );

    final matches = regExp.allMatches(contents);
    if (matches.isEmpty) {
      return;
    }

    var output = contents;
    for (final match in matches.toList().reversed) {
      output = output.replaceRange(match.start, match.end + 1, '');
    }

    writeAsStringSync(output);
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
            (e) => e is NamedExpression && e.name.label.name == property)
        as NamedExpression;

    final start = val.offset;
    final end = val.end;

    final output = contents.replaceRange(start, end,
        '$property: [${value.join(',')}${value.isEmpty ? '' : ','}]');

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
            (e) => e is NamedExpression && e.name.label.name == property)
        as NamedExpression;

    final start = val.offset;
    final end = val.end;

    final output = contents.replaceRange(start, end,
        '$property: [${value.join(',')}${value.isEmpty ? '' : ','}]');

    writeAsStringSync(output);
  }

  List<Declaration> _getTopLevelDeclarations(String source) {
    final unit = parseString(content: source).unit;
    return unit.declarations;
  }

  /// Sorts imports after dart standard
  ///
  /// ```dart
  /// dart:***
  /// ... more dart imports
  /// package:***
  /// ... more package imports
  /// foo.dart
  /// ... more relative imports
  /// ```
  int _compareImports(String a, String b) {
    if (a.startsWith('import \'dart')) {
      if (b.startsWith('import \'dart')) {
        return a.compareTo(b);
      }

      return -1;
    } else if (a.startsWith('import \'package')) {
      if (b.startsWith('import \'dart')) {
        return 1;
      } else if (b.startsWith('import \'package')) {
        return a.compareTo(b);
      }

      return -1;
    } else {
      if (b.startsWith('import \'dart')) {
        return 1;
      } else if (b.startsWith('import \'package')) {
        return 1;
      }

      return a.compareTo(b);
    }
  }

  /// Sorts exports after dart standard
  ///
  /// ```dart
  /// dart:***
  /// ... more dart exports
  /// package:***
  /// ... more package exports
  /// foo.dart
  /// ... more relative exports
  /// ```
  int _compareExports(String a, String b) {
    if (a.startsWith('export \'dart')) {
      if (b.startsWith('export \'dart')) {
        return a.compareTo(b);
      }

      return -1;
    } else if (a.startsWith('export \'package')) {
      if (b.startsWith('export \'dart')) {
        return 1;
      } else if (b.startsWith('export \'package')) {
        return a.compareTo(b);
      }

      return -1;
    } else {
      if (b.startsWith('export \'dart')) {
        return 1;
      } else if (b.startsWith('export \'package')) {
        return 1;
      }

      return a.compareTo(b);
    }
  }

  final _importRegExp = RegExp('import \'([a-z_/.:]+)\'( as [a-z]+)?;');
  final _exportRegExp =
      RegExp('export \'([a-z_/.:]+)\'( (:?hide|show) [A-Z]+[A-z1-9]*;)?');
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
  ArbFile(super.path) : assert(path.endsWith('.arb'));

  void setValue<T extends Object?>(String key, T? value) {
    final contents = readAsStringSync();

    final json = jsonDecode(contents);
    json[key] = value;

    final output = JsonEncoder.withIndent('  ').convert(json);
    writeAsStringSync(output);
  }
}

FileSystemEntity _entityFromIO(FileSystemEntity entity) =>
    entity is io.Directory
        ? Directory._fromIO(entity)
        : entity is io.File
            ? File._fromIO(entity)
            : entity;

Future<FileSystemEntity> _entityFromIOAsync(
    Future<FileSystemEntity> entity) async {
  final result = await entity;
  return result is io.Directory
      ? Directory._fromIO(result)
      : result is io.File
          ? File._fromIO(result)
          : result;
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
