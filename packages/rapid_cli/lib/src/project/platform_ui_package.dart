import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

/// {@template platform_ui_package}
/// Abstraction of a platform ui package of a Rapid project.
/// {@endtemplate}
class PlatformUiPackage {
  /// {@macro platform_ui_package}
  PlatformUiPackage({required Platform platform, required Project project})
      : _package = DartPackage(
          path: p.join(
            'packages',
            '${project.melosFile.name()}_ui',
            '${project.melosFile.name()}_ui_${platform.name}',
          ),
        );

  final DartPackage _package;

  String get path => _package.path;

  void delete() => _package.delete();

  bool exists() => _package.exists();

  Widget widget({required String name, required String dir}) =>
      Widget(name: name, dir: dir, platformUiPackage: this);
}

/// {@template widget}
/// Abstraction of a widget of a platform ui package of a Rapid project.
/// {@endtemplate}
class Widget {
  /// {@macro widget}
  Widget({
    required String name,
    required String dir,
    required PlatformUiPackage platformUiPackage,
  })  : _name = name,
        _dir = dir,
        _platformUiPackage = platformUiPackage;

  final String _name;
  final String _dir;
  final PlatformUiPackage _platformUiPackage;

  late final Directory _widgetDir = Directory(
      p.join(_platformUiPackage.path, 'lib', 'src', _dir, _name.snakeCase));
  late final _widgetFile =
      File(p.join(_widgetDir.path, '${_name.snakeCase}.dart'));
  late final _widgetThemeFile = File(
    p.join(_widgetDir.path, '${_name.snakeCase}_theme.dart'),
  );
  late final _widgetThemeTailorFile = File(
    p.join(_widgetDir.path, '${_name.snakeCase}_theme.tailor.dart'),
  );
  late final Directory _widgetTestDir = Directory(
      p.join(_platformUiPackage.path, 'test', 'src', _dir, _name.snakeCase));
  late final _widgetTestFile = File(
    p.join(_widgetTestDir.path, '${_name.snakeCase}_test.dart'),
  );

  List<FileSystemEntity> delete() {
    final deleted = <FileSystemEntity>[];

    late FileSystemEntity entity;
    // source dir + files
    entity = _widgetFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _widgetThemeFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _widgetThemeTailorFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _widgetDir;
    if ((entity as Directory).listSync().isEmpty) {
      entity.deleteSync();
      deleted.add(entity);
    }

    // test dir + file
    entity = _widgetTestFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _widgetTestDir;
    if (entity.existsSync()) {
      if ((entity as Directory).listSync().isEmpty) {
        entity.deleteSync();
        deleted.add(entity);
      }
    }

    return deleted..sort((a, b) => a.path.compareTo(b.path));
  }

  /// Wheter an underlying [FileSystemEntity] related to this exists on disk.
  bool exists() {
    final widgetDir = _widgetDir;
    if (widgetDir.existsSync() && widgetDir.listSync().isEmpty) {
      return true;
    }

    final widgetTestDir = _widgetTestDir;
    if (widgetTestDir.existsSync() && widgetTestDir.listSync().isEmpty) {
      return true;
    }

    return _widgetFile.existsSync() ||
        _widgetThemeFile.existsSync() ||
        _widgetThemeTailorFile.existsSync() ||
        _widgetTestFile.existsSync();
  }
}
