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

const emptyFile = '';

const fileWithSingleMethod = '''
String aaa() {
  print(1);
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

    group('addMethod', () {
      test('adds top level method correctly', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithMethods);

        // Act
        dartFile.addMethod(
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

      test('adds member method correctly', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithMethods);

        // Act
        dartFile.addMethod(
          Method(
            (m) => m
              ..returns = refer('String')
              ..name = 'aaa'
              ..body = Code('print(1);'),
          ),
          parent: 'Foo',
        );

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithAdditionalMemberMethod);
      });

      test('adds member method correctly when file is empty', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(emptyFile);

        // Act
        dartFile.addMethod(
          Method(
            (m) => m
              ..returns = refer('String')
              ..name = 'aaa'
              ..body = Code('print(1);'),
          ),
        );

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, fileWithSingleMethod);
      });

      test('throws when parent does not exist', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithMethods);

        // Act + Assert
        expect(
          () => dartFile.addMethod(
            Method((m) => m..name = 'aaa'),
            parent: 'Baz',
          ),
          throwsA(isA<ScopeNotFound>()),
        );
        // TODO error type
      });

      test('throws when method already exists', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithMethods);

        // Act + Assert
        expect(
          () => dartFile.addMethod(
            Method((m) => m..name = 'bbb'),
          ),
          throwsA(isA<MethodAlreadyExists>()),
        );
        // TODO error type
      });
    });

    group('insertCode', () {
      // TODO
    });

    group('removeCode', () {
      // TODO
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

    group('removeMethod', () {
      test('removes top level method correctly', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithAdditionalTopLevelMethod);

        // Act
        dartFile.removeMethod('aaa');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithMethods);
      });

      test('removes member method correctly', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithAdditionalMemberMethod);

        // Act
        dartFile.removeMethod('aaa', parent: 'Foo');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithMethods);
      });

      test('does nothing when top level method does not exist', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithMethods);

        // Act
        dartFile.removeMethod('zzz');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithMethods);
      });

      test('does nothing when member method does not exist', () {
        // Arrange
        final file = File(dartFile.path);
        file.writeAsStringSync(dartFileWithMethods);

        // Act
        dartFile.removeMethod('zzz', parent: 'Foo');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, dartFileWithMethods);
      });
    });

    group('setAnnotationProperty', () {
      // TODO
    });
  });
}
