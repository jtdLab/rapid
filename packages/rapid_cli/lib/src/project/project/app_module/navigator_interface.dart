part of '../../project.dart';

class NavigatorInterface extends FileSystemEntityCollection {
  NavigatorInterface({
    required this.path,
    required this.name,
  });

  final String path;

  final String name;

  File get file =>
      File(p.join(path, 'lib', 'src', 'i_${name.snakeCase}_navigator.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
      };

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
