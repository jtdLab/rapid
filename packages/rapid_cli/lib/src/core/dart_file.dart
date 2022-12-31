// TODO impl cleaner using a dart parse library like analyzer to get the AST instead of manually parsing strings
// TODO maybe use seperate regexp for dart, package and relative imports
// TODO support getters and arrow syntax in future and aliases and support for comments

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';

export 'package:code_builder/code_builder.dart';

/// Thrown when [DartFile.addMethod] is used to add an already existing method.
class MethodAlreadyExists implements Exception {}

/// Thrown when [DartFile.addMethod] is used with a scope that does not exist.
class ScopeNotFound implements Exception {}

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

final _importRegExp = RegExp('import \'([a-z_/.:]+)\'( as [a-z]+)?;');

final _methodHeadRegExp = RegExp(r'[\w<>]+\s+([\w]+)\([\w\s,?[\]{}]*\)');

class _Scope {
  _Scope(this.name, this.contents, this.start, this.end);

  final String? name;
  final String contents;
  final int start;
  final int end;

  bool get isRoot => name == null;

  bool hasMethod(String name) => getMethods().any((e) => e.name == name);

  List<_Method> getMethods() {
    late final RegExp classMixinOrExtensionRegExp;
    if (isRoot) {
      classMixinOrExtensionRegExp =
          RegExp(r'(?:[\s]|^)(class|extension|mixin)(?=[\s]|$)');

      // Remove all classes
      var contents = this.contents;
      var offset = 0;
      for (final match
          in classMixinOrExtensionRegExp.allMatches(this.contents)) {
        final start = match.start;
        final end = this
                .contents
                .indexOfClosingBrace(this.contents.indexOf('{', start)) +
            1;
        contents = contents.replaceRange(start - offset, end - offset, '');
        offset += (end - start);
      }

      // TODO here the start and end is wrong
      return _methodHeadRegExp.allMatches(contents).map(
        (match) {
          final method = contents.substring(
            match.start,
            contents.indexOfClosingBrace(contents.indexOf('{', match.start)) +
                1,
          );

          final start = this.contents.indexOf(method);
          final end = start + method.length;

          return _Method(match.group(1)!, contents, start, end);
        },
      ).toList();
    } else {
      classMixinOrExtensionRegExp =
          RegExp(r'(?:[\s]|^)(class|extension|mixin)(?=[\s]|$) ' + name!);

      // TODO here the start and end is wrong
      return _methodHeadRegExp.allMatches(contents).map(
        (match) {
          final start = match.start;
          final end =
              contents.indexOfClosingBrace(contents.indexOf('{', start)) + 1;

          return _Method(
            match.group(1)!,
            contents,
            start,
            end,
          );
        },
      ).toList();
    }
  }
}

class _Method {
  _Method(this.name, this.contents, this.start, this.end);

  final String name;
  final String contents;
  final int start;
  final int end;
}

extension on String {
  int indexOfClosingBrace(int openingBraceIndex) {
    if (openingBraceIndex == -1) {
      return length - 1;
    }

    assert(this[openingBraceIndex] == '{');

    int count = 0;
    for (int i = openingBraceIndex; i < length; i++) {
      final char = this[i];
      if (char == '{') {
        count++;
        continue;
      }

      if (char == '}') {
        count--;

        if (count == 0) {
          return i;
        }
      }
    }

    return -1;
  }
}

/// {@template dart_file}
/// Abstraction of a dart file.
/// {@endtemplate}
class DartFile {
  /// {@macro dart_file}
  DartFile({
    String path = '.',
    required String name,
  }) : _file = File(p.normalize(p.join(path, '$name.dart')));

  /// The underlying file
  final File _file;

  String get path => _file.path;

  /// [name] = null refers to the root scope
  _Scope _getScope(String? name, String contents) {
    if (name == null) {
      return _Scope(name, contents, 0, contents.length);
    }

    final classMixinOrExtensionRegExp =
        RegExp(r'(?:[\s]|^)(class|extension|mixin)(?=[\s]|$) ' + name);

    final parentExists = classMixinOrExtensionRegExp.hasMatch(contents);
    if (parentExists) {
      final matchStart =
          classMixinOrExtensionRegExp.firstMatch(contents)!.start;
      final start = matchStart;
      final end = contents.indexOfClosingBrace(
        contents.indexOf('{', matchStart),
      );
      return _Scope(name, contents.substring(start, end), start, end);
    }

    throw ScopeNotFound();
  }

  /// Inserts [code] at [start].
  void _insertCode(String code, {required int start}) {
    var contents = _read();

    final output = contents.replaceRange(start, start, code);

    _write(output);
  }

  /// Inserts [code] after the [occurence] match of [pattern].
  void _insertCodeAfterPattern(String code,
      {required RegExp pattern, int occurence = 0}) {
    var contents = _read();

    final matches = pattern.allMatches(contents);
    if (occurence + 1 <= matches.length) {
      final match = matches.elementAt(occurence);
      final start =
          match.start + match.group(0)!.length + 1; // TODO +1 needed ?
      final output = contents.replaceRange(start, start, code);
      _write(output);
    }
  }

  /// Reads the contents of the underlying file.
  String _read() => _file.readAsStringSync();

  /// Removes code from [start] to [end] (both inclusive).
  void _removeCode(int start, int end) {
    final contents = _read();

    final output = contents.replaceRange(start, end, '');

    _write(output);
  }

  /// Formates and writes [contents] to the underlying file.
  void _write(String contents) =>
      _file.writeAsStringSync(DartFormatter().format(contents), flush: true);

  /// Adds [import] with an optional [alias].
  ///
  /// Hint: The imports get sorted after adding
  void addImport(String import, {String? alias}) {
    final contents = _read();

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
    _write(output);
  }

  /// Adds [method] as a member function of [parent] (class, mixin, extension).
  ///
  /// If [parent] is null [method] gets added as a top level function.
  void addMethod(Method method, {String? parent}) {
    final contents = _read();

    final scope = _getScope(parent, contents);
    final methodExists = scope.hasMethod(method.name!);
    if (!methodExists) {
      _write(
        contents.replaceRange(
          (scope.end - 1) > 0 ? (scope.end - 1) : 0,
          scope.end,
          '${method.accept(DartEmitter())}',
        ),
      );
    } else {
      throw MethodAlreadyExists();
    }
  }

  void addNamedParamToMethodCall(
    String methodName,
    String paramName,
    String paramValue, {
    String? parent,
  }) {
    // TODO
  }

  /// Removes [import]
  void removeImport(String import) {
    final contents = _read();

    final regExp = RegExp('import \'$import\'( as [a-z]+)?;' r'[\s]*');
    final match = regExp.firstMatch(contents);
    if (match == null) {
      return;
    }
    final output = contents.replaceRange(match.start, match.end, '');

    _write(output);
  }

  /// Removes the member function of [parent] with [name].
  ///
  /// If [parent] is null the top level function with [name] gets removed.
  void removeMethod(String name, {String? parent}) {
    final contents = _read();

    final scope = _getScope(parent, contents);
    final methodExists = scope.hasMethod(name);
    if (methodExists) {
      final method = scope.getMethods().firstWhere((e) => e.name == name);

      final offset = scope.isRoot ? 0 : contents.indexOf(method.contents);

      _write(
        contents.replaceRange(method.start + offset, method.end + offset, ''),
      );
    }
  }

  void removeNamedParamFromMethodCall(
    String method,
    String param, {
    String? parent,
  }) {
    // TODO
  }

  /// Sets the [property] of [annotation] to [value].
  ///
  /// For example:
  ///
  /// Given:
  /// ```dart
  /// @SomeAnnotation(someProp: 5)
  /// void foo() {}
  /// ```
  /// When call:
  /// ```dart
  /// setAnnotationProperty(
  ///   property: 'someProp',
  ///   annotation: 'SomeAnnotation',
  ///   value: 100
  /// );
  /// ```
  /// The result is:
  /// ```dart
  /// @SomeAnnotation(someProp: 100)
  /// void foo() {}
  /// ```
  void setAnnotationProperty<T extends Object?>({
    required String property,
    required String annotation,
    required T value,
  }) {
    final contents = _read();
    // TODO: impl
    final output = contents;
    _write(output);
  }
}
