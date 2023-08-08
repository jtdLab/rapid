part of '../project.dart';

/// {@template navigator_interface}
/// Abstraction of a navigator interface of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class NavigatorInterface extends FileSystemEntityCollection {
  /// {@macro navigator_interface}
  NavigatorInterface({
    required this.path,
    required this.name,
  });

  /// The path of the platform navigation package this navigator interface is
  /// part of.
  final String path;

  /// The name of this navigator interface.
  final String name;

  /// The `lib/src/i_<name>_navigator.dart` file.
  File get file =>
      File(p.join(path, 'lib', 'src', 'i_${name.snakeCase}_navigator.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
      };

  /// Generate this navigator interface on disk.
  Future<void> generate() async {
    await mason.generate(
      bundle: navigatorInterfaceBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'name': name,
      },
    );
  }
}
