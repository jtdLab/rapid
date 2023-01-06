import 'package:injectable/injectable.dart' hide test;
import 'package:rapid_di/src/platform.dart';
import 'package:test/test.dart';

void main() {
  group('Platform', () {
    group('.android', () {
      test('returns "android"', () {
        expect(Platform.android, 'android');
      });
    });

    group('.ios', () {
      test('returns "ios"', () {
        expect(Platform.ios, 'ios');
      });
    });

    group('.macos', () {
      test('returns "macos"', () {
        expect(Platform.macos, 'macos');
      });
    });

    group('.linux', () {
      test('returns "linux"', () {
        expect(Platform.linux, 'linux');
      });
    });

    group('.web', () {
      test('returns "web"', () {
        expect(Platform.web, 'web');
      });
    });

    group('.windows', () {
      test('returns "windows"', () {
        expect(Platform.windows, 'windows');
      });
    });
  });

  group('.android', () {
    test('returns environment with name "android"', () {
      expect(
        android,
        isA<Environment>().having((e) => e.name, 'name', 'android'),
      );
    });
  });

  group('.ios', () {
    test('returns environment with name "ios"', () {
      expect(
        ios,
        isA<Environment>().having((e) => e.name, 'name', 'ios'),
      );
    });
  });

  group('.macos', () {
    test('returns environment with name "macos"', () {
      expect(
        macos,
        isA<Environment>().having((e) => e.name, 'name', 'macos'),
      );
    });
  });

  group('.linux', () {
    test('returns environment with name "linux"', () {
      expect(
        linux,
        isA<Environment>().having((e) => e.name, 'name', 'linux'),
      );
    });
  });

  group('.web', () {
    test('returns environment with name "web"', () {
      expect(
        web,
        isA<Environment>().having((e) => e.name, 'name', 'web'),
      );
    });
  });

  group('.windows', () {
    test('returns environment with name "windows"', () {
      expect(
        windows,
        isA<Environment>().having((e) => e.name, 'name', 'windows'),
      );
    });
  });
}
