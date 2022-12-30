import 'package:rapid_cli/src/core/yaml_file.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const yamlFileWith2ImportsPerType = '''
import 'dart:aaa';
import 'dart:ccc' as c;

import 'package:aaa/aaa.dart';
import 'package:ccc/ccc.dart';

import 'aaa.dart';
import 'ccc.dart';

void main() {}
''';

const yamlFileWithAdditionalDartImport = '''
import 'dart:aaa';
import 'dart:bbb';
import 'dart:ccc' as c;

import 'package:aaa/aaa.dart';
import 'package:ccc/ccc.dart';

import 'aaa.dart';
import 'ccc.dart';

void main() {}
''';

const yamlFileWithAdditionalPackageImport = '''
import 'dart:aaa';
import 'dart:ccc' as c;

import 'package:aaa/aaa.dart';
import 'package:bbb/bbb.dart';
import 'package:ccc/ccc.dart';

import 'aaa.dart';
import 'ccc.dart';

void main() {}
''';

const yamlFileWithAdditionalRelativeImport = '''
import 'dart:aaa';
import 'dart:ccc' as c;

import 'package:aaa/aaa.dart';
import 'package:ccc/ccc.dart';

import 'aaa.dart';
import 'bbb.dart';
import 'ccc.dart';

void main() {}
''';

const yamlFileWithAdditionalAliasImport = '''
import 'dart:aaa';
import 'dart:ccc' as c;

import 'package:aaa/aaa.dart';
import 'package:bbb/bbb.dart' as b;
import 'package:ccc/ccc.dart';

import 'aaa.dart';
import 'ccc.dart';

void main() {}
''';

const yamlFileWithMethods = '''
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

const yamlFileWithAdditionalTopLevelMethod = '''
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

const yamlFileWithAdditionalMemberMethod = '''
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

void main() {
  group('YamlFile', () {
    final cwd = Directory.current;

    late YamlFile yamlFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

      yamlFile = YamlFile(name: 'foo');
      File(yamlFile.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(yamlFile.path, 'foo.yaml');
      });
    });

    group('readValue', () {
      // TODO
    });

    group('removeValue', () {
      // TODO
    });

    group('setValue', () {
      // TODO
    });
  });
}
