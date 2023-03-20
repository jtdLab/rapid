import 'package:injectable/injectable.dart' show Environment;
import 'package:test/test.dart';
import 'package:project_linux_di/src/annotations.dart';

void main() {
  group('Platform', () {
    test('.android', () {
      expect(Platform.android, 'android');
    });

    test('.ios', () {
      expect(Platform.ios, 'ios');
    });

    test('.linux', () {
      expect(Platform.linux, 'linux');
    });

    test('.macos', () {
      expect(Platform.macos, 'macos');
    });

    test('.web', () {
      expect(Platform.web, 'web');
    });

    test('.windows', () {
      expect(Platform.windows, 'windows');
    });
  });

  test('android', () {
    expect(
      android,
      isA<Environment>().having((e) => e.name, 'name', 'android'),
    );
  });

  test('ios', () {
    expect(ios, isA<Environment>().having((e) => e.name, 'name', 'ios'));
  });

  test('linux', () {
    expect(linux, isA<Environment>().having((e) => e.name, 'name', 'linux'));
  });

  test('macos', () {
    expect(macos, isA<Environment>().having((e) => e.name, 'name', 'macos'));
  });

  test('web', () {
    expect(web, isA<Environment>().having((e) => e.name, 'name', 'web'));
  });

  test('windows', () {
    expect(
      windows,
      isA<Environment>().having((e) => e.name, 'name', 'windows'),
    );
  });
}
