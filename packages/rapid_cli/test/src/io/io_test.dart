import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/io/io.dart';
import 'package:rapid_cli/src/utils.dart';
import 'package:test/test.dart';

import '../mock_env.dart';
import '../mocks.dart';

class _FileSystemEntityCollection extends FileSystemEntityCollection {
  _FileSystemEntityCollection({required this.entities});

  @override
  final Iterable<FileSystemEntity> entities;
}

class _DartPackage extends DartPackage {
  _DartPackage(super.path);
}

void main() {
  setUpAll(registerFallbackValues);

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
    late Directory directory;
    late MockIODirectory ioDirectory;

    setUp(() {
      ioDirectory = MockIODirectory();

      Directory.directoryOverrides = ioDirectory;

      directory = Directory('path');
    });

    tearDown(() {
      Directory.directoryOverrides = null;
    });

    test('absolute', () {
      when(() => ioDirectory.absolute)
          .thenReturn(FakeIODirectory(path: 'absolute_path'));

      final absolute = directory.absolute;

      verify(() => ioDirectory.absolute).called(1);
      expect(absolute.path, 'absolute_path');
    });

    test('create', () async {
      when(
        () => ioDirectory.create(
          recursive: any(named: 'recursive'),
        ),
      ).thenAnswer((_) async => FakeIODirectory(path: 'created_path'));

      final createdDirectory = await directory.create(recursive: true);

      verify(() => ioDirectory.create(recursive: true)).called(1);
      expect(createdDirectory.path, 'created_path');
    });

    test('createSync', () {
      directory.createSync(recursive: true);

      verify(() => ioDirectory.createSync(recursive: true)).called(1);
    });

    test('createTemp', () async {
      when(
        () => ioDirectory.createTemp(any()),
      ).thenAnswer((_) async => FakeIODirectory(path: 'temp_path'));

      final tempDirectory = await directory.createTemp('temp_path');

      verify(() => ioDirectory.createTemp('temp_path')).called(1);
      expect(tempDirectory.path, 'temp_path');
    });

    test('createTempSync', () {
      when(
        () => ioDirectory.createTempSync(any()),
      ).thenReturn(FakeIODirectory(path: 'temp_path'));

      final tempDirectory = directory.createTempSync('temp_path');

      verify(() => ioDirectory.createTempSync('temp_path')).called(1);
      expect(tempDirectory.path, 'temp_path');
    });

    test('delete', () async {
      when(
        () => ioDirectory.delete(
          recursive: any(named: 'recursive'),
        ),
      ).thenAnswer((_) async => FakeIODirectory(path: 'deleted_path'));

      final deletedEntity = await directory.delete(recursive: true);

      verify(() => ioDirectory.delete(recursive: true)).called(1);
      expect(deletedEntity.path, 'deleted_path');
    });

    test('deleteSync', () {
      ioDirectory.deleteSync(recursive: true);

      verify(() => ioDirectory.deleteSync(recursive: true)).called(1);
    });

    test('exists', () async {
      when(() => ioDirectory.exists()).thenAnswer((_) async => true);

      final exists = await directory.exists();

      verify(() => ioDirectory.exists()).called(1);
      expect(exists, true);
    });

    test('existsSync', () {
      when(() => ioDirectory.existsSync()).thenReturn(true);

      final exists = directory.existsSync();

      verify(() => ioDirectory.existsSync()).called(1);
      expect(exists, true);
    });

    test('isAbsolute', () {
      when(() => ioDirectory.isAbsolute).thenReturn(true);

      final isAbsolute = directory.isAbsolute;

      verify(() => ioDirectory.isAbsolute).called(1);
      expect(isAbsolute, true);
    });

    test('list', () async {
      when(
        () => ioDirectory.list(
          recursive: any(named: 'recursive'),
          followLinks: any(named: 'followLinks'),
        ),
      ).thenAnswer(
        (_) => Stream<FileSystemEntity>.fromIterable([
          FakeIOFile(path: 'path_1'),
          FakeIODirectory(path: 'path_2'),
        ]),
      );

      final stream = directory.list(recursive: true);

      verify(
        () => ioDirectory.list(recursive: true),
      ).called(1);
      expect(
        await stream.first,
        isA<File>().having((f) => f.path, 'path', 'path_1'),
      );
      expect(
        await stream.last,
        isA<Directory>().having((f) => f.path, 'path', 'path_2'),
      );
    });

    test('listSync', () {
      when(
        () => ioDirectory.listSync(
          recursive: any(named: 'recursive'),
          followLinks: any(named: 'followLinks'),
        ),
      ).thenAnswer(
        (_) => [
          FakeIOFile(path: 'path_1'),
          FakeIODirectory(path: 'path_2'),
        ],
      );

      final list = directory.listSync(recursive: true);

      verify(
        () => ioDirectory.listSync(recursive: true),
      ).called(1);
      expect(list.first, isA<File>().having((f) => f.path, 'path', 'path_1'));
      expect(
        list.last,
        isA<Directory>().having((f) => f.path, 'path', 'path_2'),
      );
    });

    test('parent', () {
      when(() => ioDirectory.parent)
          .thenReturn(FakeIODirectory(path: 'parent_path'));

      final parentDirectory = directory.parent;

      verify(() => ioDirectory.parent).called(1);
      expect(parentDirectory.path, 'parent_path');
    });

    test('path', () {
      when(() => ioDirectory.path).thenReturn('path');

      final path = directory.path;

      verify(() => ioDirectory.path).called(1);
      expect(path, 'path');
    });

    test('rename', () async {
      when(() => ioDirectory.rename(any())).thenAnswer(
        (_) async => FakeIODirectory(path: 'new_path'),
      );

      final renamedFile = await directory.rename('new_path');

      verify(() => ioDirectory.rename('new_path')).called(1);
      expect(renamedFile.path, 'new_path');
    });

    test('renameSync', () {
      when(() => ioDirectory.renameSync(any())).thenReturn(
        FakeIODirectory(path: 'new_path'),
      );

      final renamedFile = directory.renameSync('new_path');

      verify(() => ioDirectory.renameSync('new_path')).called(1);
      expect(renamedFile.path, 'new_path');
    });

    test('resolveSymbolicLinks', () async {
      when(() => ioDirectory.resolveSymbolicLinks())
          .thenAnswer((_) async => 'resolved_path');

      final result = await directory.resolveSymbolicLinks();

      verify(() => ioDirectory.resolveSymbolicLinks()).called(1);
      expect(result, 'resolved_path');
    });

    test('resolveSymbolicLinksSync', () {
      when(() => ioDirectory.resolveSymbolicLinksSync())
          .thenReturn('resolved_path');

      final result = directory.resolveSymbolicLinksSync();

      verify(() => ioDirectory.resolveSymbolicLinksSync()).called(1);
      expect(result, 'resolved_path');
    });

    test('stat', () async {
      final mockFileStat = MockFileStat();
      when(() => ioDirectory.stat()).thenAnswer((_) async => mockFileStat);

      final directoryStat = await directory.stat();

      verify(() => ioDirectory.stat()).called(1);
      expect(directoryStat, mockFileStat);
    });

    test('statSync', () {
      final mockFileStat = MockFileStat();
      when(() => ioDirectory.statSync()).thenReturn(mockFileStat);

      final directoryStat = directory.statSync();

      verify(() => ioDirectory.statSync()).called(1);
      expect(directoryStat, mockFileStat);
    });

    test('uri', () {
      final mockUri = Uri.parse('directory:///path/to/directory');
      when(() => ioDirectory.uri).thenReturn(mockUri);

      final uri = directory.uri;

      verify(() => ioDirectory.uri).called(1);
      expect(uri, mockUri);
    });

    test('watch', () {
      const mockStream = Stream<FileSystemEvent>.empty();
      when(
        () => ioDirectory.watch(
          events: any(named: 'events'),
          recursive: any(named: 'recursive'),
        ),
      ).thenAnswer((_) => mockStream);

      final stream = directory.watch(recursive: true);

      verify(
        () => ioDirectory.watch(recursive: true),
      ).called(1);
      expect(stream, mockStream);
    });
  });

  group('File', () {
    late File file;
    late MockIOFile ioFile;

    setUp(() {
      ioFile = MockIOFile();
      File.fileOverrides = ioFile;

      file = File('path');
    });

    tearDown(() {
      File.fileOverrides = null;
    });

    test('absolute', () {
      when(() => ioFile.absolute).thenReturn(FakeIOFile(path: 'absolute_path'));

      final absolute = file.absolute;

      verify(() => ioFile.absolute).called(1);
      expect(absolute.path, 'absolute_path');
    });

    test('copy', () async {
      when(() => ioFile.copy(any()))
          .thenAnswer((_) async => FakeIOFile(path: 'new_path'));

      final newFile = await file.copy('new_path');

      verify(() => ioFile.copy('new_path')).called(1);
      expect(newFile.path, 'new_path');
    });

    test('copySync', () {
      when(() => ioFile.copySync(any()))
          .thenReturn(FakeIOFile(path: 'new_path'));

      final newFile = file.copySync('new_path');

      verify(() => ioFile.copySync('new_path')).called(1);
      expect(newFile.path, 'new_path');
    });

    test('create', () async {
      when(
        () => ioFile.create(
          recursive: any(named: 'recursive'),
          exclusive: any(named: 'exclusive'),
        ),
      ).thenAnswer((_) async => FakeIOFile(path: 'created_path'));

      final createdFile = await file.create(recursive: true);

      verify(() => ioFile.create(recursive: true)).called(1);
      expect(createdFile.path, 'created_path');
    });

    test('createSync', () {
      file.createSync(recursive: true);

      verify(() => ioFile.createSync(recursive: true)).called(1);
    });

    test('delete', () async {
      when(
        () => ioFile.delete(
          recursive: any(named: 'recursive'),
        ),
      ).thenAnswer((_) async => FakeIOFile(path: 'deleted_path'));

      final deletedEntity = await file.delete(recursive: true);

      verify(() => ioFile.delete(recursive: true)).called(1);
      expect(deletedEntity.path, 'deleted_path');
    });

    test('deleteSync', () {
      file.deleteSync(recursive: true);

      verify(() => ioFile.deleteSync(recursive: true)).called(1);
    });

    test('exists', () async {
      when(() => ioFile.exists()).thenAnswer((_) async => true);

      final exists = await file.exists();

      verify(() => ioFile.exists()).called(1);
      expect(exists, true);
    });

    test('existsSync', () {
      when(() => ioFile.existsSync()).thenReturn(true);

      final exists = file.existsSync();

      verify(() => ioFile.existsSync()).called(1);
      expect(exists, true);
    });

    test('isAbsolute', () {
      when(() => ioFile.isAbsolute).thenReturn(true);

      final isAbsolute = file.isAbsolute;

      verify(() => ioFile.isAbsolute).called(1);
      expect(isAbsolute, true);
    });

    test('lastAccessed', () async {
      final lastAccessedDateTime = DateTime(2023, 8, 3, 12);
      when(() => ioFile.lastAccessed())
          .thenAnswer((_) async => lastAccessedDateTime);

      final lastAccessed = await file.lastAccessed();

      verify(() => ioFile.lastAccessed()).called(1);
      expect(lastAccessed, equals(lastAccessedDateTime));
    });

    test('lastAccessedSync', () {
      final lastAccessedDateTime = DateTime(2023, 8, 3, 12);
      when(() => ioFile.lastAccessedSync()).thenReturn(lastAccessedDateTime);

      final lastAccessed = file.lastAccessedSync();

      verify(() => ioFile.lastAccessedSync()).called(1);
      expect(lastAccessed, equals(lastAccessedDateTime));
    });

    test('lastModified', () async {
      final lastModifiedDateTime = DateTime(2023, 8, 2, 15, 30);
      when(() => ioFile.lastModified())
          .thenAnswer((_) async => lastModifiedDateTime);

      final lastModified = await file.lastModified();

      verify(() => ioFile.lastModified()).called(1);
      expect(lastModified, equals(lastModifiedDateTime));
    });

    test('lastModifiedSync', () {
      final lastModifiedDateTime = DateTime(2023, 8, 2, 15, 30);
      when(() => ioFile.lastModifiedSync()).thenReturn(lastModifiedDateTime);

      final lastModified = file.lastModifiedSync();

      verify(() => ioFile.lastModifiedSync()).called(1);
      expect(lastModified, equals(lastModifiedDateTime));
    });

    test('length', () async {
      const fileLength = 1024;
      when(() => ioFile.length()).thenAnswer((_) async => fileLength);

      final length = await file.length();

      verify(() => ioFile.length()).called(1);
      expect(length, equals(fileLength));
    });

    test('lengthSync', () {
      const fileLength = 1024;
      when(() => ioFile.lengthSync()).thenReturn(fileLength);

      final length = file.lengthSync();

      verify(() => ioFile.lengthSync()).called(1);
      expect(length, equals(fileLength));
    });

    test('open', () async {
      final mockRandomAccessFile = MockRandomAccessFile();
      when(() => ioFile.open(mode: any(named: 'mode')))
          .thenAnswer((_) async => mockRandomAccessFile);

      final openedFile = await file.open(mode: FileMode.append);

      verify(() => ioFile.open(mode: FileMode.append)).called(1);
      expect(openedFile, equals(mockRandomAccessFile));
    });

    test('openRead', () {
      const mockStream = Stream<List<int>>.empty();
      when(() => ioFile.openRead(any(), any())).thenAnswer((_) => mockStream);

      final stream = file.openRead();

      verify(() => ioFile.openRead(any(), any())).called(1);
      expect(stream, equals(mockStream));
    });

    test('openSync', () {
      final mockRandomAccessFile = MockRandomAccessFile();
      when(() => ioFile.openSync(mode: any(named: 'mode')))
          .thenReturn(mockRandomAccessFile);

      final openedFile = file.openSync(mode: FileMode.write);

      verify(() => ioFile.openSync(mode: FileMode.write)).called(1);
      expect(openedFile, equals(mockRandomAccessFile));
    });

    test('openWrite', () {
      final mockIOSink = MockIOSink();
      when(
        () => ioFile.openWrite(
          mode: any(named: 'mode'),
          encoding: any(named: 'encoding'),
        ),
      ).thenReturn(mockIOSink);

      final sink = file.openWrite(mode: FileMode.append);

      verify(() => ioFile.openWrite(mode: FileMode.append)).called(1);
      expect(sink, equals(mockIOSink));
    });

    test('parent', () {
      when(() => ioFile.parent)
          .thenReturn(FakeIODirectory(path: 'parent_path'));

      final parentDirectory = file.parent;

      verify(() => ioFile.parent).called(1);
      expect(parentDirectory.path, 'parent_path');
    });

    test('path', () {
      when(() => ioFile.path).thenReturn('path');

      final path = file.path;

      verify(() => ioFile.path).called(1);
      expect(path, 'path');
    });

    test('readAsBytes', () async {
      when(() => ioFile.readAsBytes())
          .thenAnswer((_) async => Uint8List.fromList([65, 66, 67]));

      final bytes = await file.readAsBytes();

      verify(() => ioFile.readAsBytes()).called(1);
      expect(bytes, Uint8List.fromList([65, 66, 67]));
    });

    test('readAsBytesSync', () {
      when(() => ioFile.readAsBytesSync())
          .thenReturn(Uint8List.fromList([65, 66, 67]));

      final bytes = file.readAsBytesSync();

      verify(() => ioFile.readAsBytesSync()).called(1);
      expect(bytes, Uint8List.fromList([65, 66, 67]));
    });

    test('readAsLines', () async {
      when(() => ioFile.readAsLines(encoding: any(named: 'encoding')))
          .thenAnswer((_) async => ['Line 1', 'Line 2', 'Line 3']);

      final lines = await file.readAsLines();

      verify(() => ioFile.readAsLines()).called(1);
      expect(lines, ['Line 1', 'Line 2', 'Line 3']);
    });

    test('readAsLinesSync', () {
      when(() => ioFile.readAsLinesSync())
          .thenReturn(['Line 1', 'Line 2', 'Line 3']);

      final lines = file.readAsLinesSync();

      verify(() => ioFile.readAsLinesSync()).called(1);
      expect(lines, ['Line 1', 'Line 2', 'Line 3']);
    });

    test('readAsString', () async {
      when(() => ioFile.readAsString(encoding: any(named: 'encoding')))
          .thenAnswer((_) async => 'Hello, world!');

      final result = await file.readAsString();

      verify(() => ioFile.readAsString()).called(1);
      expect(result, 'Hello, world!');
    });

    test('readAsStringSync', () {
      when(() => ioFile.readAsStringSync(encoding: any(named: 'encoding')))
          .thenReturn('Hello, world!');

      final result = file.readAsStringSync();

      verify(() => ioFile.readAsStringSync()).called(1);
      expect(result, 'Hello, world!');
    });

    test('rename', () async {
      when(() => ioFile.rename(any())).thenAnswer(
        (_) async => FakeIOFile(path: 'new_path'),
      );

      final renamedFile = await file.rename('new_path');

      verify(() => ioFile.rename('new_path')).called(1);
      expect(renamedFile.path, 'new_path');
    });

    test('renameSync', () {
      when(() => ioFile.renameSync(any())).thenReturn(
        FakeIOFile(path: 'new_path'),
      );

      final renamedFile = file.renameSync('new_path');

      verify(() => ioFile.renameSync('new_path')).called(1);
      expect(renamedFile.path, 'new_path');
    });

    test('resolveSymbolicLinks', () async {
      when(() => ioFile.resolveSymbolicLinks())
          .thenAnswer((_) async => 'resolved_path');

      final result = await file.resolveSymbolicLinks();

      verify(() => ioFile.resolveSymbolicLinks()).called(1);
      expect(result, 'resolved_path');
    });

    test('resolveSymbolicLinksSync', () {
      when(() => ioFile.resolveSymbolicLinksSync()).thenReturn('resolved_path');

      final result = file.resolveSymbolicLinksSync();

      verify(() => ioFile.resolveSymbolicLinksSync()).called(1);
      expect(result, 'resolved_path');
    });

    test('setLastAccessed', () async {
      final lastAccessed = DateTime(2023, 8, 3, 12);
      when(() => ioFile.setLastAccessed(any())).thenAnswer((_) async => true);

      final result = await file.setLastAccessed(lastAccessed);

      verify(() => ioFile.setLastAccessed(lastAccessed)).called(1);
      expect(result, true);
    });

    test('setLastAccessedSync', () {
      final lastAccessed = DateTime(2023, 8, 3, 12);
      file.setLastAccessedSync(lastAccessed);

      verify(() => ioFile.setLastAccessedSync(lastAccessed)).called(1);
    });

    test('setLastModified', () async {
      final lastModified = DateTime(2023, 8, 2, 15, 30);
      when(() => ioFile.setLastModified(any())).thenAnswer((_) async => true);

      final result = await file.setLastModified(lastModified);

      verify(() => ioFile.setLastModified(lastModified)).called(1);
      expect(result, true);
    });

    test('setLastModifiedSync', () {
      final lastModified = DateTime(2023, 8, 2, 15, 30);

      file.setLastModifiedSync(lastModified);

      verify(() => ioFile.setLastModifiedSync(lastModified)).called(1);
    });

    test('stat', () async {
      final mockFileStat = MockFileStat();
      when(() => ioFile.stat()).thenAnswer((_) async => mockFileStat);

      final fileStat = await file.stat();

      verify(() => ioFile.stat()).called(1);
      expect(fileStat, mockFileStat);
    });

    test('statSync', () {
      final mockFileStat = MockFileStat();
      when(() => ioFile.statSync()).thenReturn(mockFileStat);

      final fileStat = file.statSync();

      verify(() => ioFile.statSync()).called(1);
      expect(fileStat, mockFileStat);
    });

    test('uri', () {
      final mockUri = Uri.parse('file:///path/to/file.txt');
      when(() => ioFile.uri).thenReturn(mockUri);

      final uri = file.uri;

      verify(() => ioFile.uri).called(1);
      expect(uri, mockUri);
    });

    test('watch', () {
      const mockStream = Stream<FileSystemEvent>.empty();
      when(
        () => ioFile.watch(
          events: any(named: 'events'),
          recursive: any(named: 'recursive'),
        ),
      ).thenAnswer((_) => mockStream);

      final stream =
          file.watch(events: FileSystemEvent.modify, recursive: true);

      verify(
        () => ioFile.watch(events: FileSystemEvent.modify, recursive: true),
      ).called(1);
      expect(stream, mockStream);
    });

    test('writeAsBytes', () async {
      when(
        () => ioFile.writeAsBytes(
          any(),
          mode: any(named: 'mode'),
          flush: any(named: 'flush'),
        ),
      ).thenAnswer((_) async => FakeIOFile(path: 'path'));

      final writtenFile = await file.writeAsBytes(
        [65, 66, 67],
        mode: FileMode.append,
        flush: true,
      );

      verify(
        () => ioFile
            .writeAsBytes([65, 66, 67], mode: FileMode.append, flush: true),
      ).called(1);
      expect(writtenFile.path, 'path');
    });

    test('writeAsBytesSync', () {
      file.writeAsBytesSync([65, 66, 67], mode: FileMode.append, flush: true);

      verify(
        () => ioFile
            .writeAsBytesSync([65, 66, 67], mode: FileMode.append, flush: true),
      ).called(1);
    });

    test('writeAsString', () async {
      when(
        () => ioFile.writeAsString(
          any(),
          mode: any(named: 'mode'),
          encoding: any(named: 'encoding'),
          flush: any(named: 'flush'),
        ),
      ).thenAnswer((_) async => FakeIOFile(path: 'path'));

      final writtenFile = await file.writeAsString(
        'Hello, world!',
        mode: FileMode.writeOnly,
        flush: true,
      );

      verify(
        () => ioFile.writeAsString(
          'Hello, world!',
          mode: FileMode.writeOnly,
          flush: true,
        ),
      ).called(1);
      expect(writtenFile.path, 'path');
    });

    test('writeAsStringSync', () {
      file.writeAsStringSync(
        'Hello, world!',
        mode: FileMode.writeOnly,
        flush: true,
      );

      verify(
        () => ioFile.writeAsStringSync(
          'Hello, world!',
          mode: FileMode.writeOnly,
          flush: true,
        ),
      ).called(1);
    });
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

          final value = yamlFile.read<String>('key');
          expect(value, equals('value'));
        }),
      );

      test(
        'should return null for the given key (blank)',
        withMockFs(() {
          File('foo.yaml').writeAsStringSync('key:');
          final yamlFile = YamlFile('foo.yaml');

          final value = yamlFile.read<String?>('key');
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
          expect(yamlFile.read<String>('key'), equals('updatedValue'));
        }),
      );

      test(
        'should update value for the given path (blankIfValueNull)',
        withMockFs(() {
          final file = File('foo.yaml')..writeAsStringSync('key: value');
          final yamlFile = YamlFile('foo.yaml');

          yamlFile.set(['key'], null, blankIfValueNull: true);
          expect(file.readAsStringSync(), 'key:');
          expect(yamlFile.read<String?>('key'), equals(null));
        }),
      );
    });
  });

  group('PubspecYamlFile', () {
    group('name', () {
      test(
        'returns name',
        withMockFs(() {
          File('pubspec.yaml').writeAsStringSync('name: my_project');
          final yamlFile = PubspecYamlFile('pubspec.yaml');

          final name = yamlFile.name;
          expect(name, equals('my_project'));
        }),
      );

      test(
        'throws StateError if no name present',
        withMockFs(() {
          File('pubspec.yaml').writeAsStringSync('foo: bar');
          final yamlFile = PubspecYamlFile('pubspec.yaml');

          expect(() => yamlFile.name, throwsStateError);
        }),
      );
    });

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
                "import 'dart:io';",
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
              "import 'dart:io';",
              '',
              "import 'package:flutter/material.dart';",
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
                "import 'dart:io';",
                '',
                "import 'package:flutter/material.dart';",
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
              "import 'dart:io';",
              '',
              "import 'package:flutter/material.dart';",
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
                "import 'dart:io';",
                "import 'dart:async';",
                '',
                "import 'package:aaa/aaa.dart';",
                '',
                "import 'injection.config.dart';",
                "import 'a.dart';",
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
              "import 'dart:async';",
              "import 'dart:io';",
              '',
              "import 'package:aaa/aaa.dart';",
              "import 'package:bbb/bbb.dart';",
              '',
              "import 'a.dart';",
              "import 'injection.config.dart';",
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
                "export 'dart:io';",
                '',
                "import 'b.dart';",
                "export 'package:aaa/aaa.dart';",
                "import 'dart:io';",
                "import 'dart:async';",
                "import 'a.dart';",
                "export 'dart:async';",
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
              "import 'dart:async';",
              "import 'dart:io';",
              '',
              "import 'package:bbb/bbb.dart';",
              '',
              "import 'a.dart';",
              "import 'b.dart';",
              '',
              "export 'dart:async';",
              "export 'dart:io';",
              '',
              "export 'package:aaa/aaa.dart';",
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
              "import 'package:aaa/aaa.dart';",
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
                "export 'dart:io';",
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
              "export 'dart:io';",
              '',
              "export 'package:flutter/material.dart';",
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
                "export 'dart:io';",
                '',
                "export 'package:flutter/material.dart';",
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
              "export 'dart:io';",
              '',
              "export 'package:flutter/material.dart';",
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
                "export 'dart:io';",
                "export 'dart:async';",
                '',
                "export 'package:aaa/aaa.dart';",
                '',
                "export 'injection.config.dart';",
                "export 'a.dart';",
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
              "export 'dart:async';",
              "export 'dart:io';",
              '',
              "export 'package:aaa/aaa.dart';",
              "export 'package:bbb/bbb.dart';",
              '',
              "export 'a.dart';",
              "export 'injection.config.dart';",
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
                "export 'dart:io';",
                "export 'dart:async';",
                '',
                "export 'package:aaa/aaa.dart';",
                "import 'dart:io';",
                "import 'dart:async';",
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
              "import 'dart:async';",
              "import 'dart:io';",
              '',
              "export 'dart:async';",
              "export 'dart:io';",
              '',
              "export 'package:aaa/aaa.dart';",
              "export 'package:bbb/bbb.dart';",
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
              "export 'package:aaa/aaa.dart';",
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
              "  print('Hello, World!');",
              '}',
            ]),
          );
          final dartFile = DartFile('example.dart');

          final containsStatements = dartFile.containsStatements();

          expect(containsStatements, true);
        }),
      );

      test(
        'should return true if the file contains Dart statements '
        '(enclosed within comments)',
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
        'should return false if the file does not contain Dart statements '
        '(empty)',
        withMockFs(() {
          File('example.dart').writeAsStringSync('');
          final dartFile = DartFile('example.dart');

          final containsStatements = dartFile.containsStatements();

          expect(containsStatements, false);
        }),
      );

      test(
        'should return false if the file does not contain Dart statements '
        '(line comment)',
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
        'should return false if the file does not contain Dart statements '
        '(multi line comment)',
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
        'should return false if the file does not contain Dart statements '
        '(mixed)',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              '/* This is a multi',
              '   line comment */',
              '',
              '// This is a comment',
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
              "import 'dart:io';",
              "import 'package:flutter/material.dart';",
              "import 'my_custom_package.dart';",
              '',
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
              "import 'dart:io';",
              '',
              "import 'package:flutter/material.dart';import 'my_custom_package.dart';",
              '',
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
              '  List<String> myList = [',
              "    'value1',",
              "    'value2',",
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
              "'value1'",
              "'value2'",
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
        '''should return a list of values from an annotation parameter in a class''',
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
        'should return a list of values from an annotation parameter '
        'in a top-level function',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              "@MyAnnotation(values: ['a', 'b', 'c'])",
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
              "'a'",
              "'b'",
              "'c'",
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
                "import 'dart:io';",
                '',
                "import 'package:flutter/material.dart';",
                '',
                "import 'my_custom_package.dart';",
                "import 'some_other_package.dart';",
                '',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.removeImport('package:flutter/material.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              "import 'dart:io';",
              '',
              "import 'my_custom_package.dart';",
              "import 'some_other_package.dart';",
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
                "import 'dart:io';",
                '',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.removeImport('package:flutter/material.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              "import 'dart:io';",
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
                "import 'dart:io';",
                "import 'dart:async';",
                '',
                "import 'package:bbb/bbb.dart';",
                "import 'package:aaa/aaa.dart';",
                '',
                "import 'injection.config.dart';",
                "import 'a.dart';",
                '',
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.removeImport('package:bbb/bbb.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              "import 'dart:async';",
              "import 'dart:io';",
              '',
              "import 'package:aaa/aaa.dart';",
              '',
              "import 'a.dart';",
              "import 'injection.config.dart';",
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
                "export 'dart:io';",
                '',
                "export 'package:aaa/aaa.dart';",
                "import 'dart:io';",
                "import 'dart:async';",
                "export 'dart:async';",
                '',
                "import 'package:bbb/bbb.dart';",
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.removeImport('package:bbb/bbb.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              "import 'dart:async';",
              "import 'dart:io';",
              '',
              "export 'dart:async';",
              "export 'dart:io';",
              '',
              "export 'package:aaa/aaa.dart';",
              '',
              '// some code',
              '',
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
                "export 'package:flutter/material.dart';",
                '',
                "export 'my_custom_package.dart';",
                "export 'some_other_package.dart';",
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.removeExport('package:flutter/material.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              "export 'my_custom_package.dart';",
              "export 'some_other_package.dart';",
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
                "export 'my_custom_package.dart';",
                '',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.removeExport('package:flutter/material.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              "export 'my_custom_package.dart';",
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
                "export 'dart:io';",
                "export 'dart:async';",
                '',
                "export 'package:aaa/aaa.dart';",
                '',
                "export 'injection.config.dart';",
                "export 'a.dart';",
                '',
                "export 'package:bbb/bbb.dart';",
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.removeExport('package:bbb/bbb.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              "export 'dart:async';",
              "export 'dart:io';",
              '',
              "export 'package:aaa/aaa.dart';",
              '',
              "export 'a.dart';",
              "export 'injection.config.dart';",
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
                "export 'dart:io';",
                "export 'dart:async';",
                '',
                "export 'package:bbb/bbb.dart';",
                "export 'package:aaa/aaa.dart';",
                "import 'dart:io';",
                "import 'dart:async';",
                '',
                '// some code',
              ]),
            );
          final dartFile = DartFile('example.dart');

          dartFile.removeExport('package:bbb/bbb.dart');

          final content = file.readAsStringSync();
          expect(
            content,
            multiLine([
              "import 'dart:async';",
              "import 'dart:io';",
              '',
              "export 'dart:async';",
              "export 'dart:io';",
              '',
              "export 'package:aaa/aaa.dart';",
              '',
              '// some code',
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
        'should update the value of an annotation parameter '
        'in a top-level function',
        withMockFs(() {
          File('example.dart').writeAsStringSync(
            multiLine([
              "@MyAnnotation(values: ['a', 'b', 'c'])",
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
            value: ["'x'", "'y'", "'z'"],
          );

          final content = dartFile.readAsStringSync();
          expect(
            content,
            multiLine([
              "@MyAnnotation(values: ['x','y','z',])",
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
              "@MyAnnotation(values: ['a', 'b', 'c'])",
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
              "@MyAnnotation(values: ['a', 'b', 'c'])",
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
            value: ["'x'"],
          );

          final content = dartFile.readAsStringSync();
          expect(
            content,
            multiLine([
              "@MyAnnotation(values: ['x',])",
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
            '</plist>',
          ]);
          File('file.plist').writeAsStringSync(plistContent);
          final plistFile = PlistFile('file.plist');

          final dict = plistFile.readDict();
          expect(dict, equals({'key1': 'value1', 'key2': 42}));
        }),
      );

      test(
        '''should throw PlistFileError if the root of the plist is not a dictionary''',
        withMockFs(() {
          final plistContent = multiLine([
            '<?xml version="1.0" encoding="UTF-8"?>',
            '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
            '<plist version="1.0">',
            '<array>',
            '    <string>value1</string>',
            '    <integer>42</integer>',
            '</array>',
            '</plist>',
          ]);
          File('file.plist').writeAsStringSync(plistContent);
          final plistFile = PlistFile('file.plist');

          expect(
            plistFile.readDict,
            throwsA(
              isA<PlistFileException>().having(
                (e) => e.message,
                'message',
                'Invalid Plist file: Root element in file.plist must be '
                    'a dictionary, but a non-dictionary element was found.',
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
            '</plist>',
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
            '</plist>',
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
        '''should throw PlistFileError if the root of the plist is not a dictionary''',
        withMockFs(() {
          final plistContent = multiLine([
            '<?xml version="1.0" encoding="UTF-8"?>',
            '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
            '<plist version="1.0">',
            '<array>',
            '  <string>value1</string>',
            '  <integer>42</integer>',
            '</array>',
            '</plist>',
          ]);
          File('file.plist').writeAsStringSync(plistContent);
          final plistFile = PlistFile('file.plist');

          expect(
            () => plistFile.setDict({'key': 'value'}),
            throwsA(
              isA<PlistFileException>().having(
                (e) => e.toString(),
                'toString',
                'Invalid Plist file: Root element in file.plist must be a '
                    'dictionary, but a non-dictionary element was found.',
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
