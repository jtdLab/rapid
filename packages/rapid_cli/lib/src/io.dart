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
    for (final entity in entities) {
      entity.deleteSync();
    }
  }
}

class Directory implements io.Directory {
  Directory(String path) : _directory = io.Directory(path);

  static Directory current = Directory._fromIO(io.Directory.current);

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
      _directory.delete(recursive: recursive);

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
      _directory.list(recursive: recursive, followLinks: followLinks);

  @override
  List<FileSystemEntity> listSync({
    bool recursive = false,
    bool followLinks = true,
  }) =>
      _directory.listSync(recursive: recursive, followLinks: followLinks);

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
  File(String path) : _file = io.File(path);

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
      _file.delete(recursive: recursive);

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

  void set<T>(
    Iterable<String> path,
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
  }
}

class PubspecYamlFile extends YamlFile {
  PubspecYamlFile(super.path) : assert(path.endsWith('pubspec.yaml')) {
    _pubSpec = PubSpec.fromYamlString(readAsStringSync());
  }

  late final PubSpec _pubSpec;

  String get name => assertNotNull(_pubSpec.name);

  bool hasDependency({required String name}) {
    return _pubSpec.allDependencies.containsKey(name);
  }

  void setDependency({
    required MapEntry<String, DependencyReference> updatedDependency,
    bool dev = false,
  }) {
    final newPubSpec = _pubSpec.copy(
      dependencies: !dev
          ? (_pubSpec.dependencies..addEntries([updatedDependency]))
          : null,
      devDependencies: dev
          ? (_pubSpec.devDependencies..addEntries([updatedDependency]))
          : null,
    );

    _writeToFile(newPubSpec);
  }

  void removeDependency({
    required String name,
    bool dev = false,
  }) {
    final newPubSpec = _pubSpec.copy(
      dependencies: !dev
          ? (_pubSpec.dependencies..removeWhere((key, _) => key == name))
          : null,
      devDependencies: dev
          ? (_pubSpec.devDependencies..removeWhere((key, _) => key == name))
          : null,
    );

    _writeToFile(newPubSpec);
  }

  void _writeToFile(PubSpec newPubSpec) {
    final ioSink = openWrite();
    try {
      YamlToString().writeYamlString(newPubSpec.toJson(), ioSink);
    } finally {
      ioSink.close();
    }
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
      contents.indexOf('\n', contents.lastIndexOf(_importRegExp)),
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
      // end of old exports
      contents.indexOf('\n', contents.lastIndexOf(_exportRegExp)),
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
    final lines = readAsLinesSync();
    lines.removeWhere(
      (e) =>
          e.trim().startsWith('//') ||
          e.trim().startsWith('/*') ||
          e.trim().startsWith('*/') ||
          e.trim().isEmpty,
    );

    return lines.isNotEmpty;
  }

  List<String> readImports() {
    final contents = readAsStringSync();

    final regExp =
        RegExp('import \'([a-z0-9_:./]+)\'( as [a-z]+)?;' r'[\s]{1}');
    final matches = regExp.allMatches(contents);
    final output = <String>[];
    for (final match in matches) {
      output.add(match.group(1)!);
    }

    return output;
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

    final regExp = RegExp(
      r"import[\s]+\'" + import + r"\'([\s]+as[\s]+[a-z]+)?;" + r"[\s]{1}",
    );
    final match = regExp.firstMatch(contents);
    if (match == null) {
      return;
    }
    final output = contents.replaceRange(match.start, match.end, '');

    writeAsStringSync(output);
  }

  // TODO the export should be better abstracted maybe using code builder or smth
  void removeExport(String export) {
    final contents = readAsStringSync();

    final regExp = RegExp(
      r"export[\s]+\'" +
          export +
          r"\'([\s]+(:?hide|show)[\s]+[A-Z]+[A-z1-9]*)?;" +
          r"[\s]{1}",
    );
    final match = regExp.firstMatch(contents);
    if (match == null) {
      return;
    }
    final output = contents.replaceRange(match.start, match.end, '');

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
      throw Error(); // TODO better error
      //throw PlistRootIsNotDict();
    }

    return plist as Map<String, Object>;
  }

  void setDict(Map<String, Object> map) {
    final contents = readAsStringSync();

    if (PropertyListSerialization.propertyListWithString(contents)
        is! Map<String, Object>) {
      throw Error(); // TODO better error
      //  throw PlistRootIsNotDict();
    }

    final output = PropertyListSerialization.stringWithPropertyList(map);
    writeAsStringSync(XmlDocument.parse(output).toXmlString(pretty: true));
  }
}

// TODO rm?
/* class ArbFileImpl extends FileImpl implements ArbFile {
  ArbFileImpl({
    super.path,
    required String super.name,
  }) : super(extension: 'arb');

  @override
  void setValue<T extends Object?>(Iterable<String> path, T? value) {
    assert(path.length == 1);

    final contents = read();

    final json = jsonDecode(contents);
    json[path.first] = value;

    final output = JsonEncoder.withIndent('  ').convert(json);
    write(output);
  }
} */
