// TODO maybe use seperate regexp for dart, package and relative imports
// TODO support getters and arrow syntax in future and aliases and support for comments

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_builder/code_builder.dart' show Method, DartEmitter;
import 'package:dart_style/dart_style.dart';
import 'package:rapid_cli/src/core/dart_file.dart' show DartFile;
import 'package:rapid_cli/src/core/file_impl.dart';

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
    RegExp('export \'([a-z_/.:]+)\' (:?hide|show) [A-Z]+[A-z1-9]*;');

class DartFileImpl extends FileImpl implements DartFile {
  DartFileImpl({
    super.path,
    required String super.name,
  }) : super(extension: 'dart');

  @override
  void write(String contents) => super.write(DartFormatter().format(contents));

  @override
  void addImport(String import, {String? alias}) {
    final contents = read();

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
    write(output);
  }

  @override
  void addExport(String export) {
    final contents = read();

    final existingExports =
        contents.split('\n').where((line) => _exportRegExp.hasMatch(line));
    if (existingExports.contains('export \'$export\';')) {
      return;
    }

    final updatedExports = [...existingExports, 'export \'$export\';'];
    updatedExports.sort(_compareExports);

    final output = contents.replaceRange(
      // start of old exports
      contents.indexOf(_exportRegExp),
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
    write(output);
  }

  @override
  void addNamedParamToMethodCallInTopLevelFunctionBody({
    required String paramName,
    required String paramValue,
    required String functionName,
    required String functionToCallName,
    int index = 0,
  }) {
    final contents = read();

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

      write(output);
    }
  }

  @override
  void addTopLevelFunction(Method function) {
    final contents = read();

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

      write(output);
    }
  }

  @override
  List<String> readImports() {
    final contents = read();

    final regExp =
        RegExp('import \'([a-z0-9_:./]+)\'( as [a-z]+)?;' r'[\s]{1}');
    final matches = regExp.allMatches(contents);
    final output = <String>[];
    for (final match in matches) {
      output.add(match.group(1)!);
    }

    return output;
  }

  @override
  List<String> readTopLevelFunctionNames() {
    final contents = read();

    final declarations = _getTopLevelDeclarations(contents);
    final functions = declarations
        .whereType<FunctionDeclaration>()
        .map((e) => e.name.lexeme)
        .toList();

    return functions;
  }

  @override
  List<String> readTopLevelListVar({required String name}) {
    final contents = read();

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

  @override
  List<String> readTypeListFromAnnotationParamOfTopLevelFunction({
    required String property,
    required String annotation,
    required String functionName,
  }) {
    final contents = read();

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

  @override
  void removeImport(String import) {
    final contents = read();

    final regExp = RegExp(
      r"import[\s]+\'" + import + r"\'([\s]+as[\s]+[a-z]+)?;" + r"[\s]{1}",
    );
    final match = regExp.firstMatch(contents);
    if (match == null) {
      return;
    }
    final output = contents.replaceRange(match.start, match.end, '');

    write(output);
  }

  @override
  void removeExport(String export) {
    final contents = read();

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

    write(output);
  }

  @override
  void removeNamedParamFromMethodCallInTopLevelFunctionBody({
    required String paramName,
    required String functionName,
    required String functionToCallName,
    int index = 0,
  }) {
    final contents = read();

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

      write(output);
    }
  }

  @override
  void removeTopLevelFunction(String name) {
    final contents = read();

    final declarations = _getTopLevelDeclarations(contents);
    final exists = declarations
        .whereType<FunctionDeclaration>()
        .any((e) => e.name.lexeme == name);
    if (exists) {
      final function = declarations
          .firstWhere((e) => e is FunctionDeclaration && e.name.lexeme == name);
      final output = contents.replaceRange(function.offset, function.end, '');

      write(output);
    }
  }

  @override
  void setTopLevelListVar({
    required String name,
    required List<String> value,
  }) {
    final contents = read();

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

    write(output);
  }

  @override
  void setTypeListOfAnnotationParamOfTopLevelFunction({
    required String property,
    required String annotation,
    required String functionName,
    required List<String> value,
  }) {
    final contents = read();

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

    write(output);
  }

  List<Declaration> _getTopLevelDeclarations(String source) {
    final unit = parseString(content: source).unit;
    return unit.declarations;
  }
}
