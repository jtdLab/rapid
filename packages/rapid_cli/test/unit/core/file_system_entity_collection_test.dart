// TODO this file exists only for coverage reasons and should not be needed in final release

import 'dart:io' as io;

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/file_system_entity.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:test/test.dart';

import '../common.dart';

class _FileSystemEntityCollection extends FileSystemEntityCollection with Mock {
  _FileSystemEntityCollection(super.fileSystemEnties);
}

_FileSystemEntityCollection _getFileSystemEntityCollection(
  List<FileSystemEntity> fileSystemEnties,
) {
  return _FileSystemEntityCollection(fileSystemEnties);
}

void main() {
  group('FileSystemEntity', () {
    group('.existsAny()', () {
      test(
        'returns true when any of the related file system entities exists',
        withTempDir(() {
          // Arrange
          final directory1 = Directory(path: 'foo');
          final directory2 = Directory(path: 'bar');
          final fileSystemEntity = _getFileSystemEntityCollection([
            directory1,
            directory2,
          ]);
          io.Directory(directory1.path).createSync(recursive: true);

          // Assert
          expect(fileSystemEntity.existsAny(), true);
        }),
      );

      test(
        'returns false when none of the related file system entities exists',
        withTempDir(() {
          // Arrange
          final directory1 = Directory(path: 'foo');
          final directory2 = Directory(path: 'bar');
          final fileSystemEntity = _getFileSystemEntityCollection([
            directory1,
            directory2,
          ]);

          // Assert
          expect(fileSystemEntity.existsAny(), false);
        }),
      );
    });
  });
}
