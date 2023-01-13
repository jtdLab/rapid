import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
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

  List<FileSystemEntity> delete() {
    final deleted = <FileSystemEntity>[];

    late FileSystemEntity entity;
    // TODO

    return deleted;
  }

  bool exists() {
    // TODO
    throw UnimplementedError();
  }
}
