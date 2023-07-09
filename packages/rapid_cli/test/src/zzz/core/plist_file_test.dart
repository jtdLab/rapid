import 'dart:io';

import 'package:rapid_cli/src/core/plist_file.dart';
import 'package:test/test.dart';

import '../../common.dart';

const plistFileWithArray = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <array>
    <dict>
      <key>IconName</key>
      <string>largeIcon.png</string>
      <key>ImageSize</key>
      <integer>32</integer>
      <key>Selected</key>
      <true/>
    </dict>
  </array>
</plist>''';

const plistFileWithDict = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Image</key>
    <string>test.png</string>
    <key>ImageSize</key>
    <integer>32</integer>
    <key>Selected</key>
    <true/>
  </dict>
</plist>''';

const plistFileWithUpdatedDict = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Image</key>
    <string>updated.png</string>
    <key>ImageSize</key>
    <integer>64</integer>
    <key>Selected</key>
    <false/>
  </dict>
</plist>''';

PlistFile _getPlistFile({
  String? path,
  String? name,
}) {
  return PlistFile(
    path: path ?? 'some/path',
    name: name ?? 'some',
  );
}

void main() {
  group('PlistFile', () {
    test('.path', () {
      // Arrange
      final plistFile = _getPlistFile(path: 'plist_file/path', name: 'foo');

      // Act + Assert
      expect(plistFile.path, 'plist_file/path/foo.plist');
    });

    group('.exists()', () {
      test(
        'returns true when underlying file exists',
        withTempDir(() {
          // Arrange
          final plistFile = _getPlistFile();
          File(plistFile.path).createSync(recursive: true);

          // Act + Assert
          expect(plistFile.exists(), true);
        }),
      );

      test(
        'returns false when underlying file does not exist',
        withTempDir(() {
          // Arrange
          final plistFile = _getPlistFile();

          // Act + Assert
          expect(plistFile.exists(), false);
        }),
      );
    });

    group('.delete()', () {
      test(
        'deletes the file',
        withTempDir(() {
          // Arrange
          final plistFile = _getPlistFile();
          final file = File(plistFile.path)..createSync(recursive: true);

          // Act
          plistFile.delete();

          // Assert
          expect(file.existsSync(), false);
        }),
      );
    });

    group('.readDict()', () {
      test(
        'returns correct map',
        withTempDir(() {
          // Arrange
          final plistFile = _getPlistFile();
          File(plistFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(plistFileWithDict);

          // Act + Assert
          expect(
            plistFile.readDict(),
            {
              'Image': 'test.png',
              'ImageSize': 32,
              'Selected': true,
            },
          );
        }),
      );

      test(
        'throws PlistRootIsNotDict when root is not a dict',
        withTempDir(() {
          // Arrange
          final plistFile = _getPlistFile();
          File(plistFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(plistFileWithArray);

          // Act + Assert
          expect(
              () => plistFile.readDict(), throwsA(isA<PlistRootIsNotDict>()));
        }),
      );
    });

    group('.setDict()', () {
      test(
        'sets the dict correctly',
        withTempDir(() {
          // Arrange
          final plistFile = _getPlistFile();
          final file = File(plistFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(plistFileWithDict);

          // Act
          plistFile.setDict({
            'Image': 'updated.png',
            'ImageSize': 64,
            'Selected': false,
          });

          // Assert
          expect(file.readAsStringSync(), plistFileWithUpdatedDict);
        }),
      );

      test(
        'throws PlistRootIsNotDict when root is not a dict',
        withTempDir(() {
          // Arrange
          final plistFile = _getPlistFile();
          File(plistFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(plistFileWithArray);

          // Act + Assert
          expect(
              () => plistFile.setDict({}), throwsA(isA<PlistRootIsNotDict>()));
        }),
      );
    });
  });
}
