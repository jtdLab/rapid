import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

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

const fileWithTopLevelFunctionInBodySyntax = '''
void foo() {
  kuku();
  bar();
  boz();
  bar();
}
''';

const fileWithTopLevelFunctionInBodySyntaxWithParam = '''
void foo() {
  kuku();
  bar(
    z: 88,
  );
  boz();
  bar();
}
''';

const fileWithTopLevelFunctionInBodySyntaxWithParamAndIndex = '''
void foo() {
  kuku();
  bar();
  boz();
  bar(
    z: 88,
  );
}
''';

void main() {
  group('DartFile', () {
    final cwd = Directory.current;

    late DartFile dartFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      dartFile = DartFile(name: 'foo');
      File(dartFile.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(dartFile.path, 'foo.dart');
      });
    });

    group('addImport', () {
      test('adds dart import correctly', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWith2ImportsPerType);

        // Act
        dartFile.addImport('dart:bbb');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithAdditionalDartImport);
      });

      test('adds package import correctly', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWith2ImportsPerType);

        // Act
        dartFile.addImport('package:bbb/bbb.dart');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithAdditionalPackageImport);
      });

      test('adds relative import correctly', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWith2ImportsPerType);

        // Act
        dartFile.addImport('bbb.dart');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithAdditionalRelativeImport);
      });

      test('adds import with alias correctly', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWith2ImportsPerType);

        // Act
        dartFile.addImport('package:bbb/bbb.dart', alias: 'b');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithAdditionalAliasImport);
      });

      test('does nothing when import already exists', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWith2ImportsPerType);

        // Act
        dartFile.addImport('package:ccc/ccc.dart');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWith2ImportsPerType);
      });
    });

    group('addNamedParamToMethodCallInTopLevelFunctionBody', () {
      test(
          'adds named param correctly to referenced function call (arrow syntax)',
          () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithTopLevelFunctionInArrowSyntax);

        // Act
        dartFile.addNamedParamToMethodCallInTopLevelFunctionBody(
          paramName: 'a',
          paramValue: '\'3\'',
          functionName: 'foo',
          functionToCallName: 'bar',
        );

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithTopLevelFunctionInArrowSyntaxWithParam);
      });

      test(
          'adds named param correctly to referenced function call (body syntax)',
          () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(fileWithTopLevelFunctionInBodySyntax);

        // Act
        dartFile.addNamedParamToMethodCallInTopLevelFunctionBody(
          paramName: 'z',
          paramValue: '88',
          functionName: 'foo',
          functionToCallName: 'bar',
        );

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, fileWithTopLevelFunctionInBodySyntaxWithParam);
      });

      test(
          'adds named param correctly to referenced function call when index is not 0 (body syntax)',
          () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(fileWithTopLevelFunctionInBodySyntax);

        // Act
        dartFile.addNamedParamToMethodCallInTopLevelFunctionBody(
          paramName: 'z',
          paramValue: '88',
          functionName: 'foo',
          functionToCallName: 'bar',
          index: 1,
        );

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, fileWithTopLevelFunctionInBodySyntaxWithParamAndIndex);
      });

      test('does nothing when param already exists (arrow syntax)', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(
            dartFileWithTopLevelFunctionInArrowSyntaxWithParam);

        // Act
        dartFile.addNamedParamToMethodCallInTopLevelFunctionBody(
          paramName: 'a',
          paramValue: '\'33\'',
          functionName: 'foo',
          functionToCallName: 'bar',
        );

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithTopLevelFunctionInArrowSyntaxWithParam);
      });

      test('does nothing when param already exists (body syntax)', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(fileWithTopLevelFunctionInBodySyntaxWithParam);

        // Act
        dartFile.addNamedParamToMethodCallInTopLevelFunctionBody(
          paramName: 'z',
          paramValue: '100',
          functionName: 'foo',
          functionToCallName: 'bar',
        );

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, fileWithTopLevelFunctionInBodySyntaxWithParam);
      });
    });

    group('addTopLevelFunction', () {
      test('adds top level function correctly', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithMethods);

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
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithAdditionalTopLevelMethod);
      });

      test('adds top level function correctly when file is empty', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(emptyDartFile);

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
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithSingleMethod);
      });

      test(
          'does nothing when top level function with given name already exists',
          () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithMethods);

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
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithMethods);
      });
    });

    group('readAnnotationParamOfTopLevelFunction', () {
      // TODO impl
    });

    group('removeImport', () {
      test('removes import correctly', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithAdditionalDartImport);

        // Act
        dartFile.removeImport('dart:bbb');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWith2ImportsPerType);
      });

      test('removes import with alias correctly', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithAdditionalAliasImport);

        // Act
        dartFile.removeImport('package:bbb/bbb.dart');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWith2ImportsPerType);
      });

      test('does nothing when import does not exist', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWith2ImportsPerType);

        // Act
        dartFile.removeImport('dart:zzz');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWith2ImportsPerType);
      });
    });

    group('removeNamedParamFromMethodCall', () {});

    group('removeNamedParamFromMethodCallInTopLevelFunctionBody', () {
      test(
          'removes named param correctly from referenced function call (arrow syntax)',
          () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(
          dartFileWithTopLevelFunctionInArrowSyntaxWithParam,
        );

        // Act
        dartFile.removeNamedParamFromMethodCallInTopLevelFunctionBody(
          paramName: 'a',
          functionName: 'foo',
          functionToCallName: 'bar',
        );

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithTopLevelFunctionInArrowSyntax);
      });

      test(
          'removes named param correctly from referenced function call (body syntax)',
          () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(fileWithTopLevelFunctionInBodySyntaxWithParam);

        // Act
        dartFile.removeNamedParamFromMethodCallInTopLevelFunctionBody(
          paramName: 'z',
          functionName: 'foo',
          functionToCallName: 'bar',
        );

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, fileWithTopLevelFunctionInBodySyntax);
      });

      test(
          'remove named param correctly to referenced function call when index is not 0 (body syntax)',
          () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(
            fileWithTopLevelFunctionInBodySyntaxWithParamAndIndex);

        // Act
        dartFile.removeNamedParamFromMethodCallInTopLevelFunctionBody(
          paramName: 'z',
          functionName: 'foo',
          functionToCallName: 'bar',
          index: 1,
        );

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, fileWithTopLevelFunctionInBodySyntax);
      });

      test('does nothing when param does not exists (arrow syntax)', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithTopLevelFunctionInArrowSyntax);

        // Act
        dartFile.removeNamedParamFromMethodCallInTopLevelFunctionBody(
          paramName: 'a',
          functionName: 'foo',
          functionToCallName: 'bar',
        );

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithTopLevelFunctionInArrowSyntax);
      });

      test('does nothing when param does not exists (body syntax)', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(fileWithTopLevelFunctionInBodySyntax);

        // Act
        dartFile.removeNamedParamFromMethodCallInTopLevelFunctionBody(
          paramName: 'z',
          functionName: 'foo',
          functionToCallName: 'bar',
        );

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, fileWithTopLevelFunctionInBodySyntax);
      });
    });

    group('removeTopLevelFunction', () {
      test('removes top level function correctly', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithAdditionalTopLevelMethod);

        // Act
        dartFile.removeTopLevelFunction('aaa');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithMethods);
      });

      test('removes top level function correctly (2)', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithMethods);

        // Act
        dartFile.removeTopLevelFunction('bbb');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithClassesOnly);
      });

      test('does nothing when top level function does not exist', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithMethods);

        // Act
        dartFile.removeTopLevelFunction('zzz');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithMethods);
      });

      test('does nothing when file is empty', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(emptyDartFile);

        // Act
        dartFile.removeTopLevelFunction('zzz');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, emptyDartFile);
      });
    });

    group('setAnnotationParamOfTopLevelFunction', () {
      // TODO impl
    });
  });
}
