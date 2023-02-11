import 'dart:io';

import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';

const dartFileWith2ImportsPerType = '''
import 'dart:aaa';
import 'dart:ccc' as c;

import 'package:aaa/aaa.dart';
import 'package:ccc/ccc.dart';

import 'aaa.dart';
import 'ccc.dart';

void main() {}
''';

const dartFileWithAdditionalDartImport = '''
import 'dart:aaa';
import 'dart:bbb';
import 'dart:ccc' as c;

import 'package:aaa/aaa.dart';
import 'package:ccc/ccc.dart';

import 'aaa.dart';
import 'ccc.dart';

void main() {}
''';

const dartFileWithAdditionalPackageImport = '''
import 'dart:aaa';
import 'dart:ccc' as c;

import 'package:aaa/aaa.dart';
import 'package:bbb/bbb.dart';
import 'package:ccc/ccc.dart';

import 'aaa.dart';
import 'ccc.dart';

void main() {}
''';

const dartFileWithAdditionalRelativeImport = '''
import 'dart:aaa';
import 'dart:ccc' as c;

import 'package:aaa/aaa.dart';
import 'package:ccc/ccc.dart';

import 'aaa.dart';
import 'bbb.dart';
import 'ccc.dart';

void main() {}
''';

const dartFileWithAdditionalAliasImport = '''
import 'dart:aaa';
import 'dart:ccc' as c;

import 'package:aaa/aaa.dart';
import 'package:bbb/bbb.dart' as b;
import 'package:ccc/ccc.dart';

import 'aaa.dart';
import 'ccc.dart';

void main() {}
''';

const dartFileWithMethods = '''
import 'dart:aaa';

Future<int?> bbb() {
  print('bbb');
}

class Foo {
  int bbb() {
    print('Foo.bbb');
  }
}

class Bar {
  Future<void> bbb() {
    print('Bar.bbb');
  }
}
''';

const dartFileWithClassesOnly = '''
import 'dart:aaa';

class Foo {
  int bbb() {
    print('Foo.bbb');
  }
}

class Bar {
  Future<void> bbb() {
    print('Bar.bbb');
  }
}
''';

const dartFileWithAdditionalTopLevelMethod = '''
import 'dart:aaa';

Future<int?> bbb() {
  print('bbb');
}

class Foo {
  int bbb() {
    print('Foo.bbb');
  }
}

class Bar {
  Future<void> bbb() {
    print('Bar.bbb');
  }
}

String aaa() {
  print(1);
}
''';

const dartFileWithAdditionalMemberMethod = '''
import 'dart:aaa';

Future<int?> bbb() {
  print('bbb');
}

class Foo {
  int bbb() {
    print('Foo.bbb');
  }

  String aaa() {
    print(1);
  }
}

class Bar {
  Future<void> bbb() {
    print('Bar.bbb');
  }
}
''';

const emptyDartFile = '';

const dartFileWithSingleMethod = '''
String aaa() {
  print(1);
}
''';

const dartFileWithTopLevelFunctionInArrowSyntax = '''
void foo() => bar();
''';

const dartFileWithTopLevelFunctionInArrowSyntaxWithParam = '''
void foo() => bar(
      a: '3',
    );
''';

const dartFileWithTopLevelFunctionInBodySyntax = '''
void foo() {
  kuku();
  bar();
  boz();
  bar();
}
''';

const dartFileWithTopLevelFunctionInBodySyntaxWithReturn = '''
void foo() {
  kuku();
  return bar();
}
''';

const dartFileWithTopLevelFunctionInBodySyntaxWithParam = '''
void foo() {
  kuku();
  bar(
    z: 88,
  );
  boz();
  bar();
}
''';

const dartFileWithTopLevelFunctionInBodySyntaxWithParamAndReturn = '''
void foo() {
  kuku();
  return bar(
    z: 88,
  );
}
''';

const dartFileWithTopLevelFunctionInBodySyntaxWithParamAndIndex = '''
void foo() {
  kuku();
  bar();
  boz();
  bar(
    z: 88,
  );
}
''';

const dartFileWithAnnotatedTopLevelFunction = '''
@MyAnnotation(
  myArg: [
    A,
    B,
    C,
  ],
)
void foo() {}
''';

const dartFileWithAnnotatedTopLevelFunctionMore = '''
@MyAnnotation(
  myArg: [
    A,
    B,
    C,
    D,
  ],
)
void foo() {}
''';

const dartFileWithAnnotatedTopLevelFunctionMoreMulti = '''
@Bar
@MyAnnotation(
  myArg: [
    A,
    B,
    C,
    D,
  ],
)
@Baz
void foo() {}
''';

const dartFileWithAnnotatedTopLevelFunctionWithEmptyArg = '''
@MyAnnotation(
  myArg: [],
)
void foo() {}
''';

const dartFileWithAnnotatedTopLevelFunctionMulti = '''
@Bar
@MyAnnotation(
  myArg: [
    A,
    B,
    C,
  ],
)
@Baz
void foo() {}
''';

const dartFileWithAnnotatedTopLevelFunctionWithEmptyArgMulti = '''
@Bar
@MyAnnotation(
  myArg: [],
)
@Baz
void foo() {}
''';

const dartFileWithAnnotatedTopLevelFunctionMultipleArgsEmpty = '''
@Bar
@MyAnnotation(
  myArg: [],
  foo: 3,
)
@Baz
void foo() {}
''';

const dartFileWithAnnotatedTopLevelFunctionMultipleArgsMore = '''
@Bar
@MyAnnotation(
  myArg: [
    A,
    B,
    C,
  ],
  foo: 3,
)
@Baz
void foo() {}
''';

const dartFileWithoutImports = '''
void main() {}
''';

const dartFileWithImports = '''
import 'dart:aaa';
import 'dart:ccc' as c;
''';

const dartFileWithoutTopLevelFunctions = '''''';

const dartFileWithTopLevelFunctions = '''
void main() {}

Future<int> runSomeCode() => 1;

String? someText() {
  return 'Hello';
}
''';

const dartFileWithLongDartImportWithAlias = '''
import 'package:aaa/aaa.dart';
import 'package:ccc_ccc_ccc_ccc_ccc_ccc_ccc/ccc_ccc_ccc_ccc_ccc_ccc_ccc.dart'
    as c;

void main() {}
''';

const dartFileWithoutLongDartImportWithAlias = '''
import 'package:aaa/aaa.dart';

void main() {}
''';

const dartFileWithTopLevelListEmpty = '''
final someList = [];
''';

const dartFileWithTopLevelListEmptyWithGenerics = '''
final someList = <dynamic>[];
''';

const dartFileWithTopLevelList = '''
final someList = [
  'A',
  3,
  true,
];
''';

const dartFileWithTopLevelListWithGenerics = '''
final someList = <dynamic>[
  'A',
  3,
  true,
];
''';

DartFile _getDartFile({
  String? path,
  String? name,
}) {
  return DartFile(
    path: path ?? 'some/path',
    name: name ?? 'some',
  );
}

void main() {
  group('DartFile', () {
    test('.path', () {
      // Arrange
      final dartFile = _getDartFile(path: 'dart_file/path', name: 'foo');

      // Act + Assert
      expect(dartFile.path, 'dart_file/path/foo.dart');
    });

    group('.exists()', () {
      test(
        'returns true when underlying file exists',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path).createSync(recursive: true);

          // Act + Assert
          expect(dartFile.exists(), true);
        }),
      );

      test(
        'returns true when underlying file does not exist',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();

          // Act + Assert
          expect(dartFile.exists(), false);
        }),
      );
    });

    group('.delete()', () {
      test(
        'deletes the file',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)..createSync(recursive: true);

          // Act
          dartFile.delete(logger: FakeLogger());

          // Assert
          expect(file.existsSync(), false);
        }),
      );
    });

    group('.addImport()', () {
      test(
        'adds dart import correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWith2ImportsPerType);

          // Act
          dartFile.addImport('dart:bbb');

          // Assert
          expect(file.readAsStringSync(), dartFileWithAdditionalDartImport);
        }),
      );

      test(
        'adds package import correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWith2ImportsPerType);

          // Act
          dartFile.addImport('package:bbb/bbb.dart');

          // Assert
          expect(file.readAsStringSync(), dartFileWithAdditionalPackageImport);
        }),
      );

      test(
        'adds relative import correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWith2ImportsPerType);

          // Act
          dartFile.addImport('bbb.dart');

          // Assert
          expect(file.readAsStringSync(), dartFileWithAdditionalRelativeImport);
        }),
      );

      test(
        'adds import with alias correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWith2ImportsPerType);

          // Act
          dartFile.addImport('package:bbb/bbb.dart', alias: 'b');

          // Assert
          expect(file.readAsStringSync(), dartFileWithAdditionalAliasImport);
        }),
      );

      test(
        'does nothing when import already exists',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWith2ImportsPerType);

          // Act
          dartFile.addImport('package:ccc/ccc.dart');

          // Assert
          expect(file.readAsStringSync(), dartFileWith2ImportsPerType);
        }),
      );
    });

    group('.addNamedParamToMethodCallInTopLevelFunctionBody()', () {
      test(
        'adds named param correctly to referenced function call (arrow syntax)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithTopLevelFunctionInArrowSyntax);

          // Act
          dartFile.addNamedParamToMethodCallInTopLevelFunctionBody(
            paramName: 'a',
            paramValue: '\'3\'',
            functionName: 'foo',
            functionToCallName: 'bar',
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithTopLevelFunctionInArrowSyntaxWithParam,
          );
        }),
      );

      test(
        'adds named param correctly to referenced function call (body syntax)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithTopLevelFunctionInBodySyntax);

          // Act
          dartFile.addNamedParamToMethodCallInTopLevelFunctionBody(
            paramName: 'z',
            paramValue: '88',
            functionName: 'foo',
            functionToCallName: 'bar',
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithTopLevelFunctionInBodySyntaxWithParam,
          );
        }),
      );

      test(
        'adds named param correctly to referenced function call (body syntax with return)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              dartFileWithTopLevelFunctionInBodySyntaxWithReturn,
            );

          // Act
          dartFile.addNamedParamToMethodCallInTopLevelFunctionBody(
            paramName: 'z',
            paramValue: '88',
            functionName: 'foo',
            functionToCallName: 'bar',
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithTopLevelFunctionInBodySyntaxWithParamAndReturn,
          );
        }),
      );

      test(
        'adds named param correctly to referenced function call when index is not 0 (body syntax)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithTopLevelFunctionInBodySyntax);

          // Act
          dartFile.addNamedParamToMethodCallInTopLevelFunctionBody(
            paramName: 'z',
            paramValue: '88',
            functionName: 'foo',
            functionToCallName: 'bar',
            index: 1,
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithTopLevelFunctionInBodySyntaxWithParamAndIndex,
          );
        }),
      );

      test(
        'does nothing when param already exists (arrow syntax)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              dartFileWithTopLevelFunctionInArrowSyntaxWithParam,
            );

          // Act
          dartFile.addNamedParamToMethodCallInTopLevelFunctionBody(
            paramName: 'a',
            paramValue: '\'33\'',
            functionName: 'foo',
            functionToCallName: 'bar',
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithTopLevelFunctionInArrowSyntaxWithParam,
          );
        }),
      );

      test(
        'does nothing when param already exists (body syntax)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              dartFileWithTopLevelFunctionInBodySyntaxWithParam,
            );

          // Act
          dartFile.addNamedParamToMethodCallInTopLevelFunctionBody(
            paramName: 'z',
            paramValue: '100',
            functionName: 'foo',
            functionToCallName: 'bar',
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithTopLevelFunctionInBodySyntaxWithParam,
          );
        }),
      );
    });

    group('.addTopLevelFunction()', () {
      test(
        'adds top level function correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithMethods);

          // Act
          dartFile.addTopLevelFunction(
            Method(
              (m) => m
                ..returns = refer('String')
                ..name = 'aaa'
                ..body = Code('print(1);'),
            ),
          );

          // Assert
          expect(file.readAsStringSync(), dartFileWithAdditionalTopLevelMethod);
        }),
      );

      test(
        'adds top level function correctly when file is empty',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(emptyDartFile);

          // Act
          dartFile.addTopLevelFunction(
            Method(
              (m) => m
                ..returns = refer('String')
                ..name = 'aaa'
                ..body = Code('print(1);'),
            ),
          );

          // Assert
          expect(file.readAsStringSync(), dartFileWithSingleMethod);
        }),
      );

      test(
        'does nothing when top level function with given name already exists',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithMethods);

          // Act
          dartFile.addTopLevelFunction(
            Method(
              (m) => m
                ..returns = refer('String')
                ..name = 'bbb'
                ..body = Code('print(1);'),
            ),
          );

          // Assert
          expect(file.readAsStringSync(), dartFileWithMethods);
        }),
      );
    });

    group('.readImports()', () {
      test(
        'returns correct imports',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithImports);

          // Act + Assert
          expect(dartFile.readImports(), ['dart:aaa', 'dart:ccc']);
        }),
      );

      test(
        'returns no imports when no imports exists',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithoutImports);

          // Act + Assert
          expect(dartFile.readImports(), []);
        }),
      );
    });

    group('.readTopLevelFunctionNames()', () {
      test(
        'returns names of top level functions',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithTopLevelFunctions);

          // Act + Assert
          expect(
            dartFile.readTopLevelFunctionNames(),
            ['main', 'runSomeCode', 'someText'],
          );
        }),
      );

      test(
        'returns empty list when no top level functions exist',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithoutTopLevelFunctions);

          // Act + Assert
          expect(dartFile.readTopLevelFunctionNames(), isEmpty);
        }),
      );
    });

    group('.readTopLevelListVar()', () {
      test(
        'returns empty list when list is empty',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithTopLevelListEmpty);

          // Act + Assert
          expect(dartFile.readTopLevelListVar(name: 'someList'), isEmpty);
        }),
      );

      test(
        'returns list with values as string',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithTopLevelList);

          // Act + Assert
          expect(
            dartFile.readTopLevelListVar(name: 'someList'),
            ['\'A\'', '3', 'true'],
          );
        }),
      );

      test(
        'returns list with values as string when list has generics',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithTopLevelListWithGenerics);

          // Act + Assert
          expect(
            dartFile.readTopLevelListVar(name: 'someList'),
            ['\'A\'', '3', 'true'],
          );
        }),
      );
    });

    group('.readTypeListFromAnnotationParamOfTopLevelFunction()', () {
      test(
        'returns list with type names',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithAnnotatedTopLevelFunction);

          // Act + Assert
          expect(
            dartFile.readTypeListFromAnnotationParamOfTopLevelFunction(
              property: 'myArg',
              annotation: 'MyAnnotation',
              functionName: 'foo',
            ),
            ['A', 'B', 'C'],
          );
        }),
      );

      test(
        'returns empty list when no types exist',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              dartFileWithAnnotatedTopLevelFunctionWithEmptyArg,
            );

          // Act + Assert
          expect(
            dartFile.readTypeListFromAnnotationParamOfTopLevelFunction(
              property: 'myArg',
              annotation: 'MyAnnotation',
              functionName: 'foo',
            ),
            [],
          );
        }),
      );

      test(
        'returns list with type names (multiple annotations)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithAnnotatedTopLevelFunctionMulti);

          // Act + Assert
          expect(
            dartFile.readTypeListFromAnnotationParamOfTopLevelFunction(
              property: 'myArg',
              annotation: 'MyAnnotation',
              functionName: 'foo',
            ),
            ['A', 'B', 'C'],
          );
        }),
      );

      test(
        'returns empty list when no types exist (multiple annotations)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
                dartFileWithAnnotatedTopLevelFunctionWithEmptyArgMulti);

          // Act + Assert
          expect(
            dartFile.readTypeListFromAnnotationParamOfTopLevelFunction(
              property: 'myArg',
              annotation: 'MyAnnotation',
              functionName: 'foo',
            ),
            [],
          );
        }),
      );

      test(
        'returns list with type names (multiple annotations & args)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
                dartFileWithAnnotatedTopLevelFunctionMultipleArgsMore);

          // Act + Assert
          expect(
            dartFile.readTypeListFromAnnotationParamOfTopLevelFunction(
              property: 'myArg',
              annotation: 'MyAnnotation',
              functionName: 'foo',
            ),
            ['A', 'B', 'C'],
          );
        }),
      );
    });

    group('removeImport', () {
      test(
        'removes import correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithAdditionalDartImport);

          // Act
          dartFile.removeImport('dart:bbb');

          // Assert
          expect(file.readAsStringSync(), dartFileWith2ImportsPerType);
        }),
      );

      test(
        'removes import with alias correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithAdditionalAliasImport);

          // Act
          dartFile.removeImport('package:bbb/bbb.dart');

          // Assert
          expect(file.readAsStringSync(), dartFileWith2ImportsPerType);
        }),
      );

      test(
        'removes long import with alias correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithLongDartImportWithAlias);

          // Act
          dartFile.removeImport(
            'package:ccc_ccc_ccc_ccc_ccc_ccc_ccc/ccc_ccc_ccc_ccc_ccc_ccc_ccc.dart',
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithoutLongDartImportWithAlias,
          );
        }),
      );

      test(
        'does nothing when import does not exist',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWith2ImportsPerType);

          // Act
          dartFile.removeImport('dart:zzz');

          // Assert
          expect(file.readAsStringSync(), dartFileWith2ImportsPerType);
        }),
      );
    });

    group('.removeNamedParamFromMethodCallInTopLevelFunctionBody()', () {
      test(
        'removes named param correctly from referenced function call (arrow syntax)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              dartFileWithTopLevelFunctionInArrowSyntaxWithParam,
            );

          // Act
          dartFile.removeNamedParamFromMethodCallInTopLevelFunctionBody(
            paramName: 'a',
            functionName: 'foo',
            functionToCallName: 'bar',
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithTopLevelFunctionInArrowSyntax,
          );
        }),
      );

      test(
        'removes named param correctly from referenced function call (body syntax)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
                dartFileWithTopLevelFunctionInBodySyntaxWithParam);

          // Act
          dartFile.removeNamedParamFromMethodCallInTopLevelFunctionBody(
            paramName: 'z',
            functionName: 'foo',
            functionToCallName: 'bar',
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithTopLevelFunctionInBodySyntax,
          );
        }),
      );

      test(
        'remove named param correctly from referenced function call (body syntax with return)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
                dartFileWithTopLevelFunctionInBodySyntaxWithParamAndReturn);

          // Act
          dartFile.removeNamedParamFromMethodCallInTopLevelFunctionBody(
            paramName: 'z',
            functionName: 'foo',
            functionToCallName: 'bar',
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithTopLevelFunctionInBodySyntaxWithReturn,
          );
        }),
      );

      test(
        'remove named param correctly to referenced function call when index is not 0 (body syntax)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
                dartFileWithTopLevelFunctionInBodySyntaxWithParamAndIndex);

          // Act
          dartFile.removeNamedParamFromMethodCallInTopLevelFunctionBody(
            paramName: 'z',
            functionName: 'foo',
            functionToCallName: 'bar',
            index: 1,
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithTopLevelFunctionInBodySyntax,
          );
        }),
      );

      test(
        'does nothing when param does not exists (arrow syntax)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithTopLevelFunctionInArrowSyntax);

          // Act
          dartFile.removeNamedParamFromMethodCallInTopLevelFunctionBody(
            paramName: 'a',
            functionName: 'foo',
            functionToCallName: 'bar',
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithTopLevelFunctionInArrowSyntax,
          );
        }),
      );

      test(
        'does nothing when param does not exists (body syntax)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithTopLevelFunctionInBodySyntax);

          // Act
          dartFile.removeNamedParamFromMethodCallInTopLevelFunctionBody(
            paramName: 'z',
            functionName: 'foo',
            functionToCallName: 'bar',
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithTopLevelFunctionInBodySyntax,
          );
        }),
      );
    });

    group('.removeTopLevelFunction()', () {
      test(
        'removes top level function correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithAdditionalTopLevelMethod);

          // Act
          dartFile.removeTopLevelFunction('aaa');

          // Assert
          expect(file.readAsStringSync(), dartFileWithMethods);
        }),
      );

      test(
        'removes top level function correctly (2)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithMethods);

          // Act
          dartFile.removeTopLevelFunction('bbb');

          // Assert
          expect(file.readAsStringSync(), dartFileWithClassesOnly);
        }),
      );

      test(
        'does nothing when top level function does not exist',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithMethods);

          // Act
          dartFile.removeTopLevelFunction('zzz');

          // Assert
          expect(file.readAsStringSync(), dartFileWithMethods);
        }),
      );

      test(
        'does nothing when file is empty',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(emptyDartFile);

          // Act
          dartFile.removeTopLevelFunction('zzz');

          // Assert
          expect(file.readAsStringSync(), emptyDartFile);
        }),
      );
    });

    group('.setTopLevelListVar()', () {
      test(
        'sets list correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              dartFileWithTopLevelListEmpty,
            );

          // Act
          dartFile.setTopLevelListVar(
            name: 'someList',
            value: ['\'A\'', '3', 'true'],
          );

          // Assert
          expect(file.readAsStringSync(), dartFileWithTopLevelList);
        }),
      );

      test(
        'sets list correctly (generics)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              dartFileWithTopLevelListEmptyWithGenerics,
            );

          // Act
          dartFile.setTopLevelListVar(
            name: 'someList',
            value: ['\'A\'', '3', 'true'],
          );

          // Assert
          expect(file.readAsStringSync(), dartFileWithTopLevelListWithGenerics);
        }),
      );

      test(
        'sets list to be empty correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              dartFileWithTopLevelList,
            );

          // Act
          dartFile.setTopLevelListVar(
            name: 'someList',
            value: [],
          );

          // Assert
          expect(file.readAsStringSync(), dartFileWithTopLevelListEmpty);
        }),
      );

      test(
        'sets list to be empty correctly (generics)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              dartFileWithTopLevelListWithGenerics,
            );

          // Act
          dartFile.setTopLevelListVar(
            name: 'someList',
            value: [],
          );

          // Assert
          expect(file.readAsStringSync(),
              dartFileWithTopLevelListEmptyWithGenerics);
        }),
      );
    });

    group('.setTypeListOfAnnotationParamOfTopLevelFunction()', () {
      test(
        'sets type list correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              dartFileWithAnnotatedTopLevelFunctionWithEmptyArg,
            );

          // Act
          dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
            property: 'myArg',
            annotation: 'MyAnnotation',
            functionName: 'foo',
            value: ['A', 'B', 'C'],
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithAnnotatedTopLevelFunction,
          );
        }),
      );

      test(
        'sets type list correctly when some types already exists',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithAnnotatedTopLevelFunction);

          // Act
          dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
            property: 'myArg',
            annotation: 'MyAnnotation',
            functionName: 'foo',
            value: ['A', 'B', 'C', 'D'],
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithAnnotatedTopLevelFunctionMore,
          );
        }),
      );

      test(
        'sets type list correctly (multiple annotations)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              dartFileWithAnnotatedTopLevelFunctionWithEmptyArgMulti,
            );

          // Act
          dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
            property: 'myArg',
            annotation: 'MyAnnotation',
            functionName: 'foo',
            value: ['A', 'B', 'C'],
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithAnnotatedTopLevelFunctionMulti,
          );
        }),
      );

      test(
        'sets type list correctly when some types already exist (multiple annotations)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(dartFileWithAnnotatedTopLevelFunctionMulti);

          // Act
          dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
            property: 'myArg',
            annotation: 'MyAnnotation',
            functionName: 'foo',
            value: ['A', 'B', 'C', 'D'],
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithAnnotatedTopLevelFunctionMoreMulti,
          );
        }),
      );

      test(
        'sets type list correctly when some types and other args already exist (multiple annotations)',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
                dartFileWithAnnotatedTopLevelFunctionMultipleArgsEmpty);

          // Act
          dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
            property: 'myArg',
            annotation: 'MyAnnotation',
            functionName: 'foo',
            value: ['A', 'B', 'C'],
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithAnnotatedTopLevelFunctionMultipleArgsMore,
          );
        }),
      );

      test(
        'sets empty type list correctly',
        withTempDir(() {
          // Arrange
          final dartFile = _getDartFile();
          final file = File(dartFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              dartFileWithAnnotatedTopLevelFunction,
            );

          // Act
          dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
            property: 'myArg',
            annotation: 'MyAnnotation',
            functionName: 'foo',
            value: [],
          );

          // Assert
          expect(
            file.readAsStringSync(),
            dartFileWithAnnotatedTopLevelFunctionWithEmptyArg,
          );
        }),
      );
    });
  });
}
