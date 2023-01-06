import 'package:injectable/injectable.dart';

/// Used to annotate dependencies which are
/// registered under certain platforms
abstract class Platform {
  /// preset of common platform name 'android'
  static const android = 'android';

  /// preset of common platform name 'ios'
  static const ios = 'ios';

  /// preset of common platform name 'web'
  static const web = 'web';

  /// preset of common platform name 'linux'
  static const linux = 'linux';

  /// preset of common platform name 'macos'
  static const macos = 'macos';

  /// preset of common platform name 'windows'
  static const windows = 'windows';
}

/// preset instance of common platform name
const android = Environment(Platform.android);

/// preset instance of common platform name
const ios = Environment(Platform.ios);

/// preset instance of common platform name
const web = Environment(Platform.web);

/// preset instance of common platform name
const linux = Environment(Platform.linux);

/// preset instance of common platform name
const macos = Environment(Platform.macos);

/// preset instance of common platform name
const windows = Environment(Platform.windows);
