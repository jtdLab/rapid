import 'package:rapid_cli/src/io.dart';
import 'package:test/test.dart';

import 'mock_fs.dart';

class _FileSystemEntityCollection extends FileSystemEntityCollection {
  _FileSystemEntityCollection({required this.entities});

  @override
  final Iterable<FileSystemEntity> entities;
}

// TODO use
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
  });

  group('File', () {
    // TODO
  });

  group('DartPackage', () {
    // TODO
  });

  group('YamlFile', () {
    // TODO
  });

  group('PubspecYamlFile', () {
    // TODO
  });

  group('DartFile', () {
    // TODO
  });

  group('PlistFile', () {
    // TODO
  });

  group('ArbFile', () {
    // TODO
  });
}
