/// The platforms a Rapid project might support.
enum Platform { android, ios, web, linux, macos, windows }

extension PlatformX on Platform {
  List<String> get aliases {
    switch (this) {
      case Platform.android:
        return ['a'];
      case Platform.ios:
        return ['i'];
      case Platform.web:
        return [];
      case Platform.linux:
        return ['l', 'lin'];
      case Platform.macos:
        return ['m', 'mac'];
      case Platform.windows:
        return ['win'];
    }
  }

  String get flutterConfigName {
    switch (this) {
      case Platform.android:
        return 'android';
      case Platform.ios:
        return 'ios';
      case Platform.web:
        return 'web';
      case Platform.linux:
        return 'linux-desktop';
      case Platform.macos:
        return 'macos-desktop';
      case Platform.windows:
        return 'windows-desktop';
    }
  }

  String get prettyName {
    switch (this) {
      case Platform.android:
        return 'Android';
      case Platform.ios:
        return 'iOS';
      case Platform.web:
        return 'Web';
      case Platform.linux:
        return 'Linux';
      case Platform.macos:
        return 'macOS';
      case Platform.windows:
        return 'Windows';
    }
  }
}
