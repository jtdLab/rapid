import 'package:rapid_cli/src/project/platform.dart';

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
        return ['mac'];
      case Platform.windows:
        return ['win'];
      case Platform.mobile:
        return [];
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
      case Platform.mobile:
        return 'Mobile';
    }
  }
}
