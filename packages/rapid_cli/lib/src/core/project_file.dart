import 'package:dart_style/dart_style.dart';
import 'package:universal_io/io.dart';

/// {@template project_file}
/// Base class for a file in a Rapid project.
/// {@endtemplate}
abstract class ProjectFile {
  /// {@macro project_file}
  ProjectFile(this.path);

  /// The path of this.
  final String path;

  /// The underlying file of this.
  late final File file = File(path);

  /// Wheter the underlying file exists.
  bool exists() => file.existsSync();

  /// Delets the underlying file.
  void delete() => file.deleteSync(recursive: true);
}

// TODO location; ext or class?

final _importRegExp = RegExp('import \'([a-z_/.:]+)\';');

/// Adds functionality for `.dart` files
mixin DartFile on ProjectFile {
  /// Returns the paths of all imports.
  ///
  /// For example:
  ///
  /// import 'foo.dart'; -> foo.dart
  ///
  /// import 'package:foo/foo.dart'; -> package:foo/foo.dart
  List<String> getImports() {
    final lines = file.readAsLinesSync();
    final imports = <String>[];

    for (final line in lines) {
      if (_importRegExp.hasMatch(line)) {
        imports.add(_importRegExp.firstMatch(line)!.group(1)!);
      }
    }

    return imports;
  }

  void addImport(String import, String? alias) {
    final lines = file.readAsLinesSync();

    final importLine = 'import \'$import\'${alias == null ? '' : 'as $alias'};';

    final importsStart =
        lines.indexWhere((line) => _importRegExp.hasMatch(line));
    final importsEnd =
        lines.lastIndexWhere((line) => _importRegExp.hasMatch(line));

    final updatedImports = [
      ...lines.getRange(importsStart, importsEnd + 1),
      importLine,
    ];
    updatedImports.removeWhere((line) => line.isEmpty);

    updatedImports.sort((a, b) {
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
    });

    // TODO use regExps
    final dartImportsEnd = updatedImports
        .lastIndexWhere((import) => import.startsWith('import \'dart'));
    final packageImportsEnd = updatedImports
        .lastIndexWhere((import) => import.startsWith('import \'package'));
    final relativeImportsEnd = updatedImports.lastIndexWhere((import) =>
        import.startsWith('import') &&
        !import.startsWith('import \'package') &&
        !import.startsWith('import \'package'));

    var offset = 0;
    if (dartImportsEnd != -1 && packageImportsEnd != -1) {
      updatedImports.insert(dartImportsEnd + 1, '');
      offset++;
    }

    if (packageImportsEnd != -1 && relativeImportsEnd != -1) {
      updatedImports.insert(packageImportsEnd + offset + 1, '');
    }

    lines.replaceRange(importsStart, importsEnd + 1, updatedImports);
    lines.add('');

    final output = DartFormatter().format(lines.join('\n'));

    file.writeAsStringSync(output);
  }
}
