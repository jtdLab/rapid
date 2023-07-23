import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/utils.dart';
import 'package:test/test.dart';

import 'mock_fs.dart';

class _FileSystemEntityCollection extends FileSystemEntityCollection {
  _FileSystemEntityCollection({required this.entities});

  @override
  final Iterable<FileSystemEntity> entities;
}

class _DartPackage extends DartPackage {
  _DartPackage(super.path);
}

void main() {
  group('FileSystemEntityCollection', () {
    group('existAny', () {
      test(
        'should return true if any entity exists',
        withMockFs(
          () {
            final entities = [
              File('foo'),
              Directory('bar')..createSync(recursive: true),
            ];
            final collection = _FileSystemEntityCollection(entities: entities);
            expect(collection.existsAny, true);
          },
        ),
      );

      test(
        'should return false if no entity exists',
        withMockFs(
          () {
            final entities = [
              File('foo'),
              Directory('bar'),
            ];
            final collection = _FileSystemEntityCollection(entities: entities);
            expect(collection.existsAny, false);
          },
        ),
      );
    });

    group('existsAll', () {
      test(
        'should return true if all entities exist',
        withMockFs(
          () {
            final entities = [
              File('foo')..createSync(recursive: true),
              Directory('bar')..createSync(recursive: true),
            ];
            final collection = _FileSystemEntityCollection(entities: entities);
            expect(collection.existsAll, true);
          },
        ),
      );

      test(
        'should return false if any entity does not exist',
        withMockFs(
          () {
            final entities = [
              File('foo'),
              Directory('bar')..createSync(recursive: true),
            ];
            final collection = _FileSystemEntityCollection(entities: entities);
            expect(collection.existsAll, false);
          },
        ),
      );
    });

    test(
      'delete should delete existing entities recursively',
      withMockFs(
        () {
          final entities = [
            File('foo')..createSync(recursive: true),
            Directory('bar')..createSync(recursive: true),
          ];
          final collection = _FileSystemEntityCollection(entities: entities);

          collection.delete();

          for (final entity in entities) {
            expect(entity.existsSync(), false);
          }
        },
      ),
    );
  });

  group('Directory', () {
    // TODO
    /*  test(
      '.()',
      withMockFs(() {
        final ioDir = io.Directory('foo');
        final dir = Directory('foo');


      }),
    );

    test(
      'current',
      withMockFs(() {}),
    ); */
  });

  group('File', () {
    // TODO
  });

  group('DartPackage', () {
    test(
      'pubSpecFile',
      withMockFs(() {
        final dartPackage = _DartPackage('.');

        final pubspecFile = dartPackage.pubSpecFile;
        expect(pubspecFile.path, 'pubspec.yaml');
      }),
    );

    test(
      'name',
      withMockFs(() {
        File('pubspec.yaml').writeAsString('name: test_package');
        final dartPackage = _DartPackage('.');

        expect(dartPackage.packageName, 'test_package');
      }),
    );
  });

  group('YamlFile', () {
    group('read', () {
      test(
        'should return the value for the given key',
        withMockFs(() {
          File('foo.yaml').writeAsStringSync('key: value');
          final yamlFile = YamlFile('foo.yaml');

          final value = yamlFile.read('key');
          expect(value, equals('value'));
        }),
      );

      test(
        'should return null for the given key (blank)',
        withMockFs(() {
          File('foo.yaml').writeAsStringSync('key:');
          final yamlFile = YamlFile('foo.yaml');

          final value = yamlFile.read('key');
          expect(value, equals(null));
        }),
      );
    });

    group('set', () {
      test(
        'should update value for the given path',
        withMockFs(() {
          File('foo.yaml').writeAsStringSync('key: value');
          final yamlFile = YamlFile('foo.yaml');

          yamlFile.set(['key'], 'updatedValue');
          expect(yamlFile.read('key'), equals('updatedValue'));
        }),
      );

      test(
        'should update value for the given path (blankIfValueNull)',
        withMockFs(() {
          final file = File('foo.yaml')..writeAsStringSync('key: value');
          final yamlFile = YamlFile('foo.yaml');

          yamlFile.set(['key'], null, blankIfValueNull: true);
          expect(file.readAsStringSync(), 'key:');
          expect(yamlFile.read('key'), equals(null));
        }),
      );
    });
  });

  group('PubspecYamlFile', () {
    test(
      'name',
      withMockFs(() {
        File('pubspec.yaml').writeAsStringSync('name: my_project');
        final yamlFile = PubspecYamlFile('pubspec.yaml');

        final name = yamlFile.name;
        expect(name, equals('my_project'));
      }),
    );

    group('hasDependency', () {
      test(
        'should return true if the dependency is present',
        withMockFs(() {
          File('pubspec.yaml').writeAsStringSync(
            multiLine([
              'dependencies:',
              '  http: ^1.0.0',
            ]),
          );
          final yamlFile = PubspecYamlFile('pubspec.yaml');

          final hasDependency = yamlFile.hasDependency(name: 'http');
          expect(hasDependency, true);
        }),
      );

      test(
        'should return false if the dependency is not present',
        withMockFs(() {
          File('pubspec.yaml').writeAsStringSync(
            multiLine([
              'dependencies:',
              '  http: ^1.0.0',
            ]),
          );
          final yamlFile = PubspecYamlFile('pubspec.yaml');

          final hasDependency = yamlFile.hasDependency(name: 'collection');
          expect(hasDependency, false);
        }),
      );
    });

    group('setDependency', () {
      test(
        'should add dependency if it does not exist',
        withMockFs(() {
          final file = File('pubspec.yaml')
            ..writeAsStringSync(
              multiLine([
                'dependencies:',
                '  collection: ^1.0.0',
              ]),
            );
          final yamlFile = PubspecYamlFile('pubspec.yaml');

          yamlFile.setDependency(
            name: 'http',
            dependency: HostedReference(
              VersionConstraint.parse('^1.0.0'),
            ),
          );

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'dependencies:',
              '  collection: ^1.0.0',
              '  http: ^1.0.0',
              '',
            ]),
          );
        }),
      );

      test(
        'should add dev dependency if it does not exist',
        withMockFs(() {
          final file = File('pubspec.yaml')
            ..writeAsStringSync(
              multiLine([
                'dev_dependencies:',
                '  collection: ^1.0.0',
              ]),
            );
          final yamlFile = PubspecYamlFile('pubspec.yaml');

          yamlFile.setDependency(
            name: 'http',
            dependency: HostedReference(
              VersionConstraint.parse('^1.0.0'),
            ),
            dev: true,
          );

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'dev_dependencies:',
              '  collection: ^1.0.0',
              '  http: ^1.0.0',
              '',
            ]),
          );
        }),
      );

      test(
        'should add dependency if it does not exist (empty)',
        withMockFs(() {
          final file = File('pubspec.yaml')
            ..writeAsStringSync(
              multiLine([
                'dependencies:',
                '  collection: ^1.0.0',
              ]),
            );
          final yamlFile = PubspecYamlFile('pubspec.yaml');

          yamlFile.setDependency(
            name: 'http',
            dependency: HostedReference(VersionConstraint.empty),
          );

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'dependencies:',
              '  collection: ^1.0.0',
              '  http:',
              '',
            ]),
          );
        }),
      );

      test(
        'should add dev dependency if it does not exist (empty)',
        withMockFs(() {
          final file = File('pubspec.yaml')
            ..writeAsStringSync(
              multiLine([
                'dev_dependencies:',
                '  collection: ^1.0.0',
              ]),
            );
          final yamlFile = PubspecYamlFile('pubspec.yaml');

          yamlFile.setDependency(
            name: 'http',
            dependency: HostedReference(
              VersionConstraint.empty,
            ),
            dev: true,
          );

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'dev_dependencies:',
              '  collection: ^1.0.0',
              '  http:',
              '',
            ]),
          );
        }),
      );

      test(
        'should update dependency',
        withMockFs(() {
          final file = File('pubspec.yaml')
            ..writeAsStringSync(
              multiLine([
                'dependencies:',
                '  http: ^1.0.0',
              ]),
            );
          final yamlFile = PubspecYamlFile('pubspec.yaml');

          yamlFile.setDependency(
            name: 'http',
            dependency: HostedReference(
              VersionConstraint.parse('^2.0.0'),
            ),
          );

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'dependencies:',
              '  http: ^2.0.0',
            ]),
          );
        }),
      );

      test(
        'should update dev dependency',
        withMockFs(() {
          final file = File('pubspec.yaml')
            ..writeAsStringSync(
              multiLine([
                'dev_dependencies:',
                '  http: ^1.0.0',
              ]),
            );
          final yamlFile = PubspecYamlFile('pubspec.yaml');

          yamlFile.setDependency(
            name: 'http',
            dependency: HostedReference(
              VersionConstraint.parse('^2.0.0'),
            ),
            dev: true,
          );

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'dev_dependencies:',
              '  http: ^2.0.0',
            ]),
          );
        }),
      );
    });

    group('removeDependency', () {
      test(
        'should remove dependency',
        withMockFs(() {
          File('pubspec.yaml').writeAsStringSync(
            multiLine([
              'dependencies:',
              '  http: ^1.0.0',
            ]),
          );
          final yamlFile = PubspecYamlFile('pubspec.yaml');

          yamlFile.removeDependency(name: 'http');

          final content = yamlFile.readAsStringSync();
          expect(
            content,
            multiLine([
              'dependencies:',
              '  {}',
            ]),
          );
        }),
      );

      test(
        'should remove dev dependency',
        withMockFs(() {
          File('pubspec.yaml').writeAsStringSync(
            multiLine([
              'dev_dependencies:',
              '  http: ^1.0.0',
            ]),
          );
          final yamlFile = PubspecYamlFile('pubspec.yaml');

          yamlFile.removeDependency(name: 'http');

          final content = yamlFile.readAsStringSync();
          expect(
            content,
            multiLine([
              'dev_dependencies:',
              '  {}',
            ]),
          );
        }),
      );
    });
  });

  group('DartFile', () {
    group('addImport', () {
      test(
        'should add a new import if it does not exist',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'import \'dart:io\';',
                '',
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.addImport('package:flutter/material.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'import \'dart:io\';',
              '',
              'import \'package:flutter/material.dart\';',
              '',
              '// some code',
              '',
            ]),
          );
        }),
      );

      test(
        'should not add a duplicate import',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'import \'dart:io\';',
                '',
                'import \'package:flutter/material.dart\';',
                '',
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.addImport('package:flutter/material.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'import \'dart:io\';',
              '',
              'import \'package:flutter/material.dart\';',
              '',
              '// some code',
              '',
            ]),
          );
        }),
      );

      test(
        'sorts imports',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'import \'dart:io\';',
                'import \'dart:async\';',
                '',
                'import \'package:aaa/aaa.dart\';',
                '',
                'import \'injection.config.dart\';',
                'import \'a.dart\';',
                '',
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.addImport('package:bbb/bbb.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'import \'dart:async\';',
              'import \'dart:io\';',
              '',
              'import \'package:aaa/aaa.dart\';',
              'import \'package:bbb/bbb.dart\';',
              '',
              'import \'a.dart\';',
              'import \'injection.config.dart\';',
              '',
              '// some code',
              '',
            ]),
          );
        }),
      );

      test(
        'sorts imports and exports',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'export \'dart:io\';',
                '',
                'export \'package:aaa/aaa.dart\';',
                'import \'dart:io\';',
                'import \'dart:async\';',
                'export \'dart:async\';',
                '',
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.addImport('package:bbb/bbb.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'import \'dart:async\';',
              'import \'dart:io\';',
              '',
              'import \'package:bbb/bbb.dart\';',
              '',
              'export \'dart:async\';',
              'export \'dart:io\';',
              '',
              'export \'package:aaa/aaa.dart\';',
              '',
              '// some code',
              '',
            ]),
          );
        }),
      );

      test(
        'inserts import after library directive if no export exists yet',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                '// Docs',
                'library foo_bar;',
                '',
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.addImport('package:aaa/aaa.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              '// Docs',
              'library foo_bar;',
              '',
              'import \'package:aaa/aaa.dart\';',
              '',
              '// some code',
              '',
            ]),
          );
        }),
      );
    });

    group('addExport', () {
      test(
        'should add a new export if it does not exist',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'export \'dart:io\';',
                '',
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.addExport('package:flutter/material.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'export \'dart:io\';',
              '',
              'export \'package:flutter/material.dart\';',
              '',
              '// some code',
              '',
            ]),
          );
        }),
      );

      test(
        'should not add a duplicate export',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'export \'dart:io\';',
                '',
                'export \'package:flutter/material.dart\';',
                '',
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.addExport('package:flutter/material.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'export \'dart:io\';',
              '',
              'export \'package:flutter/material.dart\';',
              '',
              '// some code',
              '',
            ]),
          );
        }),
      );

      test(
        'sorts exports',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'export \'dart:io\';',
                'export \'dart:async\';',
                '',
                'export \'package:aaa/aaa.dart\';',
                '',
                'export \'injection.config.dart\';',
                'export \'a.dart\';',
                '',
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.addExport('package:bbb/bbb.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'export \'dart:async\';',
              'export \'dart:io\';',
              '',
              'export \'package:aaa/aaa.dart\';',
              'export \'package:bbb/bbb.dart\';',
              '',
              'export \'a.dart\';',
              'export \'injection.config.dart\';',
              '',
              '// some code',
              '',
            ]),
          );
        }),
      );

      test(
        'sorts exports and imports',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'export \'dart:io\';',
                'export \'dart:async\';',
                '',
                'export \'package:aaa/aaa.dart\';',
                'import \'dart:io\';',
                'import \'dart:async\';',
                '',
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.addExport('package:bbb/bbb.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'import \'dart:async\';',
              'import \'dart:io\';',
              '',
              'export \'dart:async\';',
              'export \'dart:io\';',
              '',
              'export \'package:aaa/aaa.dart\';',
              'export \'package:bbb/bbb.dart\';',
              '',
              '// some code',
              '',
            ]),
          );
        }),
      );

      test(
        'inserts export after library directive if no export exists yet',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                '// Docs',
                'library foo_bar;',
                '',
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.addExport('package:aaa/aaa.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              '// Docs',
              'library foo_bar;',
              '',
              'export \'package:aaa/aaa.dart\';',
              '',
              '// some code',
              '',
            ]),
          );
        }),
      );
    });

    group('containsStatements', () {
      test(
        'should return true if the file contains Dart statements',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              'void main() {',
              '  print(\'Hello, World!\');',
              '}',
            ]),
          );
          final dartFile = DartFile('example.dart');

          final containsStatements = dartFile.containsStatements();

          expect(containsStatements, true);
        }),
      );

      test(
        'should return true if the file contains Dart statements (enclosed within comments)',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              '/* This is a comment */ void main() {} /* This is a comment */',
            ]),
          );
          final dartFile = DartFile('example.dart');

          final containsStatements = dartFile.containsStatements();

          expect(containsStatements, true);
        }),
      );

      test(
        'should return false if the file does not contain Dart statements (empty)',
        withMockFs(() {
          File('example.dart').writeAsStringSync('');
          final dartFile = DartFile('example.dart');

          final containsStatements = dartFile.containsStatements();

          expect(containsStatements, false);
        }),
      );

      test(
        'should return false if the file does not contain Dart statements (line comment)',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              '// This is a comment',
            ]),
          );
          final dartFile = DartFile('example.dart');

          final containsStatements = dartFile.containsStatements();

          expect(containsStatements, false);
        }),
      );

      test(
        'should return false if the file does not contain Dart statements (multi line comment)',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              '/* This is a multi',
              '   line comment */',
            ]),
          );
          final dartFile = DartFile('example.dart');

          final containsStatements = dartFile.containsStatements();

          expect(containsStatements, false);
        }),
      );

      test(
        'should return false if the file does not contain Dart statements (mixed)',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              '/* This is a multi',
              '   line comment */',
              '',
              '// This is a comment'
            ]),
          );
          final dartFile = DartFile('example.dart');

          final containsStatements = dartFile.containsStatements();

          expect(containsStatements, false);
        }),
      );
    });

    group('readImports', () {
      test(
        'should return a set of imports from the file',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              'import \'dart:io\';',
              'import \'package:flutter/material.dart\';',
              'import \'my_custom_package.dart\';',
              ''
            ]),
          );
          final dartFile = DartFile('example.dart');

          final imports = dartFile.readImports();

          expect(
            imports,
            {
              'dart:io',
              'package:flutter/material.dart',
              'my_custom_package.dart',
            },
          );
        }),
      );

      test(
        'should return a set of imports from the file (unformatted)',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              'import \'dart:io\';',
              '',
              'import \'package:flutter/material.dart\';import \'my_custom_package.dart\';',
              ''
            ]),
          );
          final dartFile = DartFile('example.dart');

          final imports = dartFile.readImports();

          expect(
            imports,
            {
              'dart:io',
              'package:flutter/material.dart',
              'my_custom_package.dart',
            },
          );
        }),
      );

      test(
        'should return an empty set if no imports are found in the file',
        withMockFs(() {
          File('example.dart').writeAsStringSync('');
          final dartFile = DartFile('example.dart');

          final imports = dartFile.readImports();

          expect(imports, <String>{});
        }),
      );
    });

    group('readListVarOfClass', () {
      test(
        'should return a list of variables from a class-level list variable',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              'class MyClass {',
              '  static List<String> myList = [',
              '    \'value1\',',
              '    \'value2\',',
              '  ];',
              '}',
            ]),
          );
          final dartFile = DartFile('example.dart');

          final listVar = dartFile.readListVarOfClass(
            name: 'myList',
            parentClass: 'MyClass',
          );

          expect(
            listVar,
            [
              '\'value1\'',
              '\'value2\'',
            ],
          );
        }),
      );
    });

    group('readTopLevelListVar', () {
      test(
        'should return a list of variables from a top-level list variable',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              'List<int> myTopLevelList = [1, 2, 3];',
              'void main() {',
              '  // Code...',
              '}',
            ]),
          );
          final dartFile = DartFile('example.dart');

          final listVar = dartFile.readTopLevelListVar(name: 'myTopLevelList');

          expect(
            listVar,
            [
              '1',
              '2',
              '3',
            ],
          );
        }),
      );
    });

    group('readTypeListFromAnnotationParamOfClass', () {
      test(
        'should return a list of values from an annotation parameter in a class',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              '@MyAnnotation(values: [1, 2, 3])',
              'class MyClass {',
              '  // Class definition',
              '}',
            ]),
          );
          final dartFile = DartFile('example.dart');

          final typeList = dartFile.readTypeListFromAnnotationParamOfClass(
            property: 'values',
            annotation: 'MyAnnotation',
            className: 'MyClass',
          );

          expect(
            typeList,
            [
              '1',
              '2',
              '3',
            ],
          );
        }),
      );
    });

    group('readTypeListFromAnnotationParamOfTopLevelFunction', () {
      test(
        'should return a list of values from an annotation parameter in a top-level function',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              '@MyAnnotation(values: [\'a\', \'b\', \'c\'])',
              'void myFunction() {',
              '  // Function body',
              '}',
            ]),
          );
          final dartFile = DartFile('example.dart');

          final typeList =
              dartFile.readTypeListFromAnnotationParamOfTopLevelFunction(
            property: 'values',
            annotation: 'MyAnnotation',
            functionName: 'myFunction',
          );

          expect(
            typeList,
            [
              '\'a\'',
              '\'b\'',
              '\'c\'',
            ],
          );
        }),
      );
    });

    group('removeImport', () {
      test(
        'should remove an import from the file',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'import \'dart:io\';',
                '',
                'import \'package:flutter/material.dart\';',
                '',
                'import \'my_custom_package.dart\';',
                'import \'some_other_package.dart\';',
                '',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.removeImport('package:flutter/material.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'import \'dart:io\';',
              '',
              'import \'my_custom_package.dart\';',
              'import \'some_other_package.dart\';',
              '',
            ]),
          );
        }),
      );

      test(
        'should do nothing if the import does not exist',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'import \'dart:io\';',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.removeImport('package:flutter/material.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'import \'dart:io\';',
            ]),
          );
        }),
      );
    });

    group('removeExport', () {
      test(
        'should remove an export from the file',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'export \'package:flutter/material.dart\';',
                '',
                'export \'my_custom_package.dart\';',
                'export \'some_other_package.dart\';',
                '',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.removeExport('package:flutter/material.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'export \'my_custom_package.dart\';',
              'export \'some_other_package.dart\';',
              '',
            ]),
          );
        }),
      );

      test(
        'should do nothing if the export does not exist',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'export \'my_custom_package.dart\';',
                '',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.removeExport('package:flutter/material.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'export \'my_custom_package.dart\';',
              '',
            ]),
          );
        }),
      );
    });

    group('setTopLevelListVar', () {
      test(
        'should update the value of a top-level list variable',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                'List<int> myTopLevelList = [1, 2, 3];',
                'void main() {',
                '  // Code...',
                '}',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.setTopLevelListVar(
            name: 'myTopLevelList',
            value: ['4', '5', '6'],
          );

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              'List<int> myTopLevelList = [4,5,6,];',
              'void main() {',
              '  // Code...',
              '}',
            ]),
          );
        }),
      );
    });

    group('setTypeListOfAnnotationParamOfClass', () {
      test(
        'should update the value of an annotation parameter in a class',
        withMockFs(() {
          final file = File('example.dart')
            ..writeAsStringSync(
              multiLine([
                '@MyAnnotation(values: [1, 2, 3])',
                'class MyClass {',
                '  // Class definition',
                '}',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.setTypeListOfAnnotationParamOfClass(
            property: 'values',
            annotation: 'MyAnnotation',
            className: 'MyClass',
            value: ['4', '5', '6'],
          );

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              '@MyAnnotation(values: [4,5,6,])',
              'class MyClass {',
              '  // Class definition',
              '}',
            ]),
          );
        }),
      );
    });

    group('setTypeListOfAnnotationParamOfTopLevelFunction', () {
      test(
        'should update the value of an annotation parameter in a top-level function',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              '@MyAnnotation(values: [\'a\', \'b\', \'c\'])',
              'void myFunction() {',
              '  // Function body',
              '}',
            ]),
          );
          final dartFile = DartFile('example.dart');

          dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
            property: 'values',
            annotation: 'MyAnnotation',
            functionName: 'myFunction',
            value: ['\'x\'', '\'y\'', '\'z\''],
          );

          final content = dartFile.readAsStringSync();
          expect(
            content,
            multiLine([
              '@MyAnnotation(values: [\'x\',\'y\',\'z\',])',
              'void myFunction() {',
              '  // Function body',
              '}',
            ]),
          );
        }),
      );

      test(
        'should handle empty value list',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              '@MyAnnotation(values: [\'a\', \'b\', \'c\'])',
              'void myFunction() {',
              '  // Function body',
              '}',
            ]),
          );
          final dartFile = DartFile('example.dart');

          dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
            property: 'values',
            annotation: 'MyAnnotation',
            functionName: 'myFunction',
            value: [],
          );

          final content = dartFile.readAsStringSync();
          expect(
            content,
            multiLine([
              '@MyAnnotation(values: [])',
              'void myFunction() {',
              '  // Function body',
              '}',
            ]),
          );
        }),
      );

      test(
        'should handle single-value list',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              '@MyAnnotation(values: [\'a\', \'b\', \'c\'])',
              'void myFunction() {',
              '  // Function body',
              '}',
            ]),
          );
          final dartFile = DartFile('example.dart');

          dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
            property: 'values',
            annotation: 'MyAnnotation',
            functionName: 'myFunction',
            value: ['\'x\''],
          );

          final content = dartFile.readAsStringSync();
          expect(
            content,
            multiLine([
              '@MyAnnotation(values: [\'x\',])',
              'void myFunction() {',
              '  // Function body',
              '}',
            ]),
          );
        }),
      );
    });
  });

  group('PlistFile', () {
    group('readDict', () {
      test(
        'should return the dictionary from the plist file',
        withMockFs(() {
          final plistContent = multiLine([
            '<?xml version="1.0" encoding="UTF-8"?>',
            '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
            '<plist version="1.0">',
            '<dict>',
            '    <key>key1</key>',
            '    <string>value1</string>',
            '    <key>key2</key>',
            '    <integer>42</integer>',
            '</dict>',
            '</plist>'
          ]);
          File('file.plist').writeAsStringSync(plistContent);
          final plistFile = PlistFile('file.plist');

          final dict = plistFile.readDict();
          expect(dict, equals({'key1': 'value1', 'key2': 42}));
        }),
      );

      test(
        'should throw PlistFileError if the root of the plist is not a dictionary',
        withMockFs(() {
          final plistContent = multiLine([
            '<?xml version="1.0" encoding="UTF-8"?>',
            '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
            '<plist version="1.0">',
            '<array>',
            '    <string>value1</string>',
            '    <integer>42</integer>',
            '</array>',
            '</plist>'
          ]);
          File('file.plist').writeAsStringSync(plistContent);
          final plistFile = PlistFile('file.plist');

          expect(
            () => plistFile.readDict(),
            throwsA(
              isA<PlistFileError>().having(
                (e) => e.message,
                'message',
                'Invalid Plist file: Root element in file.plist must be a dictionary, but a non-dictionary element was found.',
              ),
            ),
          );
        }),
      );
    });

    group('setDict', () {
      test(
        'should update the plist file with the provided dictionary',
        withMockFs(() {
          final plistContent = multiLine([
            '<?xml version="1.0" encoding="UTF-8"?>',
            '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
            '<plist version="1.0">',
            '<dict>',
            '  <key>key1</key>',
            '  <string>value1</string>',
            '  <key>key2</key>',
            '  <integer>42</integer>',
            '</dict>',
            '</plist>'
          ]);
          final updatedPlistContent = multiLine([
            '<?xml version="1.0" encoding="UTF-8"?>',
            '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
            '<plist version="1.0">',
            '  <dict>',
            '    <key>key1</key>',
            '    <string>updatedValue1</string>',
            '    <key>key2</key>',
            '    <integer>99</integer>',
            '    <key>newKey</key>',
            '    <true/>',
            '  </dict>',
            '</plist>'
          ]);

          File('file.plist').writeAsStringSync(plistContent);
          final plistFile = PlistFile('file.plist');

          plistFile.setDict({
            'key1': 'updatedValue1',
            'key2': 99,
            'newKey': true,
          });

          final updatedContent = File('file.plist').readAsStringSync();
          expect(updatedContent, equals(updatedPlistContent));
        }),
      );

      test(
        'should throw PlistFileError if the root of the plist is not a dictionary',
        withMockFs(() {
          final plistContent = multiLine([
            '<?xml version="1.0" encoding="UTF-8"?>',
            '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
            '<plist version="1.0">',
            '<array>',
            '  <string>value1</string>',
            '  <integer>42</integer>',
            '</array>',
            '</plist>'
          ]);
          File('file.plist').writeAsStringSync(plistContent);
          final plistFile = PlistFile('file.plist');

          expect(
            () => plistFile.setDict({'key': 'value'}),
            throwsA(
              isA<PlistFileError>().having(
                (e) => e.message,
                'message',
                'Invalid Plist file: Root element in file.plist must be a dictionary, but a non-dictionary element was found.',
              ),
            ),
          );
        }),
      );
    });
  });

  group('ArbFile', () {
    group('setValue', () {
      test(
        'should add the new key-value pair if the key does not exist',
        withMockFs(() {
          final arbContent = multiLine([
            '{',
            '  "@@locale": "en-US",',
            '  "key1": "value1"',
            '}',
          ]);
          final updatedArbContent = multiLine([
            '{',
            '  "@@locale": "en-US",',
            '  "key1": "value1",',
            '  "key2": "value2"',
            '}',
          ]);

          File('file.arb').writeAsStringSync(arbContent);
          final arbFile = ArbFile('file.arb');

          arbFile.setValue('key2', 'value2');

          final updatedContent = File('file.arb').readAsStringSync();
          expect(updatedContent, updatedArbContent);
        }),
      );

      test(
        'should update the value for the given key',
        withMockFs(() {
          final arbContent = multiLine([
            '{',
            '  "@@locale": "en-US",',
            '  "key1": "value1",',
            '  "key2": "value2"',
            '}',
          ]);
          final updatedArbContent = multiLine([
            '{',
            '  "@@locale": "en-US",',
            '  "key1": "updatedValue1",',
            '  "key2": "value2"',
            '}',
          ]);
          File('file.arb').writeAsStringSync(arbContent);
          final arbFile = ArbFile('file.arb');

          arbFile.setValue('key1', 'updatedValue1');

          final updatedContent = File('file.arb').readAsStringSync();
          expect(updatedContent, updatedArbContent);
        }),
      );
    });
  });
}
