// TODO maybe use seperate regexp for dart, package and relative imports
// TODO support getters and arrow syntax in future and aliases and support for comments

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_builder/code_builder.dart' show DartEmitter, Method;
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';

export 'package:code_builder/code_builder.dart';

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

  List<Declaration> _getTopLevelDeclarations(String source) {
    final unit = parseString(content: source).unit;
    return unit.declarations;
  }

  /// Reads the contents of the underlying file.
  String _read() => _file.readAsStringSync();

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

  /// Adds parameter with [paramName] to the [index]-th call to function with [functionToCallName] inside
  /// the body of function [functionName] and assigns it to [paramValue].
  ///
  /// **IMPORTANT**: Does nothing if the the parameter already exists.
  ///
  /// For example:
  ///
  /// Given:
  /// ```dart
  /// void foo() {
  ///  bar();
  ///  bar();
  /// }
  /// ```
  /// When call:
  /// ```dart
  /// addNamedParamToMethodCallInTopLevelFunctionBody(
  ///   paramName: 'a',
  ///   paramValue: '"hello"',
  ///   functionName: 'foo',
  ///   functionToCallName: 'bar',
  ///   index: 1
  /// );
  /// ```
  /// The result is:
  /// ```dart
  /// void foo() {
  ///  bar();
  ///  bar(
  ///   a: "hello",
  ///  );
  /// }
  /// ```
  void addNamedParamToMethodCallInTopLevelFunctionBody({
    required String paramName,
    required String paramValue,
    required String functionName,
    required String functionToCallName,
    int index = 0,
  }) {
    final contents = _read();

    final declarations = _getTopLevelDeclarations(contents);
    final topLevelFunctions = declarations.whereType<FunctionDeclaration>();
    final mainMethod =
        topLevelFunctions.firstWhere((e) => e.name.lexeme == functionName);
    final mainBody = mainMethod.functionExpression.body.childEntities;
    late final MethodInvocation methodInvocation;
    if (mainBody.first is Block) {
      // block syntax
      // {
      //   return methodToCallName(...;
      // }
      final block = mainBody.first as Block;
      methodInvocation = block.childEntities
          .map(
            (e) {
              if (e is ReturnStatement) {
                return e.expression;
              } else if (e is ExpressionStatement) {
                return e.expression;
              }

              return e;
            },
          )
          .whereType<MethodInvocation>()
          .where((e) => e.methodName.name == functionToCallName)
          .elementAt(index);
    } else {
      // arrow syntax
      // => methodToCallName(...;
      methodInvocation = mainBody
          .whereType<MethodInvocation>()
          .where((e) => e.methodName.name == functionToCallName)
          .first;
    }
    final methodInvocationArgumentList = methodInvocation.argumentList;
    final existingArguments = methodInvocationArgumentList.arguments;
    final exists = existingArguments
        .any((e) => e.toString().split(':').first.trim() == paramName);

    if (!exists) {
      final insertPos = methodInvocationArgumentList.rightParenthesis.offset;
      final insertion = '$paramName: $paramValue,';
      final output = contents.replaceRange(insertPos, insertPos, insertion);

      _write(output);
    }
  }

  /// Adds [function] as a top-level function.
  void addTopLevelFunction(Method function) {
    final contents = _read();

    final declarations = _getTopLevelDeclarations(contents);
    final exists = declarations
        .whereType<FunctionDeclaration>()
        .any((e) => e.name.lexeme == function.name);
    if (!exists) {
      final lastBraceIndex = contents.lastIndexOf('}');
      final insertPos =
          lastBraceIndex == -1 ? contents.length : lastBraceIndex + 1;
      final insertion =
          '\n\n${function.accept(DartEmitter(useNullSafetySyntax: true))}';
      final output = contents.replaceRange(insertPos, insertPos, insertion);

      _write(output);
    }
  }

  /// Returns all [import]s.
  List<String> readImports() {
    final contents = _read();

    final regExp =
        RegExp('import \'([a-z0-9_:./]+)\'( as [a-z]+)?;' r'[\s]{1}');
    final matches = regExp.allMatches(contents);
    final output = <String>[];
    for (final match in matches) {
      output.add(match.group(1)!);
    }

    return output;
  }

  /// Returns a list with the names of all top-level functions.
  List<String> readTopLevelFunctionNames() {
    final contents = _read();

    final declarations = _getTopLevelDeclarations(contents);
    final functions = declarations
        .whereType<FunctionDeclaration>()
        .map((e) => e.name.lexeme)
        .toList();

    return functions;
  }

  /// Reads the [property] of the [annotation] the function with [functionName] is annotated with.
  ///
  /// The property must be list of Type in source file.
  List<String> readTypeListFromAnnotationParamOfTopLevelFunction({
    required String property,
    required String annotation,
    required String functionName,
  }) {
    final contents = _read();

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

  /// Removes [import]
  void removeImport(String import) {
    final contents = _read();

    final regExp = RegExp(
      r"import[\s]+\'" + import + r"\'([\s]+as[\s]+[a-z]+)?;" + r"[\s]{1}",
    );
    final match = regExp.firstMatch(contents);
    if (match == null) {
      return;
    }
    final output = contents.replaceRange(match.start, match.end, '');

    _write(output);
  }

  /// Removes parameter with [paramName] from the [index]-th call to function with [functionToCallName] inside
  /// the body of function [functionName].
  ///
  /// For example:
  ///
  /// Given:
  /// ```dart
  /// void foo() {
  ///  bar();
  ///  bar(
  ///   a: "hello",
  ///  );
  /// }
  /// ```
  /// When call:
  /// ```dart
  /// removeNamedParamFromMethodCallInTopLevelFunctionBody(
  ///   paramName: 'a',
  ///   functionName: 'foo',
  ///   functionToCallName: 'bar',
  ///   index: 1
  /// );
  /// ```
  /// The result is:
  /// ```dart
  /// void foo() {
  ///  bar();
  ///  bar();
  /// }
  /// ```
  void removeNamedParamFromMethodCallInTopLevelFunctionBody({
    required String paramName,
    required String functionName,
    required String functionToCallName,
    int index = 0,
  }) {
    final contents = _read();

    final declarations = _getTopLevelDeclarations(contents);
    final topLevelFunctions = declarations.whereType<FunctionDeclaration>();
    final mainMethod =
        topLevelFunctions.firstWhere((e) => e.name.lexeme == functionName);
    final mainBody = mainMethod.functionExpression.body.childEntities;
    late final MethodInvocation methodInvocation;
    if (mainBody.first is Block) {
      // block syntax
      // {
      //   return methodToCallName(...;
      // }
      final block = mainBody.first as Block;
      methodInvocation = block.childEntities
          .map(
            (e) {
              if (e is ReturnStatement) {
                return e.expression;
              } else if (e is ExpressionStatement) {
                return e.expression;
              }

              return e;
            },
          )
          .whereType<MethodInvocation>()
          .where((e) => e.methodName.name == functionToCallName)
          .elementAt(index);
    } else {
      // arrow syntax
      // => methodToCallName(...;
      methodInvocation = mainBody
          .whereType<MethodInvocation>()
          .where((e) => e.methodName.name == functionToCallName)
          .first;
    }
    final methodInvocationArgumentList = methodInvocation.argumentList;
    final existingArguments = methodInvocationArgumentList.arguments;
    final exists = existingArguments
        .any((e) => e.toString().split(':').first.trim() == paramName);

    if (exists) {
      final argument = existingArguments
          .firstWhere((e) => e.toString().startsWith(paramName));
      final output =
          contents.replaceRange(argument.offset, argument.end + 1, '');

      _write(output);
    }
  }

  /// Removes the top-level function with [name].
  void removeTopLevelFunction(String name) {
    final contents = _read();

    final declarations = _getTopLevelDeclarations(contents);
    final exists = declarations
        .whereType<FunctionDeclaration>()
        .any((e) => e.name.lexeme == name);
    if (exists) {
      final function = declarations
          .firstWhere((e) => e is FunctionDeclaration && e.name.lexeme == name);
      final output = contents.replaceRange(function.offset, function.end, '');

      _write(output);
    }
  }

  /// Sets the [property] of the [annotation] the function with [functionName] is annotated with to [value].
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
  ///   functionName: 'foo
  ///   value: 100
  /// );
  /// ```
  /// The result is:
  /// ```dart
  /// @SomeAnnotation(someProp: 100)
  /// void foo() {}
  /// ```
  void setTypeListOfAnnotationParamOfTopLevelFunction({
    required String property,
    required String annotation,
    required String functionName,
    required List<String> value,
  }) {
    final contents = _read();

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

    final output =
        contents.replaceRange(start, end, '$property: [${value.join(',')},]');
    _write(output);
  }
}
